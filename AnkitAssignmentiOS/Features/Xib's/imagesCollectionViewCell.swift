//
//  imagesCollectionViewCell.swift
//  AnkitAssignmentiOS
//
//  Created by Ankit yadav on 15/04/24.
//

import UIKit

class imagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // content mode to center-crop
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }    
}
