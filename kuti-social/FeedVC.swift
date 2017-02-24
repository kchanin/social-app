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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTblView.dataSource = self
        feedTblView.delegate = self
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return feedTblView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
    }
    


    @IBAction func SignOutBtnPressed(_ sender: UITapGestureRecognizer) {
        if (KeychainWrapper.standard.removeObject(forKey: KEY_UID)) == true{
            print("KUTI: Key removed from keychain\n")
            try! FIRAuth.auth()?.signOut()
            print("KUTI: Signed out of out of Firebase\n")

            self.dismiss(animated: true, completion: nil)
//            performSegue(withIdentifier: "goToSignin", sender: nil)
            
        }
    }
}
