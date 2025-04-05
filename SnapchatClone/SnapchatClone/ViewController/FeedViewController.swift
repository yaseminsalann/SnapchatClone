//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Yasemin salan on 5.04.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
      var snapArray = [Snap]()
      var chosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

               tableView.delegate = self
               tableView.dataSource = self
               
               
               getSnapsFromFirebase()
               
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
    func getSnapsFromFirebase() {
           fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
               if error != nil {
                   self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
               } else {
                   if snapshot?.isEmpty == false && snapshot != nil {
                       self.snapArray.removeAll(keepingCapacity: false)
                       for document in snapshot!.documents {
                           
                           let documentId = document.documentID
                           
                           if let username = document.get("snapOwner") as? String {
                               if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                   if let date = document.get("date") as? Timestamp {
                                       
                                       if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                           if difference >= 24 {
                                               self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                               
                                               }  } else {
                                                   let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference )
                                                   self.snapArray.append(snap)
                                               }
                                              
                                               
                                           }
                                           
                                          
                                           
                                       }
                                   }
                               }
                               
                           }
                           self.tableView.reloadData()
                           
                       }
                       
                   }
               }
           }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
               cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
               return cell
    }
}
