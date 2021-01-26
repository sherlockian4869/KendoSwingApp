import UIKit
import FirebaseFirestore

class ShowTrainingMenuViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var type01Label: UILabel!
    @IBOutlet weak var count01Label: UILabel!
    @IBOutlet weak var type02Label: UILabel!
    @IBOutlet weak var count02Label: UILabel!
    @IBOutlet weak var type03Label: UILabel!
    @IBOutlet weak var count03Label: UILabel!
    @IBOutlet weak var type04Label: UILabel!
    @IBOutlet weak var count04Label: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // ストップウォッチの変数
    private var timer: Timer?
    private var timerRunning: Bool = false
    private var timerTotalDuration: TimeInterval = 0.0
    
    //　データベース
    private var firebase = Firestore.firestore()
    
    var getType01List = [Any]()
    var getType02List = [Any]()
    var getType03List = [Any]()
    var getType04List = [Any]()
    var achievementCount: Int?
    var totalCount: Int?
    
    var type01Counter: Double = 0 // 上下素振り
    var type02Counter: Double = 0 // 正面素振り
    var type03Counter: Double = 0 // 左右素振り
    var type04Counter: Double = 0 // 速素振り
    
    //　受け取るデータの箱
    var trainingTitle: String?
    var trainingId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        getDataFromFirebase()
    }
    
    private func setUpView() {
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 65, weight: .medium)
        
        startButton.layer.cornerRadius = 35
        finishButton.layer.cornerRadius = 35
        
        startButton.isEnabled = true
        finishButton.isEnabled = false
        
        startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(tappedFinishButton), for: .touchUpInside)
        
        let rightButton = UIBarButtonItem(title: "終了", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ShowTrainingMenuViewController.navFinishButton))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleLabel.text = trainingTitle
    }
    
    private func getDataFromFirebase() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        firebase.collection("user").document(documentId).collection("swingMenu").document(trainingId!).getDocument { (document, err) in
            if err != nil {
                print("データの取得に失敗しました")
            }
            let dataCounter = document?.data()
            self.getType01List = dataCounter?["type01"] as! [Any]
            self.getType02List = dataCounter?["type02"] as! [Any]
            self.getType03List = dataCounter?["type03"] as! [Any]
            self.getType04List = dataCounter?["type04"] as! [Any]
            self.achievementCount = dataCounter?["achievementCount"] as? Int
            self.totalCount = dataCounter?["totalCount"] as? Int
            
            self.type01Label.text = self.getType01List[0] as? String
            self.type02Label.text = self.getType02List[0] as? String
            self.type03Label.text = self.getType03List[0] as? String
            self.type04Label.text = self.getType04List[0] as? String

            self.type01Counter = (self.getType01List[1] as? Double)!
            self.type02Counter = (self.getType02List[1] as? Double)!
            self.type03Counter = (self.getType03List[1] as? Double)!
            self.type04Counter = (self.getType04List[1] as? Double)!
            
            self.count01Label.text = "\(Int(self.type01Counter))本"
            self.count02Label.text = "\(Int(self.type02Counter))本"
            self.count03Label.text = "\(Int(self.type03Counter))本"
            self.count04Label.text = "\(Int(self.type04Counter))本"
            
            print(self.type01Counter)
        }
    }
    
    @objc private func navFinishButton() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        let alert: UIAlertController = UIAlertController(title: "終了", message: "本当に終了しますか？", preferredStyle:  UIAlertController.Style.alert)
        
        let finishAction: UIAlertAction = UIAlertAction(title: "終了", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.timer?.invalidate()
            self.tabBarController!.tabBar.items![0].isEnabled = true
            self.tabBarController!.tabBar.items![1].isEnabled = true
            self.tabBarController!.tabBar.items![2].isEnabled = true
            self.navigationController?.popToRootViewController(animated: true)
            self.achievementCount! += 1
            
            self.totalCount! += Int(self.type01Counter + self.type02Counter + self.type03Counter + self.type04Counter)
            
            // トレーニング時間をFirebaseに格納
            self.firebase.collection("user").document(documentId).collection("swingMenu").document(self.trainingId!).updateData([
                "trainingTime" : self.timerTotalDuration,
                "achievementCount" : self.achievementCount!,
                "totalCount" : self.totalCount!
            ])
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(finishAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func tappedStartButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if timerRunning == false {
            startButton.isEnabled = false
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(ShowTrainingMenuViewController.handleTimer),
                userInfo: nil,
                repeats: true
            )
            timerRunning = true
            self.finishButton.isEnabled = true
            
        } else {
            self.startButton.isEnabled = true
        }
    }
    
    @objc private func tappedFinishButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if timerRunning == true {
            timer?.invalidate()
            self.finishButton.isEnabled = false
            self.startButton.isEnabled = true
        }
        timerRunning = false
        
    }
    
    @objc private func handleTimer() {
        timerTotalDuration += 1
        let second = Int(self.timerTotalDuration) % 60
        let minutes = Int(self.timerTotalDuration / 60)
        let hour = Int(self.timerTotalDuration / 24)
        self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, second)
        print("timer fired. total: \(timerTotalDuration)")
    }
}
