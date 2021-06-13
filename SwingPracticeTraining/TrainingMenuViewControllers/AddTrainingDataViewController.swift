import UIKit
import FirebaseFirestore

class AddTrainingDataViewController: UIViewController {
    
    private var firebase = Firestore.firestore()
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var category01TextField: UITextField!
    @IBOutlet weak var category02TextField: UITextField!
    @IBOutlet weak var category03TextField: UITextField!
    @IBOutlet weak var count01TextField: UITextField!
    @IBOutlet weak var count02TextField: UITextField!
    @IBOutlet weak var count03TextField: UITextField!
    
    @IBOutlet weak var registButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registButton.addTarget(self, action: #selector(tappedRegistButton), for: .touchUpInside)
        registButton.layer.cornerRadius = 8
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func tappedRegistButton() {
        guard let title = titleTextField.text else { return }
        guard let cate01 = category01TextField.text else { return }
        guard let cate02 = category02TextField.text else { return }
        guard let cate03 = category03TextField.text else { return }
        guard let count01 = count01TextField.text else { return }
        guard let count02 = count02TextField.text else { return }
        guard let count03 = count03TextField.text else { return }
        
        let total = counter(count01: Int(count01) ?? 0, count02: Int(count02) ?? 0, count03: Int(count03) ?? 0)
        let dic = [
            "achivementCount" : 0,
            "swingTitle" : title,
            "totalCount" : total,
            "trainingTime" : 0,
            "type01" : [cate01, Int(count01) ?? 0],
            "type02" : [cate02, Int(count02) ?? 0],
            "type03" : [cate03, Int(count03) ?? 0]
        ] as [String : Any]
        
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        
        // 前の画面に戻る
        navigationController?.popViewController(animated: true)
    }
    
    func counter(count01: Int, count02: Int, count03: Int)-> Int {
        var totalCount: Int
        totalCount = count01 + count02 + count03
        return totalCount
    }
}
