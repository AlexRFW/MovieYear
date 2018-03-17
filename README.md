# MovieYear!

"MovieYear!" iOS app created for App Studio, Unit 6.

## Getting Started

To run "MovieYear!", download the source code, open a terminal window in the folder, and run "pod install". Next, open the created .xcworkspace file with Xcode and run the app on an iOS simulator or your own iOS device (it works with all available iOS devices and simulators running iOS 11).

## Running the app

![Alt text](/doc/screenshot1.png "Home screen, running on iPhone 8")
![Alt text](/doc/screenshot2.png "Random question, running on iPhone 8")

This game app let's you guess the year of release of popular movies from the last decade, fetched with the tmdb.org API. The player can enter his/her name and guess a number of times based on the remaining number of lives. When all the movies are done or too many incorrect answers are given, the game finishes with a results page to view the score. The player's name and score are sent to the Firebase database and can be viewed when the leaderboard button is pressed.


## Built With

* [Xcode](https://developer.apple.com/xcode/) - The IDE for macOS to create iOS apps
* [App Development with Swift](https://itunes.apple.com/nl/book/app-development-with-swift/id1219117996?l=en&mt=11) - Apple's iBook used to develop this app
* [Firebase](https://firebase.google.com) - Google's service to read and write to a database online11
* [The Movie DB](https://www.themoviedb.org) - The API used to get the movie data


## Authors

**Alex Witkamp** - March 16th, 2018
