import UIKit

class MainViewController: UITableViewController {
    
    private let cellId = "cellId"
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var waterHistory = WaterHistory()
    var items = [WaterItem]()
    
    var alert: UIAlertController!
    var addAction: UIAlertAction!
    
    @IBAction func addItemDidTap(_ sender: Any) {
        alert = UIAlertController(title: "Добавление записи", message: "Укажите объем выпитой воды в мл", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        addAction = UIAlertAction(title: "Добавить", style: .default) { _ -> Void in
            if let textField = self.alert.textFields?.first, let text = textField.text {
                self.addItem(value: text.doubleValue)
            }
        }
        alert.addAction(addAction)
        alert.addTextField { textField in
            textField.placeholder = "Введите объем в мл"
            textField.keyboardType = .decimalPad
            textField.addTarget(self, action: #selector(self.editWaterItemValue), for: .editingChanged)
        }
        present(alert, animated: true, completion: nil)
    }
    @objc func editWaterItemValue() {
        guard let textField = self.alert.textFields?.first, let text = textField.text else {
            addAction.isEnabled = false
            return
        }
        addAction.isEnabled = text.doubleValue == nil ? false : true
    }
    func addItem(value: Double?) {
        if let value = value {
            let item = WaterItem(tms: Date().timeIntervalSince1970, value: value, deleted: false)
            items.append(item)
            waterHistory.add(item: item)
            
            if items.count == 1 {
                tableView.reloadData()
            } else {
                let indexPath = IndexPath(row: items.count - 1, section: 0)
                tableView.insertRows(at: [indexPath], with: .bottom)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        waterHistory.delegate = self
        waterHistory.load()
    }
}

extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if items.isEmpty {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "")
            cell.textLabel?.text = "За сегодня записей не найдено"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            cell.textLabel?.textColor = .systemGray3
            return cell
        }
        let item = items[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = "В \(dateFormatter.string(from: Date(timeIntervalSince1970: item.tms))) было выпито \(item.value) мл воды"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return items.isEmpty ? false : true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            items.removeAll(where: { $0.tms == item.tms })
            waterHistory.remove(item: item)
            
            if items.isEmpty {
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
extension MainViewController: WaterHistoryDelegate {
    func itemsDidLoad() {
        let date = Date()
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.day , .month , .year], from: date)
        items = waterHistory.items.filter { item in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day , .month , .year], from: Date(timeIntervalSince1970: item.tms))
            return !item.deleted && nowComponents.day! == components.day! && nowComponents.month! == components.month! && nowComponents.year! == components.year!
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
