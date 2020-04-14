//
//  MediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Amy Alsaydi on 4/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit

// collection view doesnt come with a default cell we have to create a cell to manage it 

class MediaCell: UICollectionViewCell {
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func configureCell(for mediaObject: MediaObject) {
        
        if let imageData = mediaObject.imageData {
            mediaImageView.image = UIImage(data: imageData) // converts data to image 
        }
        
        // TO DO : create video from doc
        
        if let videoURL = mediaObject.videoURL {
            let image = videoURL.videoPreviewThumbnail() ?? UIImage(systemName: "heart")
            mediaImageView.image = image
        }
    }
    
}
