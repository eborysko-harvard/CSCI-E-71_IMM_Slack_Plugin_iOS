//
//  IMMSlackerClient.h
//  IMMSlackerClient
//
//  Created by Manoj Shenoy on 11/26/15.
//  Copyright © 2015 IMM. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for IMMSlackerClient.
FOUNDATION_EXPORT double IMMSlackerClientVersionNumber;

//! Project version string for IMMSlackerClient.
FOUNDATION_EXPORT const unsigned char IMMSlackerClientVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IMMSlackerClient/PublicHeader.h>



@interface IMMSlackerClient : NSObject

@property (nonatomic, assign) NSString* SlackClientID;
@property (nonatomic, assign) NSString* SlackClientSecret;
@property (nonatomic, strong) NSString* SlackAccessToken;

- (NSURLRequest* ) slackAuthenticateURL:(NSArray* ) options;

- (BOOL) checkTokenValidity;

- (NSDictionary* ) makeRestAPICall : (NSString*) reqURL;

- (void) setSlackAccessCode:(NSString *) slackCode;

-(BOOL) checkPresence : (NSString* ) userID;

-(void) postMessage : (NSString* ) channelID : (NSString* ) message;

-(NSDictionary* ) getChannelList : (BOOL) excludeArchived;

+ (id)sharedInstance;

@end


