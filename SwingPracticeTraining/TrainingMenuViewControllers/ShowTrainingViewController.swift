import UIKit
import FirebaseFirestore

class ShowTrainingViewController: UIViewController {
    
    private var firebase = Firestore.firestore()
    // firebaseから取得したデータを入れる配列
    var menuList = [[Any]]()
    
    // ストップウォッチの変数
    private var timer: Timer?
    private var timerRunning: Bool = false
    private var timerTotalDuration: TimeInterval = 0.0
    
    // カウント
    private var totalCount: Int?
    private var menuCount: Int?
    private var achievementCount: Int?
    private var timeCount: TimeInterval?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var trainingTitle: String?
    var trainingId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getDataFromFirebase()
    }
    
    func setUpView() {
        // Buttonを押した時の処理
        titleLabel.text = trainingTitle
        
        // Buttonの設定
        startButton.layer.cornerRadius = 15
        finishButton.layer.cornerRadius = 15
        
        // TableView
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
        
        // labelのフォント
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 60, weight: .medium)
        
        // buttonのチェック
        startButton.isEnabled = true
        finishButton.isEnabled = false
        finishButton.backgroundColor = .gray
        // Buttonを押した時の処理
        startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(tappedFinishButton), for: .touchUpInside)
        
        // navigationbar終了button
        let rightButton = UIBarButtonItem(title: "終了", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ShowTrainingViewController.navFinishButton))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func getDataFromFirebase(){
        // UserDefaultsからdocumentIdを取得
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        // countを引っ張ってくる
        firebase.collection("user").document(documentId).getDocument { snapshot, err in
            if(err != nil) {
                print("error")
            } else {
                let data = snapshot?.data()
                self.totalCount = data?["totalCount"] as? Int
            }
        }
        
        // Menuを引っ張ってくる
        firebase.collection("user").document(documentId).collection("swingMenu").document(trainingId!).getDocument { snapshot, error in
            if(error != nil) {
                print("error")
            } else {
                let data = snapshot?.data()
                self.menuCount = data?["totalCount"] as? Int
                self.achievementCount = data?["achievementCount"] as? Int
                self.timeCount = data?["trainingTime"] as? TimeInterval
                self.menuList.append(data?["type01"] as Any as! [Any])
                self.menuList.append(data?["type02"] as Any as! [Any])
                self.menuList.append(data?["type03"] as Any as! [Any])
                self.MenuTableView.reloadData()
            }
        }
    }
    
    @objc private func navFinishButton() {
        // 終了Buttonを押した時に出るアラート
        let alert: UIAlertController = UIAlertController(title: "終了", message: "本当に終了しますか？", preferredStyle:  UIAlertController.Style.alert)
        
        let finishAction: UIAlertAction = UIAlertAction(title: "終了", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            // timerの消去、tabbarが押せる
            self.timer?.invalidate()
            self.tabBarController!.tabBar.items![0].isEnabled = true
            self.tabBarController!.tabBar.items![1].isEnabled = true
            // firebaseに格納
            self.addDataToFirestore()
            // 前の画面へ遷移
            self.navigationController?.popToRootViewController(animated: true)
        })
        // キャンセルを押した時の処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(finishAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func tappedStartButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        if timerRunning == false {
            startButton.isEnabled = false
            startButton.backgroundColor = .gray
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(ShowTrainingViewController.handleTimer),
                userInfo: nil,
                repeats: true
            )
            timerRunning = true
            // finishButtonを押せるようになる
            finishButton.isEnabled = true
            finishButton.backgroundColor = .orange
            tabBarController!.tabBar.items![0].isEnabled = false
            tabBarController!.tabBar.items![1].isEnabled = false
        } else {
            // startButtonを押せないようにする
            startButton.isEnabled = false
            startButton.backgroundColor = .gray
        }
    }
    
    @objc private func tappedFinishButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if timerRunning == true {
            // finishButtonを押せないようにする
            timer?.invalidate()
            finishButton.isEnabled = false
            finishButton.backgroundColor = .gray
            // startButtonを押せるようにする
            startButton.isEnabled = true
            startButton.backgroundColor = .green
        }
        timerRunning = false
        
    }
    
    // ストップウォッチのカウントとカウントした値をLabelに表示
    @objc private func handleTimer() {
        timerTotalDuration += 1
        let second = Int(self.timerTotalDuration) % 60
        let minutes = Int(self.timerTotalDuration / 60)
        let hour = Int(self.timerTotalDuration / 24)
        timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, second)
    }
    
    private func addDataToFirestore() {
        // UserDefaultsからdocumentIdを取得
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        self.achievementCount! += 1
        self.timeCount! += timerTotalDuration
        // トレーニング時間をFirebaseに格納
        self.firebase.collection("user").document(documentId).collection("swingMenu").document(self.trainingId!).updateData([
            "achievementCount" : achievementCount!,
            "trainingTime" : timeCount!,
        ])
        totalCount! += menuCount!
        // totalCountに追加
        self.firebase.collection("user").document(documentId).updateData(["totalCount" : totalCount!])
    }
    
}

extension ShowTrainingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.typeLabel.text = "\(menuList[indexPath.row][0])"
        if(menuList[indexPath.row][1] as! Int == 0){
            cell.countLabel.text = ""
        } else {
            cell.countLabel.text = "\(menuList[indexPath.row][1])本"
        }
        return cell
    }
    
    
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
