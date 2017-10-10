//
//  FeedVC.swift
//  mysocial
//
//  Created by vagelis spirou on 4/10/17.
//  Copyright © 2017 vagelis spirou. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageAdd: CircleView!
    
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Επιτρέπει στον χρήστη να επεξεργαστεί το περιεχόμενο της view μας.
        imagePicker.allowsEditing = true
        
        // Τοποθετούμε εναν observer για να παρακολουθούμε τις αλλαγες στα posts. Επίσης με αυτον τον τρόπο λαμβάνουμε τα δεδομένα της database μας.
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
        
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    
                    // Το snap εχει όλα τα αντικειμενα πλεον.
                    
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                
                cell.configureCell(post: post)
                return cell
            }
            
        } else {
            
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            imageSelected = true
        } else {
            print("Vageli: A valid image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
       present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        // Τσεκάρουμε εαν υπάρχει caption
        guard let caption = captionField.text, caption != "" else {
            
            print("Vageli: Caption must be entered")
            return
        }
        
        // Τσεκάρουμε εαν υπάρχει image
        guard let img = imageAdd.image, imageSelected == true else {
            
            print("Vageli: An image must be selected")
            return
        }
        
        // Μετατρέπουμε την εικονα μας σε data σε μορφή jpeg. Με αυτόν τον τρόπο μπορούμε να την καταχωρήσουμε στην firebase database.
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            // Πέρνουμε ενα μοναδικό id
            let imgUid = NSUUID().uuidString
            
            // Θέτουμε την metadata σε μορφή jpeg
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Vageli: Unable to upload image to Firebase storage")
                } else {
                    print("Vageli: Successfully upload image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                }
                
            }
        }
    }
    
    @IBAction func SignOutTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        print("Vageli: ID removed from keychain \(keychainResult)")
        
        try! Auth.auth().signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
