//
//  Story.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 22.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation

struct Story: Decodable {
    let profilePhotoId: String
    let storyContents: [StoryContent]
}

struct StoryContent: Decodable {
    var contentId: String
    var type: StoryContentType
    var seen: Bool?
    var duration: Double
}

enum StoryContentType: String, Decodable {
    case image = "image"
    case video = "video"
}
