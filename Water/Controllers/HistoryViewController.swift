import UIKit

class HistoryViewController: UITableViewController {
    
    private let cellId = "cellId"
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy HH:mm"
        return formatter
    }()
    
    var waterHistory = WaterHistory()
    var items = [WaterItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        waterHistory.delegate = self
        waterHistory.load()
    }
}

extension HistoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if items.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "")
            cell.textLabel?.text = "Записей не найдено"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            cell.textLabel?.textColor = .systemGray3
            return cell
        }
        let item = waterHistory.items[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = "\(dateFormatter.string(from: Date(timeIntervalSince1970: item.tms))) было выпито \(item.value) мл воды"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        return cell
    }
}

extension HistoryViewController: WaterHistoryDelegate {
    func itemsDidLoad() {
        items = waterHistory.items.sorted(by: { $0.tms > $1.tms }) 
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
