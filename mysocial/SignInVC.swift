//
//  ViewController.swift
//  mysocial
//
//  Created by vagelis spirou on 2/10/17.
//  Copyright © 2017 vagelis spirou. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("Vageli: Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("Vageli: User cancelled Facebook authentication")
            } else {
                
                print("Vageli: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("Vageli: Unable to authenticate with Firebase - \(error)")
                
            } else {
                print("Vageli: Successfully authenticated with Firebase")
            }
        })
            
        
    }
}


















