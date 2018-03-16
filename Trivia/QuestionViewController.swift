//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Alex Witkamp on 13-03-18.
//  Copyright © 2018 Alex Witkamp. All rights reserved.
//

import UIKit

// dictionary shuffle and sequence extention
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

// Returns an shuffled array with the contents of this sequence
extension Sequence {
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

class QuestionViewController: UIViewController {
    
    // store movie data for questions
    var storeItems = [StoreItem]()
    
    // labels, buttons, and images for question and answers strings
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    @IBOutlet weak var rangedLabelAnswer: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var heartOne: UIImageView!
    @IBOutlet weak var heartTwo: UIImageView!
    @IBOutlet weak var heartThree: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!

    // define the alert that happens when the Quit button is pressed
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "title", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.setValue(NSAttributedString(string: "Are you sure you want to quit the game?", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor : UIColor.white]), forKey: "attributedTitle")

        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        subview.backgroundColor = UIColor.darkGray
        subview.tintColor = UIColor.white
        
        alert.view.tintColor = UIColor(red: (255/255.0), green: (175/255.0), blue: (184/255.0), alpha: 1.0)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.performSegue(withIdentifier: "unwindFromQtoH", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // define the alert that happens when the Restart button is pressed
    @IBAction func restartButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "title", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
        alert.setValue(NSAttributedString(string: "Are you sure you want to restart the game?", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor : UIColor.white]), forKey: "attributedTitle")
            
            
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            
        subview.backgroundColor = UIColor.darkGray
        subview.tintColor = UIColor.white
            
        alert.view.tintColor = UIColor(red: (255/255.0), green: (175/255.0), blue: (184/255.0), alpha: 1.0)
            
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.viewDidLoad()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        self.present(alert, animated: true)
    }
    
    // submit button outlet

    // Slider movement
    @IBAction func rangedSliderMoved(_ sender: UISlider) {
        let index = Int(round(rangedSlider.value))
        self.rangedLabelAnswer.text = String(index)
        //updateUI(with: storeItems)
    }
    
    // Submit button
    @IBAction func rangedAnswerButtonPressed(_ sender: UIButton) {
        let answer = Int(round(rangedSlider.value))
        if answer == storeItems[questionIndex].release_date {
            userScore += 1
            nextQuestion()
        }
        
        // update the lives heart symbols
        else if lives > 0 {
            lives -= 1
            if lives == 2 {
                heartThree.image = UIImage(named: "hartje_leeg")
            }
            if lives == 1 {
                heartTwo.image = UIImage(named: "hartje_leeg")
            }
            if lives == 0 {
                heartOne.image = UIImage(named: "hartje_leeg")
            }
        }
        
        // end the game when there are no hearts left and the answer is wrong
        else {
            print("Wrong answer!")
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // reset variable values
        questionIndex = 0
        userScore = 0
        lives = 3
        heartThree.image = UIImage(named: "hartje_vol")
        heartTwo.image = UIImage(named: "hartje_vol")
        heartOne.image = UIImage(named: "hartje_vol")
        
        // make the button round
        submitButton.layer.cornerRadius = 5.0
        
        // query the required data from tmdb.org
        var query: [String: String] = [
            "api_key": "c45d17153b8b450ec8472155dbfafca6",
            "language": "en-US",
            "sort_by": "popularity.desc",
            "include_adult": "false",
            "include_video": "false",
            "page": "1",
            "primary_release_year": "2010"
        ]
        
        // fetch data of 20 movies from 2010
        query.updateValue("2010", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
            }
        }
        
        // fetch data of 20 movies from 2011
        query.updateValue("2011", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
            }
        }
        
        // fetch data of 20 movies from 2012
        query.updateValue("2012", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
            }
        }
        
        // fetch data of 20 movies from 2013
        query.updateValue("2013", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
            }
        }
        
        // fetch data of 20 movies from 2014
        query.updateValue("2014", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
            }
        }
        
        // fetch data of 20 movies from 2015
        query.updateValue("2015", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
            }
        }
        
        // fetch data of 20 movies from 2016
        query.updateValue("2016", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
            }
        }
        
        //fetch data of 20 movies from 2017
        query.updateValue("2017", forKey: "primary_release_year")
        QuestionController.shared.fetchItems(matching: query) { (items) in
            if let items = items {
                self.storeItems = self.storeItems + items
                self.storeItems = self.storeItems.shuffled()
                self.updateUI(with: self.storeItems)
            }
        }
    }
    
    // update the user interface with the categories from the server
    func updateUI(with storeItems: [StoreItem]) {
        DispatchQueue.main.async {
            self.showQuestion(with: storeItems)
            self.calculateScore()
        }
    }
    
    // next question function
    func nextQuestion() {
        
        // increment index of questions
        questionIndex += 1
        rangedSlider.value = (rangedSlider.minimumValue + rangedSlider.maximumValue) / 2
        
        if questionIndex < storeItems.count {
            updateUI(with: storeItems)
        }
        else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
    
    func printMovies(with printItems: [StoreItem]) {
        print(printItems.count)
        for item in printItems {
            print("The movie " + item.title + " was released in", item.release_date)
            print(item.question)
        }
    }
    
    // make the question appear on the screen
    func showQuestion(with questionItems: [StoreItem]) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let url: URL = questionItems[questionIndex].poster_path
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Something went wrong: \(error)")
            }
            
            if let imageData = data {
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(data: imageData)
                }
            }
        }.resume()
        
        // define the label of the slider ranges
        self.rangedLabel1.text = String(Int(rangedSlider.minimumValue))
        self.rangedLabel2.text = String(Int(rangedSlider.maximumValue))
        self.title = "Question #" + String(questionIndex + 1)
        
        // show the movie title in italic
        let strText = NSMutableAttributedString(string: questionItems[questionIndex].question)
        strText.addAttribute(.font, value: UIFont(name: "HelveticaNeue-MediumItalic", size: 22)!, range: NSRange(location: 27, length: questionItems[questionIndex].title.count))
        
        self.questionLabel.attributedText = strText
        
        let index = Int(round(rangedSlider.value))
        self.rangedLabelAnswer.text = String(index)
    }
    
    // update the score on the view
    func calculateScore() {
        scoreLabel.text = "Score: " + String(userScore)
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // prepare for the results view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            let ResultsViewController = segue.destination as! ResultsViewController
            ResultsViewController.storeItems = storeItems
        }
    }
}
