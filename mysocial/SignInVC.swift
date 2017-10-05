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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }
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
                
                if let user = user {
                    
                    self.completeSignIn(id: user.uid)
                    
                }
            }
        })
            
        
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            
          Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
            if error == nil {
                
                print("Vageli: Email user authenticated with Firebase")
                
                if let user = user {
                
                    self.completeSignIn(id: user.uid)
                }
            } else {
                
                Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if error != nil {
                        print("Vageli: Unable to authenticate with Firebase using email")
                    } else {
                        
                        print("Vageli: Succesfully authenticated with Firebase")
                        
                        if let user = user {
                        
                            self.completeSignIn(id: user.uid)
                            
                        }
                    }
                })
                
            }
          })
            
        }
        
    }
    
    func completeSignIn(id: String) {
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Vageli: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}


















