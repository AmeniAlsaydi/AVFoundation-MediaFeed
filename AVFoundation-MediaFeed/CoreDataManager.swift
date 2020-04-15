//
//  CoreDataManager.swift
//  AVFoundation-MediaFeed
//
//  Created by Amy Alsaydi on 4/14/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private init() {}
    
    static let shared = CoreDataManager()
    
    private var mediaObjects = [CDMediaObject]()
    
    // get instance of the NSManagedObjectContext from the AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // the actaully instance of where core data objects are saved
    // NSManagedObjectContext does saving. fetching on NSMangedObjects...
    
    // CRUD create
    
    func createMediaObject(_ imageData: Data, videoURL: URL?) -> CDMediaObject {
        let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
        mediaObject.createdDate = Date()
        mediaObject.id = UUID().uuidString
        mediaObject.imageData = imageData // but both video and image have image
        
        // video can be nil -> if it exists that means were coming from a video object
        if let videoURL = videoURL {
            do {
                mediaObject.videoData = try Data(contentsOf: videoURL)
            } catch {
                print("failed to convert url to data with error: \(error)")
            }
        }
        
        // save the newly created mediaObject entity instance to the NSManagedObjectContext
        
        do {
            try context.save()
        } catch {
            print("failed to save newly created media object with error: \(error)")
        }
        
        return mediaObject
    }
    
    
    // read
    func fetchMediaObjects() -> [CDMediaObject] {
        do {
            mediaObjects = try context.fetch(CDMediaObject.fetchRequest()) // fetch all the created objects from the CDMediaObjects Entity
        } catch {
           
            print("failed to fetch media object with error: \(error)")
        }
        
        return mediaObjects
    }
    
    // update
    
    // delete
    
    
    
}
