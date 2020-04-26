//
//  HomeViewModel.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 26.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation

protocol HomeViewModelLogic {
    var stories: [Story] { get }
    func loadData()
}

class HomeViewModel: HomeViewModelLogic {
    weak var viewController: HomeViewControllerDisplayLogic?
    
    var stories: [Story] {
        return StoryRepository.shared.stories
    }
    
    init(viewController: HomeViewControllerDisplayLogic) {
        self.viewController = viewController
    }
    
    func loadData() {
        StoryRepository.shared.fetchStories()
    }
}
