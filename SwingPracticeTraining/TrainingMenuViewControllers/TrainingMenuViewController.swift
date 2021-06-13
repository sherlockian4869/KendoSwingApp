import UIKit
import FirebaseFirestore

class TrainingMenuViewController: UIViewController {
    
    @IBOutlet weak var trainingMenuTableView: UITableView!
    @IBOutlet weak var createMenuButton: UIButton!
    
    private var firebase = Firestore.firestore()
    private var swingType: Int?
    private var trainingList = [TrainingData]()
    
    //　送るデータの箱
    var trainingTitle: String?
    var trainingId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        fetchDataFromFirestore()
    }
    
    private func setUpView() {
        createMenuButton.layer.cornerRadius = 8
        
        trainingMenuTableView.delegate = self
        trainingMenuTableView.dataSource = self
    }
    
    private func fetchDataFromFirestore() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        
        firebase.collection("user").document(documentId).collection("swingMenu").addSnapshotListener { (snapshots, err) in
            if err != nil {
                print("データの取得に失敗しました")
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let trainingId = documentChange.document.documentID
                    let trainingObject = documentChange.document.data()
                    guard let trainingTitle = trainingObject["swingTitle"] else { return }

                    
                    let training = TrainingData(trainingTitle: trainingTitle as? String, trainingId: trainingId)
                    self.trainingList.append(training)
                    self.trainingMenuTableView.reloadData()
                    
                case .modified, .removed:
                    print("Nothing To Do")
                }
            })
        }
    }
}

extension TrainingMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TrainingMenuTableViewCell
        let training: TrainingData
        training = trainingList[indexPath.row]
        cell.trainingMenuLabel.text = training.trainingTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // セルタップ時に次の画面へ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let training: TrainingData
        training = trainingList[indexPath.row]
        trainingTitle = training.trainingTitle
        trainingId = training.trainingId

        // セルの選択を解除
        trainingMenuTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "NextView", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextView" {
            let nextVC = segue.destination as? ShowTrainingViewController
            nextVC?.trainingTitle = trainingTitle
            nextVC?.trainingId = trainingId
        }
    }
}

class TrainingMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainingMenuLabel: UILabel!
    @IBOutlet weak var trainingMenuView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trainingMenuView.layer.cornerRadius = 10
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
