import UIKit
import Charts
import FirebaseFirestore

class GraphViewController: UIViewController {
    
    @IBOutlet weak var pieChartsView: PieChartView!
    
    private var firebase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 円グラフの中心に表示するタイトル
        self.pieChartsView.centerText = "テストデータ"
        
        // グラフに表示するデータのタイトルと値
        let dataEntries = [
            PieChartDataEntry(value: 40, label: "A"),
            PieChartDataEntry(value: 35, label: "B"),
            PieChartDataEntry(value: 25, label: "C")
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "テストデータ")
        
        // グラフの色
        dataSet.colors = ChartColorTemplates.vordiplom()
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
    
    private func fetchDataFromFirestore() {
        guard let userName = UserDefaults.standard.string(forKey: "name") else { return }
        guard let documentId = UserDefaults.standard.string(forKey: "\(userName)") else { return }
        firebase.collection("user").document(documentId).collection("swingMenu").getDocuments { (snapshots, err) in
            if err != nil {
                print("データの取得に失敗しました")
            }
            
        }
    }
    
}
