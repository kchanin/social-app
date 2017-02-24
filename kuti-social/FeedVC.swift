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
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTblView.dataSource = self
        feedTblView.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    print ("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.feedTblView.reloadData()
        })


    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row]
        print("KUTI: \(post.caption)")
            
        return feedTblView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
    }
    


    @IBAction func SignOutBtnPressed(_ sender: UITapGestureRecognizer) {
        if (KeychainWrapper.standard.removeObject(forKey: KEY_UID)) == true{
            print("KUTI: Key removed from keychain\n")
            try! FIRAuth.auth()?.signOut()
            print("KUTI: Signed out of out of Firebase\n")

            self.dismiss(animated: true, completion: nil)
        }
    }
}
