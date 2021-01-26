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
    
    var pickerView01 = UIPickerView()
    var pickerView02 = UIPickerView()
    var pickerView03 = UIPickerView()
    var pickerView04 = UIPickerView()
    
    @IBOutlet weak var swingCount01: UITextField!
    @IBOutlet weak var swingCount02: UITextField!
    @IBOutlet weak var swingCount03: UITextField!
    @IBOutlet weak var swingCount04: UITextField!
    
    var getType01List = [Any]()
    var getType02List = [Any]()
    var getType03List = [Any]()
    var getType04List = [Any]()
    
    var notTypeList = ["なし", 0] as [Any]
    
    var swingType = ["上下素振り", "正面素振り", "左右素振り", "速素振り"]
    
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
        
        pickerView01.delegate = self
        pickerView02.delegate = self
        pickerView03.delegate = self
        pickerView04.delegate = self
        
        pickerView01.dataSource = self
        pickerView02.dataSource = self
        pickerView03.dataSource = self
        pickerView04.dataSource = self
        
        pickerView01.tag = 0
        pickerView02.tag = 1
        pickerView03.tag = 2
        pickerView04.tag = 3
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
        
        self.swingType01.inputView = pickerView01
        self.swingType02.inputView = pickerView02
        self.swingType03.inputView = pickerView03
        self.swingType04.inputView = pickerView04
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AddTrainingDataViewController.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        swingType01.inputAccessoryView = toolbar
        swingType02.inputAccessoryView = toolbar
        swingType03.inputAccessoryView = toolbar
        swingType04.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        swingType01.endEditing(true)
        swingType02.endEditing(true)
        swingType03.endEditing(true)
        swingType04.endEditing(true)
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
            swingType02.text = ""
            swingType03.backgroundColor = .lightGray
            swingType03.isEnabled = false
            swingType03.text = ""
            swingType04.backgroundColor = .lightGray
            swingType04.isEnabled = false
            swingType04.text = ""
            // countのTextField
            swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount01.isEnabled = true
            swingCount02.backgroundColor = .lightGray
            swingCount02.isEnabled = false
            swingCount02.text = ""
            swingCount03.backgroundColor = .lightGray
            swingCount03.isEnabled = false
            swingCount03.text = ""
            swingCount04.backgroundColor = .lightGray
            swingCount04.isEnabled = false
            swingCount04.text = ""
        case 2:
            print(2)
            // typeのTextField
            swingType01.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType01.isEnabled = true
            swingType02.backgroundColor = .rgb(red: 154, green: 224, blue: 97, alpha: 0.2)
            swingType02.isEnabled = true
            swingType03.backgroundColor = .lightGray
            swingType03.isEnabled = false
            swingType03.text = ""
            swingType04.backgroundColor = .lightGray
            swingType04.isEnabled = false
            swingType04.text = ""
            // countのTextField
            swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount01.isEnabled = true
            swingCount02.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount02.isEnabled = true
            swingCount03.backgroundColor = .lightGray
            swingCount03.isEnabled = false
            swingCount03.text = ""
            swingCount04.backgroundColor = .lightGray
            swingCount04.isEnabled = false
            swingCount04.text = ""
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
            swingType04.text = ""
            // countのTextField
            swingCount01.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount01.isEnabled = true
            swingCount02.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount02.isEnabled = true
            swingCount03.backgroundColor = .rgb(red: 242, green: 213, blue: 85, alpha: 0.3)
            swingCount03.isEnabled = true
            swingCount04.backgroundColor = .lightGray
            swingCount04.isEnabled = false
            swingCount04.text = ""
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
        getType01List.append(type01)
        getType01List.append(Int(count01)!)
        guard let type02 = swingType02.text else { return }
        guard let count02 = swingCount02.text else { return }
        getType02List.append(type02)
        getType02List.append(Int(count02)!)
        guard let type03 = swingType03.text else { return }
        guard let count03 = swingCount03.text else { return }
        getType03List.append(type03)
        getType03List.append(Int(count03)!)
        guard let type04 = swingType04.text else { return }
        guard let count04 = swingCount04.text else { return }
        getType04List.append(type04)
        getType04List.append(Int(count04)!)
        switch countStepper.value {
        case 1:
            
            let dic = [
                "swingTitle" : title,
                "achievementCount" : 0,
                "totalCount" : 0,
                "trainingTime" : 0,
                "type01" : getType01List,
                "type02" : notTypeList,
                "type03" : notTypeList,
                "type04" : notTypeList,
                ] as [String : Any]
            firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        case 2:
            
            let dic = [
                "swingTitle" : title,
                "achievementCount" : 0,
                "totalCount" : 0,
                "trainingTime" : 0,
                "type01" : getType01List,
                "type02" : getType02List,
                "type03" : notTypeList,
                "type04" : notTypeList,
                ] as [String : Any]
            firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        case 3:
            let dic = [
                "swingTitle" : title,
                "achievementCount" : 0,
                "totalCount" : 0,
                "trainingTime" : 0,
                "type01" : getType01List,
                "type02" : getType02List,
                "type03" : getType03List,
                "type04" : notTypeList,
                ] as [String : Any]
            firebase.collection("user").document(documentId).collection("swingMenu").addDocument(data: dic)
        case 4:
            let dic = [
                "swingTitle" : title,
                "achievementCount" : 0,
                "totalCount" : 0,
                "trainingTime" : 0,
                "type01" : getType01List,
                "type02" : getType02List,
                "type03" : getType03List,
                "type04" : getType04List,
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

extension AddTrainingDataViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int  {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView.tag == 0 {
            return swingType.count
        } else if pickerView.tag == 1 {
            return swingType.count
        } else if pickerView.tag == 2 {
            return  swingType.count
        } else if  pickerView.tag == 3 {
            return swingType.count
        }
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView.tag == 0 {
            return swingType[row]
        } else if pickerView.tag == 1 {
            return swingType[row]
        } else if pickerView.tag == 2 {
            return swingType[row]
        } else if pickerView.tag == 3 {
            return swingType[row]
        }

        return ""
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        
        if pickerView.tag == 0 {
            swingType01.text = swingType[row]
        } else if pickerView.tag == 1 {
            swingType02.text = swingType[row]
        } else if pickerView.tag == 2 {
            swingType03.text = swingType[row]
        } else if pickerView.tag == 3 {
            swingType04.text = swingType[row]
        }
    }
}
