//
//  ImageContentView.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 23.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import UIKit

class ImageContentView: UIView {
    private lazy var didSetupLayouts = false

    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .white
        return activity
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.addSubview(self.activityIndicator)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
    }
    
    private func prepareView() {
        addSubview(contentImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didSetupLayouts {
            contentImageView.frame = frame
            loadingView.frame = frame
            activityIndicator.center = center
            didSetupLayouts = true
        }
    }
    
    public func showLoadingAnimation() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    public func hideLoadingAnimation() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    public func setImage(_ image: UIImage) {
        contentImageView.image = image
    }
}
