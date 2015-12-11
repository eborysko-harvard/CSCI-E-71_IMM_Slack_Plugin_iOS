//
//  IMMSlackerSocketAPI.swift
//  IMMSlacker
//
//  Created by Cornell Wright on 11/30/15.
//  Copyright © 2015 Cornell Wright. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class IMMSlackerSocketAPI: NSObject, WebSocketDelegate
{
    
    static let sharedInstance = IMMSlackerSocketAPI();
    var socket:WebSocket?;
    
    var isConnected:Bool {
        return self.socket?.isConnected ?? false;
    }
    
    func connect(url:NSURL)
    {
        self.socket = WebSocket(url: url);
        socket?.delegate = self;
        socket?.connect();
    }
    
    func disconnect()
    {
        socket?.disconnect();
        socket = nil;
    }
    
    func sendMessage(id:Int, type:String, channelID:String, text:String)
    {
        var json:JSON = [Slack.param.id: id,
            Slack.param.type: type,
            Slack.param.channel: channelID,
            Slack.param.text: text];
        
        if let string = json.rawString()
        {
            self.send(string);
        }
    }
    func send(message:String)
    {
        if let socket = self.socket
        {
            if(!socket.isConnected)
            {
                return;
            }
            
            print(message);
            
            socket.writeString(message);
        }
    }
    func websocketDidReceiveMessage(socket: WebSocket, text: String)
    {
        print("websocketDidReceiveMessage:: \(text)");
        
        if let dataFromString = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        {
            let json = JSON(data: dataFromString);
            
            let type = json[Slack.param.type].string;
            let channel = json[Slack.param.channel].string;
            let user = json[Slack.param.user].string;
            let text = json[Slack.param.text].string;
            
            print(type);
            print(channel);
            print(user);
            print(text);
            
            if(channel != IMMSlackerMessageCenterAPI.sharedInstance.channelID)
            {
                return;
            }
            
            if(type == Slack.type.message)
            {
                var info:[String: String] = [Slack.param.text: text!, Slack.param.user: user!];
                print(info);
                
                NSNotificationCenter.defaultCenter().postNotificationName(MessageCenter.notification.newMessage, object: nil, userInfo: info);
            }
            
            if(type == Slack.type.user_typing)
            {
                NSNotificationCenter.defaultCenter().postNotificationName(MessageCenter.notification.userTyping, object: nil, userInfo: nil);
            }
        }
    }
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }
}


