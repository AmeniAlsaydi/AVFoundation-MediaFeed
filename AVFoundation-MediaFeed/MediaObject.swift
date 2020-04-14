//
//  MediaObject.swift
//  AVFoundation-MediaFeed
//
//  Created by Amy Alsaydi on 4/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import Foundation

struct MediaObject {
    let imageData: Data?
    let videoURL: URL?
    let caption: String?
    let id = UUID().uuidString // an api that returns a unique id -> which can be converted to string 
    let createDate = Date()
}
