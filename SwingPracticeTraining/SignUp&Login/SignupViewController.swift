import UIKit
import FirebaseFirestore

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var showErrorLabel: UILabel!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    private var firebase = Firestore.firestore()
    private var documentId: String?
    
    private var pickerView: UIPickerView = UIPickerView()
    private let placeList = ["北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県", "その他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SignupViewController.done))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SignupViewController.cancel))
        toolbar.setItems([cancelItem, spacelItem, doneItem], animated: true)
        
        self.placeTextField.inputView = pickerView
        self.placeTextField.inputAccessoryView = toolbar
        
        nameTextField.delegate = self
        placeTextField.delegate = self
        
        signupButton.isEnabled = false
        signupButton.backgroundColor = .gray
        signupButton.layer.cornerRadius = 10
        
        signupButton.addTarget(self, action: #selector(tappedCreateUserButton), for: .touchUpInside)
        alreadyHaveAccountButton.addTarget(self, action: #selector(tappedAlreadyHaveAccountButton), for: .touchUpInside)
    }
    
    @objc private func cancel() {
        self.placeTextField.text = ""
        self.placeTextField.endEditing(true)
    }

    @objc private func done() {
        self.placeTextField.endEditing(true)
    }
    
    @objc private func tappedCreateUserButton() {
        guard let userName = nameTextField.text else { return }
        guard let userPlace = placeTextField.text else { return }
        let doc = [
            "userName" : userName,
            "userPlace" : userPlace,
            "totalCount" : 0,
            "type01Total" : 0,
            "type02Total" : 0,
            "type03Total" : 0,
            "type04Total" : 0
            ] as [String : Any]
        // FirestoreでUser情報を保存
        firebase.collection("user").addDocument(data: doc)
        // FirestoreからUserのdocumentIdを取得
        firebase.collection("user").whereField("userName", isEqualTo: userName).getDocuments() { (document, err) in
            if err != nil {
                print("ユーザデータの取得に失敗しました")
            }
            for doc in document!.documents {
                print("\(doc.documentID) => \(doc.data())")
                self.documentId = doc.documentID
            }
            // UserDefaultsでUserの名前とFirestoreのdocumentIdを保存
            self.addUserFromUserDefaults()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addUserFromUserDefaults() {
        guard let userName = nameTextField.text else { return }
        UserDefaults.standard.set(userName, forKey: "name")
        UserDefaults.standard.set(documentId, forKey: "\(userName)")
        print(UserDefaults.standard.string(forKey: "\(userName)")!)
    }
    
    @objc private func tappedAlreadyHaveAccountButton() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nameIsEmpty = nameTextField.text?.isEmpty ?? false
        let placeIsEmpty = placeTextField.text?.isEmpty ?? false
        
        if nameIsEmpty || placeIsEmpty {
            signupButton.isEnabled = false
            signupButton.backgroundColor = .gray
            showErrorLabel.text = "入力されていない項目があります"
        } else {
            signupButton.isEnabled = true
            signupButton.backgroundColor = .rgb(red: 242, green: 213, blue: 224, alpha: 1)
            showErrorLabel.text = ""
        }
    }
}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placeList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.placeTextField.text = placeList[row]
    }
}
