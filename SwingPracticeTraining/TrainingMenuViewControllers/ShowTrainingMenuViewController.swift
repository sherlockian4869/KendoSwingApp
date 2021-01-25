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
    
    //　受け取るデータの箱
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
        type01Label.text = type01
        count01Label.text = String(count01!)
        type02Label.text = type02
        count02Label.text = String(count02!)
        type03Label.text = type03
        count03Label.text = String(count03!)
        type04Label.text = type04
        count04Label.text = String(count04!)
    }
    
    @objc private func navFinishButton() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        let alert: UIAlertController = UIAlertController(title: "終了", message: "本当に終了しますか？", preferredStyle:  UIAlertController.Style.alert)
        
        let finishAction: UIAlertAction = UIAlertAction(title: "終了", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.tabBarController!.tabBar.items![0].isEnabled = true
            self.tabBarController!.tabBar.items![1].isEnabled = true
            self.tabBarController!.tabBar.items![2].isEnabled = true
            self.navigationController?.popToRootViewController(animated: true)
            
            // トレーニング時間をFirebaseに格納
            self.firebase.collection("user").document(documentId).collection("swingMenu").document(self.trainingId!).updateData(["trainingTime" : self.timerTotalDuration])
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(finishAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func tappedStartButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
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
