//
//  ZaloraDataSource.swift
//  ZALORA
//
//  Created by Afnan Khan on 11/15/19.
//  Copyright © 2019 Afnan Khan. All rights reserved.
//

import Foundation
import UIKit

class ZaloraDataSource  : NSObject, UITableViewDataSource  {
    
    let CELLID_TWEET  =     "ZLTweetTableViewCell" // Cell id of tableView clell
    
    var tweetArray : [String] = []  

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
