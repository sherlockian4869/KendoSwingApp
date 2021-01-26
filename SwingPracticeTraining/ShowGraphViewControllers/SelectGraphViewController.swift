import UIKit
import FirebaseFirestore

class SelectGraphViewController: UIViewController {

    @IBOutlet weak var selectTableView: UITableView!
    private var dataList = [TrainingData]()
    
    private var firebase = Firestore.firestore()
    var documentId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        getDataFromFirestore()
    }
    
    private func setUpView() {
        selectTableView.delegate = self
        selectTableView.dataSource = self
    }
    
    private func getDataFromFirestore() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        firebase.collection("user").document(documentId).collection("swingMenu").addSnapshotListener { (snapshots, err) in
            if err != nil {
                
            }
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let dataDocumentId = documentChange.document.documentID
                    let dataObject = documentChange.document.data() as [String:AnyObject]
                    let title = dataObject["swingTitle"]
                   
                    let data = TrainingData(trainingTitle: title as? String, trainingId: dataDocumentId)
                    self.dataList.append(data)
                    
                    self.selectTableView.reloadData()
                    
                case .modified, .removed:
                    print("Nothing To Do")
                }
            })
        }
    }
}

extension SelectGraphViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectTableViewCell
        let data: TrainingData
        data = dataList[indexPath.row]
        cell.selectLabel.text = data.trainingTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // セルタップ時に次の画面へ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: TrainingData
        data = dataList[indexPath.row]
        documentId = data.trainingId

        // セルの選択を解除
        selectTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "NextView", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextView" {
            let nextVC = segue.destination as! GraphViewController
            nextVC.trainingId = documentId
        }
    }
    
}

class SelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectView.layer.cornerRadius = 10
        // セル選択時の色を変更
        selectedBackgroundView = makeSelectedBackgroundView()
    }
    // セル選択時の背景色をを白にする処理
    private func makeSelectedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
