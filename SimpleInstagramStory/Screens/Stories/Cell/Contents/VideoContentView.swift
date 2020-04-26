//
//  VideoContent.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 22.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoContentView: UIView {
    private lazy var didSetupLayouts = false
    private var player: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
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
        
        addSubview(loadingView)
        loadingView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func showLoadingAnimation() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
    }
    
    public func hideLoadingAnimation() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    public func playVideo(videoItem: AVPlayerItem, duration: Double) {
        player = AVPlayer(playerItem: videoItem)
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer?.backgroundColor = UIColor.black.cgColor
        avPlayerLayer?.frame.size = CGSize(
            width: frame.size.width,
            height: frame.size.height
        )
        
        avPlayerLayer?.videoGravity = .resizeAspect
        avPlayerLayer?.contentsGravity = CALayerContentsGravity.center
        layer.addSublayer(avPlayerLayer!)
        
        player?.automaticallyWaitsToMinimizeStalling = false
        player?.playImmediately(atRate: 9999)
        player?.play()
    }
    
    public func stop() {
        player?.pause()
        player = nil
        avPlayerLayer?.removeFromSuperlayer()
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func resume() {
        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !didSetupLayouts {
            loadingView.frame = frame
            activityIndicator.center = center
            didSetupLayouts = true
        }
    }
}
