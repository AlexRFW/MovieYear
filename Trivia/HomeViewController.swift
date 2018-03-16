//
//  HomeViewController.swift
//  Trivia
//
//  Created by Alex Witkamp on 13-03-18.
//  Copyright © 2018 Alex Witkamp. All rights reserved.
//

import UIKit

// default settings for the text field at the home view
class MyCustomTextField : UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.attributedPlaceholder = NSAttributedString(string: "Enter Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
}

class HomeViewController: UIViewController, UITextFieldDelegate {

    // button outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    
    // Enter name in the field
    @IBAction func userNameChanged(_ sender: UITextField) {
        if let text = sender.text {
            userName = text
            if userName.isEmpty {
                userName = "Player"
            }
        }
    }
    
    // Start button settings
    @IBAction func newGameButtonAction(_ sender: UIButton) {
        
        // Alert when name field hasn't changed
        if (userName.isEmpty || userName == "Player") {
            let alert = UIAlertController(title: "title", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.setValue(NSAttributedString(string: "Continue without entering name?", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor : UIColor.white]), forKey: "attributedTitle")
            
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            
            subview.backgroundColor = UIColor.darkGray
            subview.tintColor = UIColor.white
            
            alert.view.tintColor = UIColor(red: (255/255.0), green: (175/255.0), blue: (184/255.0), alpha: 1.0)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                self.performSegue(withIdentifier: "newGameSegue", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        else {
            // Go to next view of game
            self.performSegue(withIdentifier: "newGameSegue", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameField.delegate = self
        
        // make button corners round
        newGameButton.layer.cornerRadius = 5.0
        leaderboardButton.layer.cornerRadius = 5.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Set textfield to the name entered
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // Go back to home screen
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    // Return from leaderboard
    @IBAction func unwindFromLeaderboardViewController(segue:UIStoryboardSegue) {
    }
}
