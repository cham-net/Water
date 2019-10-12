import Foundation


class WaterItem: NSObject, NSCoding {
    
    var tms = 0.0
    var value = 0.0
    var deleted = false
    
    init(tms: Double, value: Double, deleted: Bool) {
        self.tms = tms
        self.value = value
        self.deleted = deleted
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(tms, forKey: "tms")
        coder.encode(value, forKey: "value")
        coder.encode(deleted, forKey: "deleted")
    }
    
    required init?(coder: NSCoder) {
        self.tms = coder.decodeDouble(forKey: "tms")
        self.value = coder.decodeDouble(forKey: "value")
        self.deleted = coder.decodeBool(forKey: "deleted")
    }
}
