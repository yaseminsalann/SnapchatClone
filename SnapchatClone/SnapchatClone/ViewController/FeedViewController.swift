//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Yasemin salan on 5.04.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
      var snapArray = [Snap]()
      var chosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
    }
    
    func getUserInfo() {
         
         fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
             if error != nil {
                 self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
             } else {
                 if snapshot?.isEmpty == false && snapshot != nil {
                     for document in snapshot!.documents {
                         if let username = document.get("username") as? String {
                             UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                             UserSingleton.sharedUserInfo.username = username
                         }
                     }
                 }
             }
         }
         
     }
func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
    }
}
