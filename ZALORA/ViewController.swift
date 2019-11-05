//
//  ViewController.swift
//  ZALORA
//
//  Created by Afnan Khan on 11/1/19.
//  Copyright © 2019 Afnan Khan. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet var errorLabel         :    UILabel!
    @IBOutlet var userInputTextView  :    UITextView!
    @IBOutlet var tweetTableView     :    UITableView!
    
    
    //MARK:  Constant
    // Some testigntweet
    let withourSpaceString = "Itisalongestablishedfactthatareaderwillbedistractedbythereadablecontentofapagewhenlookingatitslayout"
    let smallTweet = "It is a long established fact that a reader"
    let longTweet = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
    let testingTweet = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
    
    let maxNumberOfCharacterPerTweet  =         50 // A tweet shoud countain 50 character
    let maxNumberOfCharacterForTweetDivision  = 47 // because multiple tweet should have tweet number and totla number of Tweet in starting like 1/2
    let CELLID_TWEET  =     "ZLTweetTableViewCell" // Cell id of tableView clell
    
    
    var tweetArray : [String]  = [String]() {
        didSet{
            tweetTableView.reloadData()
        }
    }
    // If text has any error , show the error lable with error text else hide the error label
    var errorText : String  = "" {
        didSet{
            errorLabel.text = errorText
            errorLabel.isHidden = errorText.count == 0
        }
    }
    
    var selectedString = "" // To handle the tweet , this string wil contains tweet text
    
    lazy var  wordsArray = selectedString.split(separator: " ") // Array of words fromtweet
    
    
    //MARK: Applicatin Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputTextView.becomeFirstResponder()
        userInputTextView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the height of TextView
        adjustUITextViewHeight(ofTextView:  userInputTextView)
    }
    
    @IBAction func checkStringButtonClicked(_ sender: UIButton) {
        userInputTextView.endEditing(true)
        splitMessage(withString: userInputTextView.text)
    }
    //MARK: Business logic
    
    /** Split the tweets into different tweets
     Logic:
     Divide message in words in wordsArray
     Check for  single tweet (if less than 50 character)  post that
     Check for error  (if withou  spoace more than 50 character) return nil and show error
     else divide the twets in  different tweets and post
     
     /// - parameter messageString:    The tweet message.
     /// - Return String array:    Its optional , if string contains any error then it will return nil else array string
     
     ***/
    
    @discardableResult public func splitMessage(withString messageString : String) -> [String]?{
        
        selectedString = messageString
        wordsArray = selectedString.split(separator: " ")
        
        if isSingleTweet(tweet: selectedString) == true {
            postTweets([selectedString])
            return [selectedString]
        }
        if isTweetWithoutSpace(tweet: selectedString) == true {
            showError(withMessage: "Tweet Can not break")
            return nil
        }
        
        let multipleTweets = createMultipleTweets()
        postTweets((multipleTweets))
        return multipleTweets
        
    }
    /**
     If string is too long , create different tweet from that
     Get the number of tweets A tweet should contain atmost 50 character
     create tweet from this string  that should containt every single tweet
     
     /// - Return String array:    Array of complete tweets
     ***/
    private func createMultipleTweets() -> [String]{
        var array : [String] = [String]()
        let numberOfTweets =     getNumberOfTweets()
        for index in 0..<numberOfTweets {
            let tweet = createTweet(OfTweetNumber: (index + 1 ), andTotalNumberOfTweet: numberOfTweets)
            array.append(tweet)
        }
        return array
    }
    
    /**
     if  selectedString is less than 50 character, its single tweet, post it
     ***/
    
    public func isSingleTweet(tweet : String) -> Bool {
        return tweet.count <= maxNumberOfCharacterPerTweet
    }
    /**
     if  selectedString is greater than 50 character without space ,its error. Don't post that
     ***/
    public func isTweetWithoutSpace(tweet : String) ->  Bool {
        let wordsCount = tweet.split(separator: " ")
        return (( tweet.count > maxNumberOfCharacterPerTweet && wordsCount.count == 1 )  ?  true : false )
        
    }
    
    /**
     Get the number of tweets what can be created from tweet string
     Tweet should contains atmost 50 characters
     divide the selectedString count by 47 and return
     
     /// - Return Int :     Number of tweets in multiple tweets
     
     ***/
    private func getNumberOfTweets() -> Int{
        let   result = ((Double)(selectedString.count)) / ((Double)(maxNumberOfCharacterForTweetDivision))
        return Int(ceil(result))
    }
    
    /**
     Create Single tweet from multiple tweet
     Loop through words what we have remained from wordsarray and check if we can add this word in this Tweet or not
     If we can add, add in tweet else break
     
     /// - Pßarameter tweetNumber:  The number of tweet what is being prepared
     /// - parameter numberOfTweets : Total number of tweets
     / - Return the Single tweet message
     **/
    private func createTweet(OfTweetNumber  tweetNumber : Int, andTotalNumberOfTweet numberOfTweets : Int  ) -> String{
        
        var tweet = "\(tweetNumber)/\(numberOfTweets)"
        let tempWordsArray = wordsArray
        for word in tempWordsArray {
            
            if (tweet+word).count > maxNumberOfCharacterPerTweet {
                break
            }
            tweet =  tweet + " " + word
            wordsArray.remove(at: wordsArray.firstIndex(of: word)!)
        }
        
        return tweet
    }
    
    
    /** show tweet on Table View and update that
     ***/
    private func postTweets(_ _tweetArray : [String]){
        errorText = ""
        tweetArray = _tweetArray
        
    }
    /** show Error in String and dont show any tweet
     ***/
    private func showError(withMessage message : String){
        errorText = message
        tweetArray = [String]()
    }
    
    
    
}
// MARK: TableView datasource

extension ViewController : UITableViewDataSource {
    
    /** Number of rowsn depends on tweet data **/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELLID_TWEET) as! ZLTweetTableViewCell
        cell.tweetLabel.text = tweetArray[indexPath.row]
        return cell
    }
    
}



// MARK: TextView delegate
extension ViewController : UITextViewDelegate {
    
    /** Textview Height can be changed according to text  We allow textView to change by translate autio resizing**/
    func adjustUITextViewHeight(ofTextView textView : UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
    }
    
    /** This function will change the height of Text View according to text.
     **/
    // MARK: UITextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        
        if !(textView.text.isEmpty) {
        }
        let fixedWidth = UIScreen.main.bounds.width * 0.9
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))) , height: newSize.height)
        
        textView.frame = newFrame
        UIView.performWithoutAnimation {
            view.layoutIfNeeded()
        }
        
    }
    
}
