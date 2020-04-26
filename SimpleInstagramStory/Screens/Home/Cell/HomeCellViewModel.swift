//
//  HomeCellViewModel.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 26.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation

protocol HomeCellViewModelLogic {
    func observeData()
}

class HomeCellViewModel: HomeCellViewModelLogic {
    var story: Story
    weak var cell: HomeCellDisplayLogic?
    
    init(story: Story, cell: HomeCellDisplayLogic) {
        self.story = story
        self.cell = cell
        initialView()
        observeData()
    }
    
    func initialView() {
        cell?.showLoader()
    }
    
    func observeData() {
        story.storyContents.forEach { (content) in
            if DataCache.instance.readData(forKey: content.contentId) == nil {
                StoryRepository.shared.observeStoryLoadingStatus(contentId: content.contentId) { (status) in
                    if content.contentId == self.story.storyContents.first?.contentId {
                        self.cell?.hideLoader()
                    }
                }
            } else {
                self.cell?.hideLoader()
            }
        }
    }
}
