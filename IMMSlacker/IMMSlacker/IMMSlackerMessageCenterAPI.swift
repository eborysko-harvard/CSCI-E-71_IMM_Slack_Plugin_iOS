//
//  IMMSlackerMessageCenterAPI.swift
//  IMMSlacker
//
//  Created by Cornell Wright on 11/30/15.
//  Copyright © 2015 Cornell Wright. All rights reserved.
//

import UIKit
import Alamofire

class IMMSlackerMessageCenterAPI: NSObject {
    
    static let sharedInstance = IMMSlackerMessageCenterAPI();
    
    var botID:String?;
    var channelID:String?;
    var messageID:Int = 0;
    var users:[String: [String: AnyObject]] = [String: [String: AnyObject]]();
    var users_avatar:[String: NSData] = [String:NSData]();
    
    func setupChannel()
    {
        if let channelID = NSUserDefaults.standardUserDefaults().stringForKey(MessageCenter.prefs.channelID)
        {
            self.channelID = channelID;
            
            self.inviteBotToChannel();
        }
        else
        {
            let channel_name = self.getRandomChannelName();
            
           IMMSlackerAPI.sharedInstance.channels_join(channel_name) {
                (channelID:String) -> Void in
                
                NSUserDefaults.standardUserDefaults().setValue(channelID, forKey: MessageCenter.prefs.channelID);
                
                self.channelID = channelID;
                
                self.inviteBotToChannel();
            }
        }
    }
    
    func inviteBotToChannel()
    {
        if(self.channelID == nil || self.botID == nil)
        {
            return;
        }
        
        IMMSlackerAPI.sharedInstance.channels_invite(self.channelID!, userID: self.botID!, completion: nil);
    }
    
    func configureChat()
    {
        IMMSlackerAPI.sharedInstance.rtm_start {
            (url:String) -> Void in
            
            IMMSlackerSocketAPI.sharedInstance.connect(NSURL(string: url)!);
            
            self.getAvatars();
            
            self.setupChannel();
            
            return;
        }
    }
    
    func randomStringWithLength(length: Int) -> String
    {
        let alphabet = "1234567890abcdefghijklmnopqrstuvwxyz";
        let upperBound = UInt32(alphabet.characters.count);
        
        return String((0..<length).map { _ -> Character in
            return alphabet[(alphabet.startIndex.advancedBy(Int(arc4random_uniform(upperBound))))]
            })
    }
    
    func getRandomChannelName() -> String
    {
        let prefix = self.randomStringWithLength(4);
        let username = Slack.misc.usernames[Int(arc4random()) % Int(Slack.misc.usernames.count)];
        
        return "\(prefix)-\(username)";
    }
    
    func sendMessage(text:String)
    {
        if IMMSlackerSocketAPI.sharedInstance.isConnected && channelID != nil
        {
            messageID++;
            
            IMMSlackerSocketAPI.sharedInstance.sendMessage(messageID, type: "message", channelID: channelID!, text: text);
        }
    }
    
    func getAvatars()
    {
        for (id, user) in self.users
        {
            if let url = user[Slack.param.image] as? String
            {
                Alamofire.request(.GET, url, parameters: nil).response {
                    request, response, data, error in
                    
                    if error != nil
                    {
                        print(error!.localizedDescription);
                        return;
                    }
                    
                    if data != nil
                    {
                        self.users_avatar[id] = data!;
                    }
                }
            }
        }
    }
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    
}



