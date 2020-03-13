
import UIKit
import Firebase

class LoginConViewController: UIViewController {
    
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passtxt: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func normalLogin(_ sender: UIButton) {
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if(rest.key == self.emailtxt.text!){
                    let value = rest.value as! [String : AnyObject]
                    let profile = value["profile"] as! [String : AnyObject]
                    let email = profile["email"] as! String
                    let display = profile["displayname"] as! String
                    let pass = profile["password"] as! String
                    if(self.passtxt.text! == pass){
                        userUid = email
                        userFullname = display
                        self.performSegue(withIdentifier: "loginday",sender: self)
                    }
                }
            }
            
            let message = "Login Fail"
            let alert = UIAlertController(title: nil , message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
}
