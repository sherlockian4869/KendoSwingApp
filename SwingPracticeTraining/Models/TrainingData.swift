import Foundation

class TrainingData {
    
    var trainingTitle: String?
    var trainingType: Int?
    var trainingId: String?
    var type01: String?
    var count01: Int?
    var type02: String?
    var count02: Int?
    var type03: String?
    var count03: Int?
    var type04: String?
    var count04: Int?
    
    init(trainingTitle: String?, trainingType: Int?, trainingId: String?, type01: String?, count01: Int?, type02: String?, count02: Int?, type03: String?, count03: Int?, type04: String?, count04: Int?) {
        self.trainingTitle = trainingTitle;
        self.trainingType = trainingType;
        self.trainingId = trainingId;
        self.type01 = type01;
        self.count01 = count01;
        self.type02 = type02;
        self.count02 = count02;
        self.type03 = type03;
        self.count03 = count03;
        self.type04 = type04;
        self.count04 = count04;
    }
}
