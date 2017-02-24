//
//  FeedVC.swift
//  kuti-social
//
//  Created by Ari Chanin on 2/23/17.
//  Copyright © 2017 kuti. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func SignOutBtnPressed(_ sender: UIButton) {
        if (KeychainWrapper.standard.removeObject(forKey: KEY_UID)) == true{
            print("KUTI: Key removed from keychain\n")
            try! FIRAuth.auth()?.signOut()
            print("KUTI: Signed out of out of Firebase\n")

            self.dismiss(animated: true, completion: nil)            
        }
    }
}
