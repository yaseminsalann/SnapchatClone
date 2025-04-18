//
//  UploadViewController.swift
//  SnapchatClone
//
//  Created by Yasemin salan on 5.04.2025.
//

import UIKit
import FirebaseFirestoreInternal
import SwiftUICore
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func choosePicture(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadClick(_ sender: Any) {
        //Storage
               
               let storage = Storage.storage()
               let storageReference = storage.reference()
               
               let mediaFolder = storageReference.child("media")
               
               
               if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
                   
                   let uuid = UUID().uuidString
                   
                   let imageReference = mediaFolder.child("\(uuid).jpg")
                   
                   imageReference.putData(data, metadata: nil) { (metadata, error) in
                       if error != nil {
                           self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                       } else {
                           imageReference.downloadURL { (url, error) in
                                                 if error == nil {
                                                     
                                                     let imageUrl = url?.absoluteString
                                                     
                                                     //Firestore
                                                     
                                                     let fireStore = Firestore.firestore()
                                                     
                                                     fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                                         if error != nil {
                                                             self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                         } else {
                                                             if snapshot?.isEmpty == false && snapshot != nil {
                                                                 for document in snapshot!.documents {
                                                                     
                                                                     let documentId = document.documentID
                                                                     
                                                                     if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                                         imageUrlArray.append(imageUrl!)
                                                                         
                                                                         let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                                         fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { (error) in
                                                                                                                            if error == nil {
                                                                                                                                self.tabBarController?.selectedIndex = 0
                                                                                                                                self.uploadImageView.image = UIImage(named: "selectimage.png")
                                                                                                                            }
                                                                                                                        }
                                                                                                                        
                                                                                                                        
                                                                                                                    }
                                                                                                                    
                                                                                                                    
                                                                                                                }
                                                                                                            } else {
                                                                                                                let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username,"date":FieldValue.serverTimestamp()] as [String : Any]
                                                                                                                
                                                                                                                fireStore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                                                                                                    if error != nil {
                                                                                                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                                                                                    } else {
                                                                                                                        self.tabBarController?.selectedIndex = 0
                                                                                                                        self.uploadImageView.image = UIImage(named: "selectimage.png")
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                 }
                                             }
                                             
                                             
                                         }
                                     }
                                     
                                     
                                     
                                 }
    }
    
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
