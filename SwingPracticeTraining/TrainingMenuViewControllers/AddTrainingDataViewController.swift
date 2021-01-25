import UIKit
import FirebaseFirestore

class AddTrainingDataViewController: UIViewController {
    
    @IBOutlet weak var trainingTitleTextField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countStepper: UIStepper!
    
    @IBOutlet weak var swingType01: UITextField!
    @IBOutlet weak var swingType02: UITextField!
    @IBOutlet weak var swingType03: UITextField!
    @IBOutlet weak var swingType04: UITextField!
    
    @IBOutlet weak var swingCount01: UITextField!
    @IBOutlet weak var swingCount02: UITextField!
    @IBOutlet weak var swingCount03: UITextField!
    @IBOutlet weak var swingCount04: UITextField!
    
    @IBOutlet weak var showErrorLabel: UILabel!
    @IBOutlet weak var addDataButton: UIButton!
    
    private var firebase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        addDataButton.layer.cornerRadius = 8
        addDataButton.backgroundColor = .lightGray
        addDataButton.isEnabled = false
        addDataButton.addTarget(self, action: #selector(tappedAddDataButton), for: .touchUpInside)
        trainingTitleTextField.delegate = self
        // 全てのTextFieldの初期設定
        swingType01.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
        swingType01.isEnabled = true
        swingType02.backgroundColor = .lightGray
        swingType02.isEnabled = false
        swingType03.backgroundColor = .lightGray
        swingType03.isEnabled = false
        swingType04.backgroundColor = .lightGray
        swingType04.isEnabled = false
        swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
        swingCount01.isEnabled = true
        swingCount02.backgroundColor = .lightGray
        swingCount02.isEnabled = false
        swingCount03.backgroundColor = .lightGray
        swingCount03.isEnabled = false
        swingCount04.backgroundColor = .lightGray
        swingCount04.isEnabled = false
        
        // TextFieldのdelegate
        swingType01.delegate = self
        swingType02.delegate = self
        swingType03.delegate = self
        swingType04.delegate = self
        swingCount01.delegate = self
        swingCount02.delegate = self
        swingCount03.delegate = self
        swingCount04.delegate = self
        
    }
    
    @IBAction func stepperChange(_ sender: Any) {
        countLabel.text = String(Int(countStepper.value))
        setUpStepper()
    }
    
    private func setUpStepper() {
        switch countStepper.value {
        case 1:
            print(1)
            // typeのTextField
            swingType01.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType01.isEnabled = true
            swingType02.backgroundColor = .lightGray
            swingType02.isEnabled = false
            swingType03.backgroundColor = .lightGray
            swingType03.isEnabled = false
            swingType04.backgroundColor = .lightGray
            swingType04.isEnabled = false
            // countのTextField
            swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount01.isEnabled = true
            swingCount02.backgroundColor = .lightGray
            swingCount02.isEnabled = false
            swingCount03.backgroundColor = .lightGray
            swingCount03.isEnabled = false
            swingCount04.backgroundColor = .lightGray
            swingCount04.isEnabled = false
        case 2:
            print(2)
            // typeのTextField
            swingType01.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType01.isEnabled = true
            swingType02.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType02.isEnabled = true
            swingType03.backgroundColor = .lightGray
            swingType03.isEnabled = false
            swingType04.backgroundColor = .lightGray
            swingType04.isEnabled = false
            // countのTextField
            swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount01.isEnabled = true
            swingCount02.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount02.isEnabled = true
            swingCount03.backgroundColor = .lightGray
            swingCount03.isEnabled = false
            swingCount04.backgroundColor = .lightGray
            swingCount04.isEnabled = false
        case 3:
            print(3)
            // typeのTextField
            swingType01.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType01.isEnabled = true
            swingType02.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType02.isEnabled = true
            swingType03.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType03.isEnabled = true
            swingType04.backgroundColor = .lightGray
            swingType04.isEnabled = false
            // countのTextField
            swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount01.isEnabled = true
            swingCount02.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount02.isEnabled = true
            swingCount03.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount03.isEnabled = true
            swingCount04.backgroundColor = .lightGray
            swingCount04.isEnabled = false
        case 4:
            print(4)
            // typeのTextField
            swingType01.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType01.isEnabled = true
            swingType02.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType02.isEnabled = true
            swingType03.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType03.isEnabled = true
            swingType04.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType04.isEnabled = true
            // countのTextField
            swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount01.isEnabled = true
            swingCount02.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount02.isEnabled = true
            swingCount03.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount03.isEnabled = true
            swingCount04.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount04.isEnabled = true
        default:
            break
        }
    }
    
