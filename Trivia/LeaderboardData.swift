//
//  LeaderboardData.swift
//  Trivia
//
//  Created by Alex Witkamp on 15-03-18.
//  Copyright © 2018 Alex Witkamp. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

// store the items of the leaderboard from the database in the struct
struct LeaderboardItem {
    
    let uuid: String
    let userName: String
    let userScore: Int
    
    init(userName: String, userScore: Int, uuid: String = "") {
        self.uuid = uuid
        self.userName = userName
        self.userScore = userScore
    }
    
    init(snapshot: DataSnapshot) {
        uuid = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        userName = snapshotValue["userName"] as! String
        userScore = snapshotValue["userScore"] as! Int
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "userScore": userScore,
        ]
    }
    
}

// remember the user name entered at the home view
var userName: String = "Player"
