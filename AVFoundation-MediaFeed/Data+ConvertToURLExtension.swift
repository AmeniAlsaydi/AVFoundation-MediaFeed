//
//  Data+ConvertToURLExtension.swift
//  AVFoundation-MediaFeed
//
//  Created by Amy Alsaydi on 4/15/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

extension Data {
    // To Call this function on a video data
    // use case example:
    // let url = mediaObject.videoData.convertToURL()
    public func convertToURL() -> URL? {
        
        // create a temp url
        // NSTemporaryDirectory() - stores temporary files, those files get deleted as needed by the operating system
        // documents directory is permanent storage
        // caches directory is temporary storage
        
        // in core data the video is saved as data
        // when playing back the video is saved as data
        // when playing back the video we need to have a url pointing to the video location on disk
        // AVPlayer need a url pointing to a location on disk
        // we want to play it back from the saved data
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        
        
        do {
            // self is video data becasue this is an extension
            // write == save
            // read == fetch
            try self.write(to: tempURL, options: [.atomic])
            // .atomic write/save all at once
            return tempURL
            
        } catch {
            print("failed to write aka save to video data to temporary file error: \(error)")
        }
        
        return nil 
    }
    
}
