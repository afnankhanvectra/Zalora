//
//  ZalorViewModel.swift
//  ZALORA
//
//  Created by Afnan Khan on 11/15/19.
//  Copyright © 2019 Afnan Khan. All rights reserved.
//

import Foundation
import UIKit
class ZalorViewModel {
    
    
    var selectedString = "" // To handle the tweet , this string wil contains tweet text
    
    lazy var  wordsArray = selectedString.split(separator: " ") // Array of words from tweet
    
    var postTweet: ([String])->() = { _ in }
    var showTweetError: (String)->() = { _ in }
    
    
    
    func splitMessageButtonClicked(withText text : String){
        splitMessage(withString: text)
        
        
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
        self.postTweet(_tweetArray)
        
    }
    
    /** show Error in String and dont show any tweet
     ***/
    private func showError(withMessage message : String){
        self.showTweetError(message)
    }
    
    
}
