//
//  Post.swift
//  Markt
//
//  Created by Jeremy Kim on 12/29/17.
//  Copyright © 2017 jkim. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
    var isLiked = false
    var key: String?
    var likeCount: Int
    let imageURL: String
    let imageHeight: CGFloat
    let price: Double
    let poster: User
    let creationDate: Date
    
    init(imageURL: String, imageHeight: CGFloat, price: Double) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        self.price = price
        self.likeCount = 0
        self.poster = User.current
    }
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = ["uid" : poster.uid,
                        "username" : poster.username]
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "price" : price,
                "created_at" : createdAgo,
                "like_count" : likeCount,
                "poster" : userDict]
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? CGFloat,
            let likeCount = dict["like_count"] as? Int,
            let price = dict["price"] as? Double,
            let createdAgo = dict["created_at"] as? TimeInterval,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.price = price
        self.likeCount = likeCount
        self.poster = User(uid: uid, username: username)
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
    }
    
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }
        
        let likesRef = Database.database().reference().child("postLikes").child(postKey)
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    
}
