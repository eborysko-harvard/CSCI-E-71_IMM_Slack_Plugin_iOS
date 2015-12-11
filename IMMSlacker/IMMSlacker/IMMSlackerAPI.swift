//
//  IMMSlackerAPI.swift
//  IMMSlacker
//
//  Created by Cornell Wright on 11/30/15.
//  Copyright © 2015 Cornell Wright. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class IMMSlackerAPI: NSObject {
    
    static let sharedInstance = IMMSlackerAPI();
    let parameters = [
        "Slack.param.token": Slack.param.token,
        "Slack.token.bot": Slack.token.bot
    ]
    
    func rtm_start(completion: (String) -> Void)
    {
        Alamofire.request(.GET, Slack.URL.rtm.start, parameters: [Slack.param.token: Slack.token.bot]).responseJSON {
            response in
            
            
            if response.result.error != nil
            {
                print(response.result.error!.localizedDescription);
                return;
            }
            
            let json = JSON(response.result.value!)
            
            print(json);
            
            if let users = json[Slack.param.users].array
            {
                for user in users
                {
                    // Figure out user ID of bot
                    if user[Slack.param.name].string != nil && user[Slack.param.name].stringValue == Slack.misc.bot_name
                    {
                        IMMSlackerMessageCenterAPI.sharedInstance.botID = user[Slack.param.id].string;
                    }
                    
                    // Store user data in RSMessageCenterAPI for later reference
                    var user_data = [String: AnyObject]();
                    
                    if  let id = user[Slack.param.id].string,
                        let profile = user[Slack.param.profile].dictionary,
                        let color = user[Slack.param.color].string,
                        let image = profile[Slack.param.image_32]?.string
                    {
                        user_data[Slack.param.color] = color;
                        user_data[Slack.param.image] = image;
                        
                        IMMSlackerMessageCenterAPI.sharedInstance.users[id] = user_data;
                    }
                }            }
            
            if let url = json[Slack.param.url].string
            {
                completion(url);
            }
            
        }
    }
    
    func channels_join(channel_name:String, completion: (channelID: String) -> Void)
    {
        Alamofire.request(.GET, Slack.URL.channels.join, parameters: [Slack.param.token: Slack.token.admin, Slack.param.name: channel_name]).responseJSON {
            response in
            
            if response.result.error != nil
            {
                print(response.result.error!.localizedDescription);
                return;
            }
            
            let json = JSON(response.result.value!);
            
            if  let channel = json[Slack.param.channel].dictionary,
                let channelID = channel[Slack.param.id]?.string
            {
                completion(channelID: channelID);
            }
        }
    }
    
    func channels_invite(channelID:String, userID:String, completion: (() -> Void)?)
    {
        Alamofire.request(.GET, Slack.URL.channels.invite, parameters: [Slack.param.token: Slack.token.admin, Slack.param.channel: channelID, Slack.param.user: userID]).responseJSON {
            response in
            
            if response.result.error != nil
            {
                print(response.result.error!.localizedDescription);
                return;
            }
            
            let json = JSON(response.result.value!);
            
            print(json);
            
            if(completion != nil)
            {
                completion!();
            }        }
    }
    
}



func channels_invite(channelID:String, userID:String, completion: (() -> Void)?)
{
    Alamofire.request(.GET, Slack.URL.channels.invite, parameters: [Slack.param.token: Slack.token.admin, Slack.param.channel: channelID, Slack.param.user: userID]).responseJSON {
        response in
        
        if response.result.error != nil
        {
            print(response.result.error!.localizedDescription);
            return;
        }
        
        let json = JSON(response.result.value!);
        
        print(json);
        
        if(completion != nil)
        {
            completion!();
        }
    }
}




