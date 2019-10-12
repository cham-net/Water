import Foundation


protocol WaterHistoryDelegate {
    func itemsDidLoad()
}

class WaterHistory {
    
    private let itemsKey = "itemsKey"
    
    var items = [WaterItem]()
    var delegate: WaterHistoryDelegate?
    
    func load() {
        DispatchQueue.global(qos: .default).async {
            if let data = UserDefaults.standard.data(forKey: self.itemsKey) {
                if let items = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data){
                    self.items = items as? [WaterItem] ?? []
                }
            }
            self.delegate?.itemsDidLoad()
        }
    }
    
    deinit {
        save()
        items = []
    }
    
    private func save() {
        DispatchQueue.global(qos: .default).async {
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: self.items, requiringSecureCoding: false) {
                UserDefaults.standard.set(data, forKey: self.itemsKey)
            }
        }
    }
    
    func add(item: WaterItem) {
        if items.first(where: { $0.tms == item.tms }) == nil {
            items.append(item)
            save()
        }
    }
    
    func remove(item: WaterItem) {
        if let index = items.firstIndex(where: { $0.tms == item.tms }) {
            items[index].deleted = true
            save()
        }
    }
}
