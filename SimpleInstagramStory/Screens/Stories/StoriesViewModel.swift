//
//  StoriesViewModel.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 22.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import AVFoundation

protocol StoriesViewControllerDisplayLogic: class {
    func dismiss()
    func presentSelectedStory(at index: Int)
}

protocol StoriesViewModelLogic {
    var stories: [Story] { get }
    func dismiss()
    func viewDidLayoutSubviews()
}

class StoriesViewModel: StoriesViewModelLogic {
    weak var viewController: StoriesViewControllerDisplayLogic?
    private var currentIndex: Int
    
    init(viewController: StoriesViewControllerDisplayLogic, selectedIndex currentIndex: Int = 0) {
        self.viewController = viewController
        self.currentIndex = currentIndex
        
    }
    
    var stories: [Story] {
        return StoryRepository.shared.stories
    }
    
    func viewDidLayoutSubviews() {
        viewController?.presentSelectedStory(at: currentIndex)
    }
    
    func dismiss() {
        viewController?.dismiss()
    }
}
