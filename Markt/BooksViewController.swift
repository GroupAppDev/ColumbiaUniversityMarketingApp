//
//  BooksViewController.swift
//  Markt
//
//  Created by Jeremy Kim on 1/7/18.
//  Copyright © 2018 jkim. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class BooksViewController: UIViewController {
    let refreshControl = UIRefreshControl()
    @IBOutlet var tableView: UITableView!
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        UserService.booksTimeline { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
    func reloadTimeline() {
        UserService.booksTimeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
    }

    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    
    
}

extension BooksViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksHeaderCell") as! BooksHeaderCell
            cell.usernameLabel.text = post.poster.username
            cell.priceLabel.text = String(post.price)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksImageCell") as! BooksImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BooksActionCell") as! BooksActionCell
            cell.delegate = self as? BookActionCellDelegate
            configureCell(cell, with: post)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexpath")
        }
        
    }
    
    func configureCell(_ cell: BooksActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
        
    }
    
}

extension BooksViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return BooksHeaderCell.height
            
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
            
        case 2:
            return BooksActionCell.height
            
        default:
            fatalError()
        }
    }
    
    
}

extension BooksViewController: BookActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: BooksActionCell) {
        // 1
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        // 2
        likeButton.isUserInteractionEnabled = false
        // 3
        let post = posts[indexPath.section]
        
        // 4
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            // 5
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            // 6
            guard success else { return }
            
            // 7
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            // 8
            guard let cell = self.tableView.cellForRow(at: indexPath) as? BooksActionCell
                else { return }
            
            // 9
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}

