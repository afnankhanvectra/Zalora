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
    
    private var dataSource = ZaloraDataSource()
    
    private var viewModel = ZalorViewModel()
    
    
    
    var tweetArray : [String]  = [String]() {
        didSet{
            dataSource.tweetArray = tweetArray
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
    
    
    
    
    //MARK: Applicatin Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
        
    }
    
    func prepareView(){
        userInputTextView.becomeFirstResponder()
        userInputTextView.delegate = self
        tweetTableView.dataSource = dataSource
        observeEvents()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the height of TextView
        adjustUITextViewHeight(ofTextView:  userInputTextView)
    }
    
    @IBAction func checkStringButtonClicked(_ sender: UIButton) {
        userInputTextView.endEditing(true)
        viewModel.splitMessage(withString: userInputTextView.text)
    }
    
    
    
    
    
    private func observeEvents(){
        /** show tweet on Table View and update that
         ***/
        viewModel.postTweet = { [weak self] _tweetArray in
            DispatchQueue.main.async {
                self?.errorText = ""
                self?.tweetArray = _tweetArray
            }
        }
        /** show Error in String and dont show any tweet
         ***/
        viewModel.showTweetError = { [weak self] message in
            DispatchQueue.main.async {
                self?.errorText = message
                self?.tweetArray = [String]()
            }
        }
        
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
