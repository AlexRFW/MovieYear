//
//  QuestionData.swift
//  Trivia
//
//  Created by Alex Witkamp on 13-03-18.
//  Copyright © 2018 Alex Witkamp. All rights reserved.
//

import Foundation

// Store the movie items from tmdb.org
struct StoreItem {
    
    var id: Int
    var title: String
    var release_date: Int
    var overview: String
    var poster_path: URL
    var question: String
    
    init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let id = json["id"] as? Int,
            let release_date = json["release_date"] as? String.SubSequence,
            let overview = json["overview"] as? String,
            let poster_pathString = json["poster_path"] as? String,
            let poster_path = URL(string: "https://image.tmdb.org/t/p/w500" + poster_pathString) else { return nil }
        
        self.id = id
        self.title = title
        self.release_date = Int(release_date.prefix(4))!
        self.overview = overview
        self.poster_path = poster_path
        self.question = ("In what year was the movie " + title + " released?")
    }
}

// remember the position in the movie items list
var questionIndex = 0

// remember the user's current score
var userScore = 0

// remember the lives of the player
var lives = 3
