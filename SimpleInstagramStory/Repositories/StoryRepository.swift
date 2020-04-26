//
//  StoryRepository.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 22.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation

class StoryRepository {
    static let shared = StoryRepository()
    
    var stories = [Story]()
    var cachingPlayerItem: CachingPlayerItem!
    
    var contentDictionary = Dictionary<String, ((Bool) -> Void)>()
    
    func fetchStories() {
        let api = StoryAPI()
        guard let storiesApiResponse = api.fetchStories() else { return }
        cacheVideo(from: storiesApiResponse)
        
        let stories = storiesApiResponse.map { (apiResponse) -> Story in
            let contents = apiResponse.storyContents.map { content -> StoryContent in
                StoryContent(
                    contentId: content.contentId,
                    type: StoryContentType(rawValue: content.type) ?? .video,
                    seen: false,
                    duration: content.duration
                )

                
            }
            return Story(profilePhotoId: apiResponse.profilePhotoId, storyContents: contents)
        }
        
        self.stories = stories
    }
    
    func cacheVideo(from apiResponse: [StoryAPI.StoriesAPIResponse]) {
        apiResponse.forEach{
            $0.storyContents.forEach { (content) in
                guard let url = URL(string: content.url) else { return }
                URLSession.shared.downloadTask(with: url) { (dataURL, _, _) in
                    if let url = dataURL {
                        let data = try? Data(contentsOf: url)
                        DataCache.instance.write(data: data!, forKey: content.contentId)
                        self.contentDictionary[content.contentId]?(true)
                        self.contentDictionary[content.contentId] = nil
                    }
                }.resume()
            }
        }
    }
    
    func observeStoryLoadingStatus(contentId: String, then handler: @escaping (Bool) -> Void) {
        contentDictionary[contentId] = handler
    }
    
    func getContent(with contentId: String) -> Data? {
        guard let data = DataCache.instance.readData(forKey: contentId) else {
            return nil
        }
        return data
    }
    
    func hasData(for contentId: String) -> Bool {
        DataCache.instance.readData(forKey: contentId) == nil ? false : true
    }
}

