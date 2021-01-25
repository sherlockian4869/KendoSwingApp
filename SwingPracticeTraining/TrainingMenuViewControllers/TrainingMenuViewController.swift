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
    var type01: String?
    var count01: Int?
    var type02: String?
    var count02: Int?
    var type03: String?
    var count03: Int?
    var type04: String?
    var count04: Int?
    
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
                    guard let trainingType = trainingObject["swingType"] else { return }
                    guard let type01 = trainingObject["swingtype01"] else { return }
                    guard let count01 = trainingObject["swingCount01"] else { return }
                    guard let type02 = trainingObject["swingtype02"] else { return }
                    guard let count02 = trainingObject["swingCount02"] else { return }
                    guard let type03 = trainingObject["swingtype03"] else { return }
                    guard let count03 = trainingObject["swingCount03"] else { return }
                    guard let type04 = trainingObject["swingtype04"] else { return }
                    guard let count04 = trainingObject["swingCount04"] else { return }

                    
                    let training = TrainingData(trainingTitle: trainingTitle as? String, trainingType: trainingType as? Int, trainingId: trainingId, type01: type01 as? String, count01: count01 as? Int, type02: type02 as? String, count02: count02 as? Int, type03: type03 as? String, count03: count03 as? Int, type04: type04 as? String, count04: count04 as? Int)
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
        return 80
    }
    
    // セルタップ時に次の画面へ遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let training: TrainingData
        training = trainingList[indexPath.row]
        trainingTitle = training.trainingTitle
        trainingId = training.trainingId
        type01 = training.type01
        count01 = training.count01
        type02 = training.type02
        count02 = training.count02
        type03 = training.type03
        count03 = training.count03
        type04 = training.type04
        count04 = training.count04
        // セルの選択を解除
        trainingMenuTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "NextView", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextView" {
            let nextVC = segue.destination as! ShowTrainingMenuViewController
            nextVC.trainingTitle = trainingTitle
            nextVC.trainingId = trainingId
            nextVC.type01 = type01
            nextVC.count01 = count01
            nextVC.type02 = type02
            nextVC.count02 = count02
            nextVC.type03 = type03
            nextVC.count03 = count03
            nextVC.type04 = type04
            nextVC.count04 = count04
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
