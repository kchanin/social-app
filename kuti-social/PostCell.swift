//
//  PostCell.swift
//  kuti-social
//
//  Created by Ari Chanin on 2/23/17.
//  Copyright © 2017 kuti. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    



    
    var likesRef: FIRDatabaseReference!
    var post : Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }

    func configureCell(post: Post, img: UIImage? = nil){
        
        self.post = post
        self.likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil{
            self.postImg.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 5 * 1024 * 1024 , completion: {(data, error) in
                if error != nil{
                    print("KUTI: Unable download image from Firebase storage")
                }else{
                    print("KUTI: Image downloaded from Firebase storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }

        likesRef.observeSingleEvent(of: .value, with: {(snapshot) in
            print("KUTI: Observed single event")
            if let _ = snapshot.value as? NSNull{
                self.likeImg.image = UIImage(named: "empty-heart")
            }else{
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer){
        self.likesRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            }else{
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })

    }
}
