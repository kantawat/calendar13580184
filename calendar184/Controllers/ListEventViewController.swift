

import UIKit

class ListEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        performSegue(withIdentifier: "listtocalendar", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthEvent.events.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.00;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        initDay = monthEvent.events[indexPath.row].date
//        performSegue(withIdentifier: "eventtoday",sender: self)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if(monthEvent.events.count > 0){
            tableView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.eventText.text = monthEvent.events[indexPath.row].title
            cell.subEventText.text = monthEvent.events[indexPath.row].dateFullstr
            cell.tag = indexPath.row
            cell.linkDayBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        initDay = monthEvent.events[sender.tag ].date
        performSegue(withIdentifier: "eventtoday",sender: self)
        
    }

}
