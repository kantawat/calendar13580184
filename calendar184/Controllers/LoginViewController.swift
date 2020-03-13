
import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth
import Firebase
import EventKit

class LoginViewController: UIViewController {
    
    private let readPermissions: [Permission] = [ .publicProfile]
    var ref: DatabaseReference!
    
    let resultAlert:UIAlertController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
    }
    
    @IBAction func normalLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "enterLogin",sender: self)
    }
    
    @IBAction func loginwithfacebook(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }
    @IBAction func enterSignup(_ sender: UIButton) {
        self.performSegue(withIdentifier: "enterSignup",sender: self)
    }
    
    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        resultAlert.view.addSubview(loadingIndicator)
        present(resultAlert, animated: true, completion: nil)
        
        print("loginResult : \(loginResult)")
        
        switch loginResult {
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            didLoginWithFacebook()
        case .failed(_): break
        default:
            break
        }
    }
    fileprivate func didLoginWithFacebook() {
        if AccessToken.current != nil {
            // If Firebase enabled, we log the user into Firebase
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                self.dismiss(animated: false, completion: nil)
                if error != nil {
                    let message = "There was an error."
                    let alert = UIAlertController(title: nil , message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let user = Auth.auth().currentUser
                    if let user = user {
                        userUid = user.uid
                        
                        let myGraphRequest = GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, birthday, age_range, picture.width(40), gender"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get)
                        
                        let connection = GraphRequestConnection()
                        connection.add(myGraphRequest, completionHandler: { (connection, values, error) in
                            if let values = values as? [String:Any] {
                                
                                let fullName = values["name"] as! String
                                let pictureDict = values["picture"] as! [String:Any]
                                let imageDict = pictureDict["data"] as! [String:Any]
                                let imageUrl = imageDict["url"] as! String
                                
                                userFullname = fullName
                                userPic = imageUrl
                                
                                print("fullName: \(fullName), picture: \(imageUrl)")
                            }
                        })
                        connection.start()
                        self.performSegue(withIdentifier: "logintoday",sender: self)
                    }
                }
            }
        }
    }
}

