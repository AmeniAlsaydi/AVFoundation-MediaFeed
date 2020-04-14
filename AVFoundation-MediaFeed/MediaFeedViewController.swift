//
//  MediaFeedViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Amy Alsaydi on 4/13/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import AVFoundation // video playback is done on a CALayer
import AVKit //  video playback is done using AVPlayerViewController - if we want to make view rounded we can only do that using the CALayer of that view eg. someview.layer.cornerRadius

class MediaFeedViewController: UIViewController {
    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
        
    }()
    
    private var mediaObjects = [MediaObject]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoButton.isEnabled = false
        }
        
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    
    @IBAction func photoButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    // play random vid in the header view
    
    private func playRandomVideo(in view: UIView) {
        // we want all non-nil media objects from the mediaObjects array -> COMPACT MAP
        // COMPACT MAP: returns all non-nil values
        
        let videoURLs = mediaObjects.compactMap { $0.videoURL }
        
        if let videoURL = videoURLs.randomElement() {
            let player = AVPlayer(url: videoURL)
            // create a ca layer (sub layer
            let playerLayer = AVPlayerLayer(player: player)
            // set its frame - take up the entire header view
            playerLayer.frame = view.bounds // view being passed in aka header view
            playerLayer.videoGravity = .resizeAspect
            
            // remove all sublayers from the header view
            view.layer.sublayers?.removeAll()
            
            // add the playerLayer to to the hearer views layer
            view.layer.addSublayer(playerLayer)
            
            player.play()
        }
    }
}

// MARK: UICollectionView DataSource

extension MediaFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
            fatalError("could not dequeue to a media cell")
        }
        
        let mediaObject = mediaObjects[indexPath.row]
        cell.configureCell(for: mediaObject)
        
        return cell
    }
    
    // asks the data source to give it the view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // needs to type cast to header view
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
            fatalError("could not dequeue a HeaderView")
        }
        playRandomVideo(in: headerView)
        
        return headerView // is of type UICollectionReusableView
    }
    
    // give me the size for the header -> returns a cgsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.40 )
    }

    
}

// MARK: UICollectionView Delegate Methods


extension MediaFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size // max size of current devive
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.4 // 40% of height of the device
        
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaObject = mediaObjects[indexPath.row]
        guard let videoURL = mediaObject.videoURL else {
            return
        }
        
        let playerViewController = AVPlayerViewController() // View controller that we will present at the end
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        present(playerViewController, animated: true) {
            // use the completion handler of play video automattically
            player.play()
        }
    }
    
    
}

extension MediaFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // info is a dictionary
        // InfoKey.originalImage
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        
        print("mediaType: \(mediaType)") // what will be returned "public.video", "piblic image" will be used to handle what is selected differently
        
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                let imageData = originalImage.jpegData(compressionQuality: 1.0) {
                // created an object that needs data
                let mediaObject = MediaObject(imageData: imageData, videoURL: nil, caption: nil)
                mediaObjects.append(mediaObject)
            }
            
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print("mediaURL: \(mediaURL)")
                
                let mediaObject = MediaObject(imageData: nil, videoURL: mediaURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("not a supported media type ")
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
}
