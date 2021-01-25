import UIKit
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var showErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    private var firebase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        nameTextField.delegate = self
        
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = .gray
        
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccountButton), for: .touchUpInside)
    }
    
    @objc private func tappedDontHaveAccountButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedLoginButton() {
        guard let name = nameTextField.text else { return }
        guard let id = UserDefaults.standard.string(forKey: "\(name)") else { return }
        
        firebase.collection("user").document(id).getDocument { (document, err) in
            if err != nil {
                print("user情報と一致していません")
            }
            if document?.documentID == id {
                self.dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(name, forKey: "name")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let nameIsEmpty = nameTextField.text?.isEmpty ?? false
        
        if nameIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .gray
            showErrorLabel.text = "入力されていない項目があります"
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 1)
            showErrorLabel.text = ""
        }
    }
}
