import UIKit
import Charts
import FirebaseFirestore

class GraphViewController: UIViewController {
    
    @IBOutlet weak var pieChartsView: PieChartView!
    var trainingId: String?
    
    private var firebase = Firestore.firestore()
    
    var swingType = ["上下素振り", "正面素振り", "左右素振り", "速素振り"]
    
    var dataTitle: String?
    var getTotalCount: Double?
    var getType01Total: Double?
    var getType02Total: Double?
    var getType03Total: Double?
    var getType04Total: Double?
    var achievementCount: Int?
    var totalCount: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDataFromFirestore()
        
    }
    
    private func showDataFromFirestore() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        firebase.collection("user").document(documentId).getDocument { (document, err) in
            if err != nil {
                print("データの取得に失敗しました")
            }
            let dataCounter = document?.data()
            self.getTotalCount = dataCounter?["totalCount"] as? Double
            self.getType01Total = dataCounter?["type01Total"] as? Double
            self.getType02Total = dataCounter?["type02Total"] as? Double
            self.getType03Total = dataCounter?["type03Total"] as? Double
            self.getType04Total = dataCounter?["type04Total"] as? Double
            self.achievementCount = dataCounter?["achievementCount"] as? Int
            
            self.getType01Total = self.getType01Total! / Double(self.getTotalCount!) * 100
            self.getType02Total = self.getType02Total! / Double(self.getTotalCount!) * 100
            self.getType03Total = self.getType03Total! / Double(self.getTotalCount!) * 100
            self.getType04Total = self.getType04Total! / Double(self.getTotalCount!) * 100
            self.setGraph()
            
            print("counter01",self.getType01Total)
            print("counter02",self.getType02Total)
            print("counter03",self.getType03Total)
            print("counter04",self.getType04Total)
        }
    }
    
    func setGraph() {
        self.pieChartsView.centerText = dataTitle
        
        let dataEntries = [
            PieChartDataEntry(value: Double(getType01Total!), label: swingType[0]),
            PieChartDataEntry(value: Double(getType02Total!), label: swingType[1]),
            PieChartDataEntry(value: Double(getType03Total!), label: swingType[2]),
            PieChartDataEntry(value: Double(getType04Total!), label: swingType[3]),
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
