//
//  StoryAPI.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 23.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation

protocol StoryAPIProtocol {
    func fetchStories() -> [StoryAPI.StoriesAPIResponse]?
}

class StoryAPI: StoryAPIProtocol {
    func fetchStories() -> [StoriesAPIResponse]? {
        guard let data = storiesJson.data(using: .utf8) else {
            return nil
        }
        do {
            let stories = try JSONDecoder().decode([StoriesAPIResponse].self, from: data)
            return stories
        } catch  {
            print(error)
            return nil
        }
    }
}

extension StoryAPI {
    struct StoriesAPIResponse: Decodable {
        let profilePhotoId: String
        let storyContents: [Content]

        struct Content: Decodable {
            let contentId: String
            let url: String
            let type: String
            let duration: Double
        }
    }
}



let storiesJson = """
[
    {
        "profilePhotoId": "1",
        "storyContents": [

            {
                "contentId": "1",
                "url": "https://www.radiantmediaplayer.com/media/bbb-360p.mp4",
                "type": "video",
                "duration": 8
            },
            {
                "contentId": "2",
                "url": "https://upload.wikimedia.org/wikipedia/tr/7/77/Aang_karakteri.png",
                "type": "image",
                "duration": 8
            },
            {
                "contentId": "3",
                "url": "https://i.pinimg.com/originals/26/0c/76/260c76428f838eba6f0a64b426c44d7c.jpg",
                "type": "image",
                "duration": 8
            }
        ]
    },
    {
        "profilePhotoId": "2",
        "storyContents": [
            {
                "contentId": "4",
                "url": "http://techslides.com/demos/sample-videos/small.mp4",
                "type": "video",
                "duration": 8
            },
            {
                "contentId": "5",
                "url": "https://i.pinimg.com/originals/c9/b1/cb/c9b1cbfd88bada2d0892334a23aaa32d.jpg",
                "type": "image",
                "duration": 8
            },
            {
                "contentId": "6",
                "url": "https://upload.wikimedia.org/wikipedia/en/thumb/4/4f/LockeLost.jpg/220px-LockeLost.jpg",
                "type": "image",
                "duration": 8
            }
        ]
    },{
        "profilePhotoId": "3",
        "storyContents": [
            {
                "contentId": "7",
                "url": "https://upload.wikimedia.org/wikipedia/commons/9/9a/Sagrado_Cora%C3%A7%C3%A3o_de_Jesus_-_escola_portuguesa%2C_s%C3%A9culo_XIX.png",
                "type": "image",
                "duration": 8
            },
        ]
    },
    {
        "profilePhotoId": "4",
        "storyContents": [
            {
                "contentId": "343453",
                "url": "https://i.pinimg.com/originals/c2/d3/1b/c2d31b4c5f03f3dd6393058e949dbdc3.jpg",
                "type": "image",
                "duration": 8
            },{
                "contentId": "3434",
                "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ4mBhcMQVX4y77b_m4TniiFHHWlaQ9VaWqrbp-mlQzBXLNwzfD&usqp=CAU",
                "type": "image",
                "duration": 8
            }
        ]
    },
{
        "profilePhotoId": "6",
        "storyContents": [
            {
                "contentId": "10",
                "url": "https://w0.pngwave.com/png/998/216/sokka-aang-katara-zuko-azula-aang-png-clip-art.png",
                "type": "image",
                "duration": 8
            }
        ]
    },
]

"""