    // Buttonを押した時の処理
    @objc private func tappedAddDataButton() {
        guard let title = trainingTitleTextField.text else { return}
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        
        guard let type01 = swingType01.text else { return }
        guard let count01 = swingCount01.text else { return }
        guard let type02 = swingType02.text else { return }
        guard let count02 = swingCount02.text else { return }
        guard let type03 = swingType03.text else { return }
        guard let count03 = swingCount03.text else { return }
        guard let type04 = swingType04.text else { return }
        guard let count04 = swingCount04.text else { return }
        switch countStepper.value {
        case 1:
            
            let dic = [
                "swingTitle" : title,
                "swingType" : Int(countStepper.value),
                "trainingTime" : 0,
                "trainingCount" : 0,
                "swingtype01" : type01,
                "swingCount01" : Int(count01)!,
                "swingtype02" : "なし",
                "swingCount02" : 0,
                "swingtype03" : "なし",
                "swingCount03" : 0,
                "swingtype04" : "なし",
                "swingCount04" : 0,
                ] as [String : Any]
            firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        case 2:
            
            let dic = [
                "swingTitle" : title,
                "swingType": Int(countStepper.value),
                "trainingTime" : 0,
                "trainingCount" : 0,
                "swingtype01" : type01,
                "swingCount01" : Int(count01)!,
                "swingtype02" : type02,
                "swingCount02" : Int(count02)!,
                "swingtype03" : "なし",
                "swingCount03" : 0,
                "swingtype04" : "なし",
                "swingCount04" : 0,
                ] as [String : Any]
            firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        case 3:
            let dic = [
                "swingTitle" : title,
                "swingType": Int(countStepper.value),
                "trainingTime" : 0,
                "trainingCount" : 0,
                "swingtype01" : type01,
                "swingCount01" : Int(count01)!,
                "swingtype02" : type02,
                "swingCount02" : Int(count02)!,
                "swingtype03" : type03,
                "swingCount03" : Int(count03)!,
                "swingtype04" : "なし",
                "swingCount04" : 0,
                ] as [String : Any]
            firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        case 4:
            let dic = [
                "swingTitle" : title,
                "swingType": Int(countStepper.value),
                "trainingTime" : 0,
                "trainingCount" : 0,
                "swingtype01" : type01,
                "swingCount01" : Int(count01)!,
                "swingtype02" : type02,
                "swingCount02" : Int(count02)!,
                "swingtype03" : type03,
                "swingCount03" : Int(count02)!,
                "swingtype04" : type04,
                "swingCount04" : Int(count04)!,
                ] as [String : Any]
            firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        default:
            break
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddTrainingDataViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let titleIsEmpty = trainingTitleTextField.text?.isEmpty ?? false
        
        let type01IsEmpty = swingType01.text?.isEmpty ?? false
        let type02IsEmpty = swingType02.text?.isEmpty ?? false
        let type03IsEmpty = swingType03.text?.isEmpty ?? false
        let type04IsEmpty = swingType04.text?.isEmpty ?? false
        
        let count01IsEmpty = swingCount01.text?.isEmpty ?? false
        let count02IsEmpty = swingCount02.text?.isEmpty ?? false
        let count03IsEmpty = swingCount03.text?.isEmpty ?? false
        let count04IsEmpty = swingCount04.text?.isEmpty ?? false
        
        
        switch countStepper.value {
        case 1:
            if titleIsEmpty || type01IsEmpty || count01IsEmpty {
                addDataButton.isEnabled = false
                addDataButton.backgroundColor = .lightGray
                showErrorLabel.text = "入力されていない項目があります"
            } else {
                addDataButton.isEnabled = true
                addDataButton.backgroundColor = .rgb(red: 242, green: 213, blue: 224, alpha: 1)
                showErrorLabel.text = ""
            }
        case 2:
            if titleIsEmpty || type01IsEmpty || count01IsEmpty || type02IsEmpty || count02IsEmpty {
                addDataButton.isEnabled = false
                addDataButton.backgroundColor = .lightGray
                showErrorLabel.text = "入力されていない項目があります"
            } else {
                addDataButton.isEnabled = true
                addDataButton.backgroundColor = .rgb(red: 242, green: 213, blue: 224, alpha: 1)
                showErrorLabel.text = ""
            }
        case 3:
            if titleIsEmpty || type01IsEmpty || count01IsEmpty || type02IsEmpty || count02IsEmpty || type03IsEmpty || count03IsEmpty {
                addDataButton.isEnabled = false
                addDataButton.backgroundColor = .lightGray
                showErrorLabel.text = "入力されていない項目があります"
            } else {
                addDataButton.isEnabled = true
                addDataButton.backgroundColor = .rgb(red: 242, green: 213, blue: 224, alpha: 1)
                showErrorLabel.text = ""
            }
        case 4:
            if titleIsEmpty || type01IsEmpty || count01IsEmpty || type02IsEmpty || count02IsEmpty || type03IsEmpty || count03IsEmpty || type04IsEmpty || count04IsEmpty {
                addDataButton.isEnabled = false
                addDataButton.backgroundColor = .lightGray
                showErrorLabel.text = "入力されていない項目があります"
            } else {
                addDataButton.isEnabled = true
                addDataButton.backgroundColor = .rgb(red: 242, green: 213, blue: 224, alpha: 1)
                showErrorLabel.text = ""
            }
        default:
            break
        }
    }
}
