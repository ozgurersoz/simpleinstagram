//
//  StoryCollectionViewCellViewModel.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 22.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol StoryCollectionViewCellViewModelLogic: class {
    var currentIndex: Int { get set }
    func next()
    func previous()
    func disableStory()
    func pauseStory()
    func resumeStory()
    func dismiss()
    func drag(to point: CGPoint)
}

class StoryCollectionViewCellViewModel: StoryCollectionViewCellViewModelLogic {
    weak var cell: StoryCollectionViewCellDisplayLogic?
    private var story: Story!
    private var timer: ResumableTimer?
    weak var owner: StoryDelegate?
    var currentIndex = 0
    private var currentStoryIndex: Int!
    
    init(cell: StoryCollectionViewCellDisplayLogic, story: Story, owner: StoryDelegate, index: Int) {
        self.cell = cell
        self.story = story
        self.owner = owner
        self.currentStoryIndex = index
        let storyContent = story.storyContents[currentIndex]
        showStoryContent(storyContent)
        let durations = story.storyContents.map { $0.duration }
        cell.addLoadingBars(story.storyContents.count, durations: durations)
        observeStoryLoadingStatus()
    }
    
    func next() {
        guard currentIndex + 1 < story.storyContents.count else {
            disableStory()
            owner?.nextStory(nextStoryIndex: currentStoryIndex+1, previousStory: cell!)
            return
        }
        
        currentIndex += 1
        guard let storyContent = story?.storyContents[currentIndex] else {
            return
        }
        showStoryContent(storyContent)
    }
    
    func previous() {
        guard currentIndex > 0 else { return }
        cell?.resetLoading(for: currentIndex)
        currentIndex -= 1

        guard let storyContent = story?.storyContents[currentIndex] else { return }
        let previousIndex = currentIndex
        cell?.resetLoading(for: previousIndex)
        showStoryContent(storyContent)
    }
    
    func showStoryContent(_ content: StoryContent) {
        switch content.type {
        case .video:
            if let playerItem = getPlayerItem(with: content.contentId) {
                cell?.presentNextVideoContent(playerItem, duration: content.duration, index: currentIndex)
                if currentIndex > 0 {
                    cell?.fillLoadingBar(for: currentIndex-1)
                }
                manageTimer(with: content.duration)
            } else {
                cell?.presentNextVideoContent(nil, duration: content.duration, index: currentIndex)
            }
        case .image:
            if let imageContent = imageContent(from: content.contentId) {
                cell?.presentNextImageContent(imageContent, duration: content.duration, index: currentIndex)
                if currentIndex > 0 {
                    cell?.fillLoadingBar(for: currentIndex-1)
                }
                manageTimer(with: content.duration)
            } else {
                cell?.presentNextImageContent(nil, duration: content.duration, index: currentIndex)
            }
        }
        cell?.stopVideo()
    }
    
    func getPlayerItem(with contentId: String) -> AVPlayerItem? {
        guard let data = StoryRepository.shared.getContent(with: contentId) else {
            return nil
        }
        let playerItem = CachingPlayerItem(data: data, mimeType: "audio/mpeg", fileExtension: "mp4")
        return playerItem
    }
    
    func imageContent(from contentId: String) -> UIImage? {
        guard let data = StoryRepository.shared.getContent(with: contentId) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    func manageTimer(with duration: Double) {
        timer = nil
        timer?.invalidate()
        timer = ResumableTimer(interval: duration) {
           self.next()
        }
        timer?.start()
    }
    
    func disableStory() {
        cell?.stopVideo()
        timer?.invalidate()
        timer = nil
    }
    
    func pauseStory() {
        timer?.pause()
        owner?.setCollectionViewScrollableStatus(false)
        if currentIndex >= 0 {
            if story.storyContents[currentIndex].type == .video {
                cell?.pauseVideoContent()
            }
        }
    }
    
    func resumeStory() {
        owner?.setCollectionViewScrollableStatus(true)
        timer?.resume()
        if currentIndex >= 0 {
            if story.storyContents[currentIndex].type == .video {
                cell?.resumeVideoContent()
            }
        }
    }
    
    func dismiss() {
        owner?.dismissStories()
    }
    
    func drag(to point: CGPoint) {
        owner?.drag(to: point)
    }
    
    func observeStoryLoadingStatus() {
        story.storyContents.forEach { (content) in
            if !StoryRepository.shared.hasData(for: content.contentId) {
                StoryRepository.shared.observeStoryLoadingStatus(contentId: content.contentId) { (status) in
                    if content.contentId == self.story.storyContents[self.currentIndex].contentId {
                        DispatchQueue.main.async {
                            self.showStoryContent(content)
                        }
                    }
                }
            }
        }
    }
}
