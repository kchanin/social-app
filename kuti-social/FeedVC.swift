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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var feedTblView: UITableView!
    @IBOutlet weak var commentTxtFld: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTblView.dataSource = self
        feedTblView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
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
        
        if let cell = feedTblView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell{

            if let img = FeedVC.imageCache.object(forKey: posts[indexPath.row].imageURL as NSString){
                cell.configureCell(post: posts[indexPath.row], img: img)
                return cell
            }else{
                cell.configureCell(post: posts[indexPath.row])
                return cell
            }
        }else{
            
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = image
            selectedImage = image
        }else{
            print("KUTI: A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func SignOutBtnPressed(_ sender: UITapGestureRecognizer) {
        if (KeychainWrapper.standard.removeObject(forKey: KEY_UID)) == true{
            
            DataService.ds.REF_POSTS.removeAllObservers()
            
            print("KUTI: Key removed from keychain\n")
            try! FIRAuth.auth()?.signOut()
            print("KUTI: Signed out of out of Firebase\n")


            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addPicTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postImageBtnPressed(_ sender: Any) {
    }
    
    
}
