import UIKit
import Charts
import FirebaseFirestore

class GraphViewController: UIViewController {
    
    @IBOutlet weak var pieChartsView: PieChartView!
    var trainingId: String?
    
    private var firebase = Firestore.firestore()
    
    var swingType = ["上下素振り", "正面素振り", "左右素振り", "速素振り"]
    
    var dataTitle: String?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDataFromFirestore()
        
    }
    
    private func showDataFromFirestore() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        firebase.collection("user").document(documentId).collection("swingMenu").document(trainingId!).getDocument { (document, err) in
            if err != nil {
                print("データの取得に失敗しました")
            }
            let dataCounter = document?.data()
            self.dataTitle = dataCounter?["swingTitle"] as? String
            self.getType01List = dataCounter?["type01"] as! [Any]
            self.getType02List = dataCounter?["type02"] as! [Any]
            self.getType03List = dataCounter?["type03"] as! [Any]
            self.getType04List = dataCounter?["type04"] as! [Any]
            self.achievementCount = dataCounter?["achievementCount"] as? Int
            self.totalCount = dataCounter?["totalCount"] as? Int
            
            switch self.getType01List[0] as! String {
            case self.swingType[0]:
                self.type01Counter = Double(self.getType01List[1] as! Int * self.achievementCount!)
            case self.swingType[1]:
                self.type02Counter = Double(self.getType02List[1] as! Int * self.achievementCount!)
            case self.swingType[2]:
                self.type03Counter = Double(self.getType03List[1] as! Int * self.achievementCount!)
            case self.swingType[3]:
                self.type04Counter = Double(self.getType04List[1] as! Int * self.achievementCount!)
            default:
                break
            }
            
            switch self.getType02List[0] as! String {
            case self.swingType[0]:
                self.type01Counter = Double(self.getType01List[1] as! Int * self.achievementCount!)
            case self.swingType[1]:
                self.type02Counter = Double(self.getType02List[1] as! Int * self.achievementCount!)
            case self.swingType[2]:
                self.type03Counter = Double(self.getType03List[1] as! Int * self.achievementCount!)
            case self.swingType[3]:
                self.type04Counter = Double(self.getType04List[1] as! Int * self.achievementCount!)
            default:
                break
            }
            
            switch self.getType03List[0] as! String {
            case self.swingType[0]:
                self.type01Counter = Double(self.getType01List[1] as! Int * self.achievementCount!)
            case self.swingType[1]:
                self.type02Counter = Double(self.getType02List[1] as! Int * self.achievementCount!)
            case self.swingType[2]:
                self.type03Counter = Double(self.getType03List[1] as! Int * self.achievementCount!)
            case self.swingType[3]:
                self.type04Counter = Double(self.getType04List[1] as! Int * self.achievementCount!)
            default:
                break
            }
            
            switch self.getType04List[0] as! String {
            case self.swingType[0]:
                self.type01Counter = Double(self.getType01List[1] as! Int * self.achievementCount!)
            case self.swingType[1]:
                self.type02Counter = Double(self.getType02List[1] as! Int * self.achievementCount!)
            case self.swingType[2]:
                self.type03Counter = Double(self.getType03List[1] as! Int * self.achievementCount!)
            case self.swingType[3]:
                self.type04Counter = Double(self.getType04List[1] as! Int * self.achievementCount!)
            default:
                break
            }
            
            
            print(self.type01Counter)
            print(self.type02Counter)
            print(self.type03Counter)
            print(self.type04Counter)
            self.totalCount = Int(self.type01Counter + self.type02Counter + self.type03Counter + self.type04Counter)
            print(self.totalCount!)
            self.type01Counter = self.type01Counter / Double(self.totalCount!) * 100
            self.type02Counter = self.type02Counter / Double(self.totalCount!) * 100
            self.type03Counter = self.type03Counter / Double(self.totalCount!) * 100
            self.type04Counter = self.type04Counter / Double(self.totalCount!) * 100
            self.setGraph()
            
            print(Double(self.type01Counter))
            print(self.type02Counter)
            print(self.type03Counter)
            print(self.type04Counter)
        }
    }
    
    func setGraph() {
        self.pieChartsView.centerText = dataTitle
        
        let dataEntries = [
            PieChartDataEntry(value: Double(type01Counter), label: swingType[0]),
            PieChartDataEntry(value: Double(type02Counter), label: swingType[1]),
            PieChartDataEntry(value: Double(type03Counter), label: swingType[2]),
            PieChartDataEntry(value: Double(type04Counter), label: swingType[3]),
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: dataTitle)
        // グラフの色
        dataSet.colors = ChartColorTemplates.material()
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black
        
        self.pieChartsView.data = PieChartData(dataSet: dataSet)
        
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        self.pieChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.pieChartsView.usePercentValuesEnabled = true
        
        view.addSubview(self.pieChartsView)
    }
    
    
}
