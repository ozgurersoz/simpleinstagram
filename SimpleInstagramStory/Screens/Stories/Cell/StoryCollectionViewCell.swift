//
//  StoryCollectionViewCell.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 22.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol StoryCollectionViewCellDisplayLogic: class {
    func stopVideo()
    func pauseVideoContent()
    func resumeVideoContent()
    func presentNextVideoContent(_ content: AVPlayerItem?, duration: Double, index: Int)
    func presentNextImageContent(_ content: UIImage?, duration: Double, index: Int)
    func dismissStory()
    func addLoadingBars(_ count: Int, durations: [Double])
    func fillLoadingBar(for index: Int)
    func resetLoading(for index: Int)
    func videoContentIsLoading(_ status: Bool)
}

class StoryCollectionViewCell: UICollectionViewCell {
    private lazy var didSetupLayouts = false
    private lazy var videoContent: VideoContentView = {
        let content = VideoContentView()
        return content
    }()
    private lazy var imageContent = ImageContentView()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()
    private lazy var coverView = UIView()
    var viewModel: StoryCollectionViewCellViewModelLogic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    convenience init(viewModel: StoryCollectionViewCellViewModelLogic) {
        self.init()
        self.viewModel = viewModel
    }
    
    func prepareView() {
        contentView.addSubview(videoContent)
        contentView.addSubview(imageContent)
        contentView.addSubview(stackView)
        contentView.addSubview(coverView)
        coverView.isMultipleTouchEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didSetupLayouts {
            videoContent.frame = contentView.frame
            imageContent.frame = contentView.frame
            stackView.frame.size = CGSize(width:contentView.frame.size.width-2, height: 3)
            stackView.frame.origin = CGPoint(x: 0, y: 0)
            coverView.frame = contentView.frame
            didSetupLayouts = true
        }
    }

    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var pressTimeStamp: TimeInterval?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.coverView)
            pressTimeStamp = event?.timestamp
            initialTouchPoint = touchPoint
            pauseAnimation()
            viewModel?.pauseStory()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.coverView)
            guard let currentTimestamp = event?.timestamp, let pressedTimeStamp = self.pressTimeStamp else { return }
            if currentTimestamp - pressedTimeStamp < 0.0001 {
                self.resumeAnimation()
                self.viewModel?.resumeStory()
                let position = touch.location(in: self.coverView)
                if position.x > self.contentView.frame.size.width / 2 {
                    self.viewModel?.next()
                } else {
                    self.viewModel?.previous()
                }
            } else {
                if touchPoint.y - self.initialTouchPoint.y > 100 {
                    self.viewModel?.dismiss()
                } else {
                    self.viewModel?.drag(to: CGPoint(x: 0, y: 0))
                }
                self.resumeAnimation()
                self.viewModel?.resumeStory()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.coverView)
            let point = CGPoint(x: 0, y: touchPoint.y - initialTouchPoint.y)
            viewModel?.drag(to: point)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        initialTouchPoint = CGPoint(x: 0,y: 0)
    }
}

extension StoryCollectionViewCell: StoryCollectionViewCellDisplayLogic {
    func dismissStory() {
        viewModel?.disableStory()
    }
    
    func presentNextImageContent(_ content: UIImage?, duration: Double, index: Int) {
        DispatchQueue.main.async {
            self.videoContent.isHidden = true
            self.imageContent.isHidden = false
            if let content = content {
                self.imageContent.setImage(content)
                self.startAnimation(on: self.stackView.arrangedSubviews[index], duration: duration)
            }
        }
    }
    
    func presentNextVideoContent(_ content: AVPlayerItem?, duration: Double, index: Int) {
        DispatchQueue.main.async {
            self.imageContent.isHidden = true
            self.videoContent.isHidden = false
            if let content = content {
                self.videoContent.playVideo(videoItem: content, duration: duration)
                self.startAnimation(on: self.stackView.arrangedSubviews[index], duration: duration)
            } else {
                self.videoContent.showLoadingAnimation()
            }
        }
    }
    
    func stopVideo() {
        videoContent.stop()
    }
    
    func pauseVideoContent() {
        videoContent.pause()
    }
    
    func resumeVideoContent() {
        videoContent.resume()
    }
    
    func videoContentIsLoading(_ status: Bool) {
        status == true ? videoContent.showLoadingAnimation() : videoContent.hideLoadingAnimation()
    }
    
    func addLoadingBars(_ count: Int, durations: [Double]) {
        for _ in 0..<count {
            let view = UIView()
            view.clipsToBounds = true
            view.backgroundColor = .white
            stackView.addArrangedSubview(view)
        }
    }
    
    func startAnimation(on view: UIView, duration: Double) {
        let loadingView = UIView()
        loadingView.frame.origin = CGPoint(x: 0 , y: view.frame.origin.y)
        loadingView.frame.size = CGSize(width: 0, height: 3)
        loadingView.backgroundColor = .darkGray
        
        view.addSubview(loadingView)
        view.backgroundColor = .white
        
        UIView.animate(withDuration: duration, animations: {
            loadingView.frame.size.width = view.frame.width
            view.layoutIfNeeded()
        })
    }
    
    func fillLoadingBar(for index: Int) {
        let view = stackView.arrangedSubviews[index]
        if let loadingView = view.subviews.first {
            loadingView.frame.size.width = view.frame.size.width
            loadingView.layer.removeAllAnimations()
            view.layoutIfNeeded()
        } else {
            let loadingView = UIView(frame: view.frame)
            loadingView.backgroundColor = .darkGray
            view.addSubview(loadingView)
        }
    }
    
    func pauseAnimation(){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeAnimation(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func resetLoading(for index: Int) {
        let view = stackView.arrangedSubviews[index]
        view.backgroundColor = .white
        let loadingView = view.subviews.first!
        loadingView.backgroundColor = .lightGray
        loadingView.layer.removeAllAnimations()
        loadingView.frame.size.width = view.frame.size.width
        loadingView.removeFromSuperview()
        view.layoutIfNeeded()
    }
}
