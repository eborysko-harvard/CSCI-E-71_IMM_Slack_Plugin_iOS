//
//  immSlackClient.h
//  Slacker
//
//  Created by Manoj Shenoy on 11/11/15.
//
//

#import <Cordova/CDV.h>

@interface immSlackClient : CDVPlugin

@property (nonatomic, copy) NSString* clientID;
@property (nonatomic, assign) BOOL isSigningIn;
@property (nonatomic, assign) NSString* slackCode;


- (void) cordovaSlackAuthenticate:(CDVInvokedUrlCommand *) command;

- (void) cordovaSlackPresence:(CDVInvokedUrlCommand *) command;

//- (void) cordovaSlackLogout:(CDVInvokedUrlCommand *) command;

- (void) getSlackAccessCode:(NSString* ) slackCode;

#pragma mark - Slack_Utility

- (void) slackAuthenticate;

- (NSString *) slackPresence:(NSString* ) userID;


//-(void) slackLogout;

@end
