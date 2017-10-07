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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Τοποθετούμε εναν observer για να παρακολουθούμε τις αλλαγες στα posts. Επίσης με αυτον τον τρόπο λαμβάνουμε τα δεδομένα της database μας.
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            print(snapshot.value)
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: "PostCell")!
    }

    @IBAction func SignOutTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        print("Vageli: ID removed from keychain \(keychainResult)")
        
        try! Auth.auth().signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
