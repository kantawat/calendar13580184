
import UIKit
import FacebookCore
import FacebookLogin

class SettingViewController: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image: UIImage?
        let url = NSURL(string: userPic)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            image = UIImage(data: imageData as Data)
        }
        profileImg.image = image
        profileImg.layer.masksToBounds = true
        profileImg.layer.cornerRadius = profileImg.bounds.width / 2
        
        profileNameLabel.text = userFullname
    }
    
    @IBAction func onBack(_ sender: UIButton) {
         performSegue(withIdentifier: "profiletocalendar",sender: self)

    }
    
    @IBAction func onSwitchNoti(_ sender: UISwitch) {
        let alert = UIAlertController(title: "",
                                      message: "After 5 seconds ",
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.scheduleNotification(notificationType: "Local Notification")
        }

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLogout(_ sender: UIButton) {
        
        userUid = ""
        userFullname = ""
        userPic = "https://www.matichon.co.th/wp-content/uploads/2019/03/Pic-Little-Wild_190308_0021.jpg"

        let manager = LoginManager()
        manager.logOut()
        performSegue(withIdentifier: "profiletologin",sender: self)

    }
}
