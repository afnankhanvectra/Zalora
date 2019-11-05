//
//  ZALORATests.swift
//  ZALORATests
//
//  Created by Afnan Khan on 11/5/19.
//  Copyright © 2019 Afnan Khan. All rights reserved.
//

import XCTest
@testable import ZALORA



class ZALORATests: XCTestCase {
    
    var controller: ViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self)).instantiateInitialViewController() as? ViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        
        
        controller = vc
        controller.loadViewIfNeeded()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controller =  nil
    }
    
    func test_isSingleTweet(){
        
        let testingTweet = "I can't believe Tweeter now supports "
 
        let isSingleTweet = controller?.isSingleTweet( tweet : testingTweet)
        XCTAssertEqual(isSingleTweet, true, "This should be single tweet")
     }
    
    func test_isTweetWithoutSpace(){
        let testingTweet = "Itisalongestabl"
        let isWithoutSingleTweet = controller?.isTweetWithoutSpace( tweet : testingTweet)

     XCTAssertEqual(isWithoutSingleTweet, false, "This tweet has more than 50 charatcer without Space")

    }
    
     
    
    
    func test_SplitMessage(){
        
        guard let tweetMessages = controller?.splitMessage(withString:  "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.") else {
            XCTFail("Tweet is not according to requirment")
            return
        }
        print("Tweet Success \(tweetMessages)")
    }
    
    
}
