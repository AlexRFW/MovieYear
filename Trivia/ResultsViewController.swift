//
//  ResultsViewController.swift
//  Trivia
//
//  Created by Alex Witkamp on 13-03-18.
//  Copyright © 2018 Alex Witkamp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResultsViewController: UIViewController {
    
    // Firebase
    var ref: DatabaseReference!
    
    // define the outlets for the labels and buttons
    @IBOutlet weak var tooBadLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameResultsButton: UIButton!
    
    // store movie data for questions and user score
    var storeItems = [StoreItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make the buttons appear round
        newGameResultsButton.layer.cornerRadius = 5.0
        
        // show the correct answer the user had wrong
        let movieText: String! = "The movie " + storeItems[questionIndex].title + " was released in " + String(storeItems[questionIndex].release_date) + "."
        scoreLabel.text = "Your Score: " + String(userScore)
        
        // show the movie title in italic
        let strText2 = NSMutableAttributedString(string: movieText)
        strText2.addAttribute(.font, value: UIFont(name: "HelveticaNeue-MediumItalic", size: 17)!, range: NSRange(location: 10, length: storeItems[questionIndex].title.count))
         tooBadLabel.attributedText = strText2
        
        // Firebase leaderboard
        ref = Database.database().reference()
        
        // create an unique ID of the user to be stored in the database without overwriting others' data
        let uuid = NSUUID().uuidString
        
        self.ref.child("leaderboard").child(uuid).setValue(["userName": userName, "userScore": userScore])
    }

    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Return from leaderboard
    @IBAction func unwindFromLeaderboardViewController(segue:UIStoryboardSegue) {
    }
}
