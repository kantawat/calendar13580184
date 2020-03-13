
import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var displaytxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passtxt: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func registerUser(_ sender: UIButton) {
        
        let obj = ["displayname": displaytxt.text!,
                   "email": emailtxt.text!,
                   "password": passtxt.text!]
        
        ref.child("users").child("\(emailtxt.text!)/profile").setValue(obj)
        self.performSegue(withIdentifier: "signuplogin",sender: self)
    }
    

}
