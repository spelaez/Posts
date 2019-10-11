//
//  PostListCell.swift
//  Posts
//
//  Created by Santiago Pelaez Rua on 10/9/19.
//  Copyright © 2019 Santiago Pelaez Rua. All rights reserved.
//

import UIKit

class PostListCell: UITableViewCell {

    @IBOutlet weak var accessoryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    private static let circleFillImageName = "circle.fill"
    private static let starFillImageName = "star.fill"

    var post: Post! {

        didSet {
            titleLabel.text = post.title
            setAccessoryImage()
        }
    }

    func setAccessoryImage() {
        if post.isUnread {
            accessoryImage.tintColor = UIColor.postsBlue
            accessoryImage.image = UIImage(systemName: PostListCell.circleFillImageName)
        } else if post.isFavorite {
            accessoryImage.tintColor = UIColor.postsYellow
            accessoryImage.image = UIImage(systemName: PostListCell.starFillImageName)
        } else {
            accessoryImage.image = nil
        }
    }
}
