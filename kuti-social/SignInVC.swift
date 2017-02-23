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

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtFld: FancyField!
    @IBOutlet weak var passwordTxtField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }



    @IBAction func facebookBtnTapped(_ sender: RoundBtn) {
        
        let facebooklogin = FBSDKLoginManager()
        facebooklogin.logIn(withReadPermissions: ["email"], from: self){(result, error) in
            if error != nil{
                print ("KUTI: Unable to authenticate with Facebook - \(error)")
            }else if result?.isCancelled == true{
                print ("KUTI: User cancelled FB authenitcation")
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
                print ("KUTI: Unable to authenticate with Firebase - \(error)")
            }else{
                print ("KUTI: Successfully authenticated with Firebase\n")
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
            } else {
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {(user, error) in
                    if error != nil{
                        print ("KUTI: Unable to authenticate with Firebase using email\n")
                    }else{
                        print ("KUTI: Successfully created user and authenticted with Firebase")
                    }
                })
            }
        })
    }
}

