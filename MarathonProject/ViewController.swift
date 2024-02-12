
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tasks = [TaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1 ..< 31 {
            tasks.append(TaskModel(id: i, text: "\(i)"))
        }
        tableView.reloadData()
    }
    
    @IBAction func shuffleAction(_ sender: Any) {
        tasks.shuffle()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.titleLabel.text = task.text
        cell.accessoryType = task.pinID != nil ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell, indexPath.row < tasks.count else {
            return
        }
        
        if tasks[indexPath.row].pinID != nil {
            tasks[indexPath.row].pinID = nil
            cell.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let maxPinID = tasks.compactMap { $0.pinID }.max() ?? 0
            tasks[indexPath.row].pinID = maxPinID + 1
            
            let selectedTask = tasks.remove(at: indexPath.row)
            tasks.insert(selectedTask, at: 0)
            
            cell.accessoryType = .checkmark
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: indexPath.section))
            
            tableView.deselectRow(at: IndexPath(row: 0, section: indexPath.section), animated: true)
        }
    }
}

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class TaskModel {
    var id: Int
    var text: String
    var pinID: Int?
    
    init(id: Int, text: String, pinID: Int? = nil) {
        self.id = id
        self.text = text
        self.pinID = pinID
    }
}


