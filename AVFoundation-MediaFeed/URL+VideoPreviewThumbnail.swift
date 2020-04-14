//
//  URL+VideoPreviewThumbnail.swift
//  AVFoundation-MediaFeed
//
//  Created by Amy Alsaydi on 4/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import AVFoundation

extension URL {
    public func videoPreviewThumbnail() -> UIImage? {
        
        // create an AVAsset instance
        let asset = AVAsset(url: self) // self is the url instance
        
        // The AVAssetImageGenerator us an AVFoundation class that converts a given media url to an image
        let  assetGenerator = AVAssetImageGenerator(asset: asset)
        assetGenerator.appliesPreferredTrackTransform = true
        
        // create atime stamp of needed location in the video
        // we will use CMTime to generate the given time stamp
        // CMTime is part of Core Media
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60) // retreive the first second of the video
        
        var image: UIImage?
        
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
            
            // lower level API dont know UIKit, AVkit
            // change the color of a uiview border
            // eg. someView.layer.border = UIColor.green.cgColot
            image = UIImage(cgImage: cgImage)
            
        } catch {
            
        }
        return image
    }
}
