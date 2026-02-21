//
//  FeedViewController.swift
//  Fakestagram
//
//  Created by Adrian Gutierrez on 18/10/25.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    var customView: FeedView {
        return view as! FeedView
    }
    var pictureType: PictureType = .dog
    var showCaption: Bool = true
    
    override func loadView() {
        view = FeedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCaptionedPictures()
    }
    
    private func setCaptionedPictures(){
        for captionedImage in pictureType.captionedImages {
            let captionedImageView = CaptionedImageView()
            captionedImageView.captionedImage = captionedImage
            captionedImageView.showCaption = showCaption
            customView.containerStackView.addArrangedSubview(captionedImageView)
        }
    }
    
}
