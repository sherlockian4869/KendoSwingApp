import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var rankingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rankingTableView: UITableView!
    
    private var firebase = Firestore.firestore()
    var userData = [UserData]()
    var userPlace: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmLoggedInUser()
        setUpView()
        selectedSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = UserDefaults.standard.string(forKey: "name") else { return }
        guard let id = UserDefaults.standard.string(forKey: "\(user)") else { return }
        print(user)
        print(id)
    }
    
    @IBAction func rankingSegmentedControlTapped(_ sender: Any) {
        selectedSegmentedControl()
    }
    
    private func selectedSegmentedControl() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        firebase.collection("user").document(documentId).getDocument { (document, err) in
            if err != nil {
                print("データの取得に失敗しました")
            } else {
                let place = document?.data()
                self.userPlace = place?["userPlace"] as! String
            }
        }
        
        switch rankingSegmentedControl.selectedSegmentIndex {
        case 0:
            userData.removeAll()
            rankingTableView.reloadData()
            firebase.collection("user").order(by: "totalCount", descending: true).addSnapshotListener { (snapshots, err) in
                if err != nil {
                    print("データの取得に失敗しました")
                }
                snapshots?.documentChanges.forEach({ (documentChange) in
                    switch documentChange.type {
                    case .added:
                        let rankObject = documentChange.document.data()
                        guard let rankUser = rankObject["userName"] else { return }
                        guard let rankCount = rankObject["totalCount"] else { return }
                        
                        let ranking = UserData(username: rankUser as? String, totalCount: rankCount as? Int)
                        self.userData.append(ranking)
                        self.rankingTableView.reloadData()
                                                
                    case .modified, .removed:
                        print("Nothing To Do")
                    }
                })
            }
            
        case 1:
            print(2)
            userData.removeAll()
            rankingTableView.reloadData()
            firebase.collection("user").document(documentId).getDocument { (document, err) in
                if err != nil {
                    print("userPlaceの取得に失敗しました")
                } else if let document = document {
                    let placeObject = document.data()
                    let place = placeObject?["userPlace"]
                    self.firebase.collection("user").whereField("userPlace", isEqualTo: place!).order(by: "totalCount", descending: true).addSnapshotListener { (snapshots, err) in
                        if err != nil {
                            print("placeRankingデータの取得に失敗しました")
                        }
                        snapshots?.documentChanges.forEach({ (documentChange) in
                            switch documentChange.type {
                            case .added:
                                let rankObject = documentChange.document.data()
                                guard let rankUser = rankObject["userName"] else { return }
                                guard let rankCount = rankObject["totalCount"] else { return }
                                
                                let ranking = UserData(username: rankUser as? String, totalCount: rankCount as? Int)
                                self.userData.append(ranking)
                                self.rankingTableView.reloadData()
                                
                            case .modified, .removed:
                                print("Nothing To Do")
                            }
                        })
                    }
                }
            }
        default:
            break
        }
    }
    
    private func setUpView() {
        let logoutBarButton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(tappedNavLeftBarButton))
        navigationItem.leftBarButtonItem = logoutBarButton
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
    }
    
    @objc private func tappedNavLeftBarButton() {
        UserDefaults.standard.removeObject(forKey: "name")
        pushLoginViewController()
    }
    
    private func confirmLoggedInUser() {
        if UserDefaults.standard.object(forKey: "name") == nil {
            pushLoginViewController()
        }
    }
    
    private func pushLoginViewController() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        let nav = UINavigationController(rootViewController: signUpViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rankingTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        let rank: UserData
        rank = userData[indexPath.row]
        cell.userNameLabel.text = rank.username
        cell.totalCountLabel.text = "\(rank.totalCount!)本"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var homeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeView.layer.cornerRadius = 10
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
