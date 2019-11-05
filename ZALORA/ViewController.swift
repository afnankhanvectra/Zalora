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
    
    let withourSpaceString = "Itisalongestablishedfactthatareaderwillbedistractedbythereadablecontentofapagewhenlookingatitslayout"
    let smallTweet = "It is a long established fact that a reader"
    let longTweet = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
    let testingTweet = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
    
    let maxNumberOfCharacterPerTweet  = 50
    let maxNumberOfCharacterForTweetDivision  = 47
    let CELLID_TWEET  = "ZLTweetTableViewCell"
    
    
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
    var selectedString = ""
    
    lazy var  wordsArray = selectedString.split(separator: " ")
 
    
    //MARK: Applicatin Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInputTextView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustUITextViewHeight(ofTextView:  userInputTextView)
    }
    
    @IBAction func checkStringButtonClicked(_ sender: UIButton) {
        splitMessage(withString: userInputTextView.text)
    }
    /** Split the tweets into different tweets***/
    @discardableResult func splitMessage(withString messageString : String) -> [String]?{
        
        selectedString = messageString
        wordsArray = selectedString.split(separator: " ")
        
        if isSingleTweet == true {
            postTweets([selectedString])
            return [selectedString]
        }
        if isTweetWithoutSpace == true {
            showError(withMessage: "Tweet Can not break")
            return nil
        }
        
        let multipleTweets = createMultipleTweets()
        postTweets((multipleTweets))
        
        return multipleTweets
        
        
    }
    func createMultipleTweets() -> [String]{
        var array : [String] = [String]()
        let numberOfTweets =     getNumberOfTweets()
        for index in 0..<numberOfTweets {
            let tweet = createTweet(OfTweetNumber: (index + 1 ), andTotalNumberOfTweet: numberOfTweets)
            array.append(tweet)
            
        }
        return array
    }
    
    
    
    
    var isSingleTweet :  Bool {
        get {
            return selectedString.count <= maxNumberOfCharacterPerTweet
        }
    }
    
    var isTweetWithoutSpace :  Bool {
        get {
            return (( selectedString.count > maxNumberOfCharacterPerTweet && wordsArray.count == 1 )  ?  true : false )
        }
    }
    
    func getNumberOfTweets() -> Int{
        let   result = ((Double)(selectedString.count)) / ((Double)(maxNumberOfCharacterForTweetDivision))
        return Int(ceil(result))
    }
    
    func createTweet(OfTweetNumber  tweetNumber : Int, andTotalNumberOfTweet numberOfTweets : Int  ) -> String{
        
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
    
    
    
    func postTweets(_ _tweetArray : [String]){
        //    errorText = ""
        tweetArray = _tweetArray
        
    }
    
    func showError(withMessage message : String){
        errorText = message
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
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))) , height: newSize.height)
 
        textView.frame = newFrame
        UIView.performWithoutAnimation {
            view.layoutIfNeeded()
        }
        
    }
    
}
