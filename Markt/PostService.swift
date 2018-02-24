//
//  PostService.swift
//  Markt
//
//  Created by Jeremy Kim on 12/29/17.
//  Copyright © 2017 jkim. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
class PostService{
    
    static func createBook(for image: UIImage, price: Double) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURLone = downloadURL else {
                return
            }
            
            let urlString = downloadURLone.absoluteString
            let price = price
            let aspectHeight = image.aspectHeight
            createbook(forURLString: urlString, aspectHeight: aspectHeight, price: price)
        }
    }
    
    static func createElectronics(for image: UIImage, price: Double) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURLone = downloadURL else {
                return
            }
            
            let urlString = downloadURLone.absoluteString
            let price = price
            let aspectHeight = image.aspectHeight
            createelectronics(forURLString: urlString, aspectHeight: aspectHeight, price: price)
        }
    }
    
    static func createLease(for image: UIImage, price: Double) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURLone = downloadURL else {
                return
            }
            
            let urlString = downloadURLone.absoluteString
            let price = price
            let aspectHeight = image.aspectHeight
            createlease(forURLString: urlString, aspectHeight: aspectHeight, price: price)
        }
    }
    
    private static func createbook(forURLString urlString: String, aspectHeight: CGFloat, price: Double) {
        let post = Post(imageURL: urlString, imageHeight: aspectHeight, price: price)
        // 3
        let dict = post.dictValue
        
        // 4
        let postRef = Database.database().reference().child("Books").childByAutoId()
        //5
        postRef.updateChildValues(dict)
    }
    
    private static func createelectronics(forURLString urlString: String, aspectHeight: CGFloat, price: Double) {
        let post = Post(imageURL: urlString, imageHeight: aspectHeight, price: price)
        // 3
        let dict = post.dictValue
        
        // 4
        let postRef = Database.database().reference().child("Electronics").childByAutoId()
        //5
        postRef.updateChildValues(dict)
    }
    
    private static func createlease(forURLString urlString: String, aspectHeight: CGFloat, price: Double) {
        let post = Post(imageURL: urlString, imageHeight: aspectHeight, price: price)
        
        let dict = post.dictValue
        
        
        let postRef = Database.database().reference().child("Leases").childByAutoId()
        
        postRef.updateChildValues(dict)
    }
    
    static func showBooks(forKey postKey: String, uid: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("Books")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
    
    static func showElectronics(forKey postKey: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("Electronics")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
    
    static func showLeases(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        let ref = Database.database().reference().child("Leases")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
            
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
    
}
