//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Yasemin salan on 5.03.2025.
//

import UIKit
import FirebaseCore
import FirebaseFirestoreInternal
import FirebaseAuth
import FirebaseFirestoreInternal

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signInButton(_ sender: Any) {
        if usernameText.text!.isEmpty || emailText.text!.isEmpty || passwordText.text!.isEmpty {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authResult, error in
                if let error = error {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                    return
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
           
        }else{
            makeAlert(title: "Error", message: "Username/Email/Password cannot be empty")
        }
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        if usernameText.text!.isEmpty || emailText.text!.isEmpty || passwordText.text!.isEmpty {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authResult, error in
                if let error = error {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                    return
                }else{
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["email":self.emailText.text!,"username":self.usernameText.text!] as! [String:Any]
                    fireStore.collection("userInfo").addDocument(data: userDictionary){(error) in
                        if error != nil{
                            
                        }}
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{
            self.makeAlert(title: "Error", message: "Username/Email/Password cannot be empty")
        }
        
    }
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

