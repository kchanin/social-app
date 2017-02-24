//
//  ViewController.swift
//  kuti-social
//
//  Created by Ari Chanin on 2/22/17.
//  Copyright © 2017 kuti. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtFld: FancyField!
    @IBOutlet weak var passwordTxtField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            print("KUTI: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    



    @IBAction func facebookBtnTapped(_ sender: RoundBtn) {
        
        let facebooklogin = FBSDKLoginManager()
        facebooklogin.logIn(withReadPermissions: ["email"], from: self){(result, error) in
            if error != nil{
                print ("KUTI: Unable to authenticate with Facebook - \(error)\n")
            }else if result?.isCancelled == true{
                print ("KUTI: User cancelled FB authenitcation\n")
            }else{
                print ("KUTI: Successfully authenticated with FB\n")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
            if error != nil{
                print ("KUTI: Unable to authenticate with Firebase - \(error)\n")
            }else{
                print ("KUTI: Successfully authenticated with Firebase\n")
                if let user = user{
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
            })
    }

    @IBAction func emailSignInBtnTapped(_ sender: Any) {
        guard let email = emailTxtFld.text, !email.isEmpty else{
            print ("KUTI: The email field needs to be populated\n")
            return
        }
        guard let pwd = passwordTxtField.text, !pwd.isEmpty else{
            print ("KUTI: The password field needs to be populated\n")
            return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {(user, error) in
            if error == nil{
                print ("KUTI: Email User authenticated with Firebase\n")
                if let user = user{
                    let userData = ["provider": user.providerID]
                    self.completeSignIn(id: user.uid, userData: userData)
                }

            } else {
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {(user, error) in
                    if error != nil{
                        print ("KUTI: Unable to authenticate with Firebase using email\n")
                    }else{
                        print ("KUTI: Successfully created user and authenticted with Firebase\n")
                        if let user = user{
                            let userData = ["provider": user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                })
            }
        })
    }
    
    func completeSignIn(id: String, userData:Dictionary<String, String>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print ("KUTI: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

