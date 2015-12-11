//
//  IMMSlackerClient.m
//  IMMSlackerClient
//
//  Created by Manoj Shenoy on 11/26/15.
//  Copyright © 2015 IMM. All rights reserved.
//

#import "IMMSlackerClient.h"
const NSString *slackAPIURL = @"https://slack.com/api/";

@implementation IMMSlackerClient

@synthesize SlackClientID;

- (NSURLRequest* ) slackAuthenticateURL:(NSArray* ) options
{
    
    NSString *scope = @"channels:read";
    if(options)
    {
        NSDictionary *optionsSelected = [options objectAtIndex:0];
        
        if(optionsSelected )
        {
            scope = [optionsSelected objectForKey:@"scopes"];
        }
    }
    
    NSString *slackAPIURL = [NSString  stringWithFormat:@"https://slack.com/oauth/authorize?client_id=%@&scope=%@&", self.SlackClientID,scope];
    NSURLRequest *slackRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:slackAPIURL]];
    return slackRequest;
    
}


- (BOOL) checkTokenValidity
{
    if (self.SlackAccessToken)
    {
        
        NSString *restCallString = [NSString stringWithFormat:@"%@/auth.test?token=%@", slackAPIURL, self.SlackAccessToken];
        
        NSDictionary *responseData = [self makeRestAPICall: restCallString];
        return [[responseData objectForKey:@"ok"]boolValue];
    }
    
    return NO;
    
}


- (void) setSlackAccessCode:(NSString *) slackCode
{
    
    @try
    {
        NSString *restCallString = [NSString stringWithFormat:@"%@/oauth.access?client_id=%@&client_secret=%@&code=%@", slackAPIURL , self.SlackClientID , self.SlackClientSecret, slackCode ];
        
        NSDictionary *responseData = [self makeRestAPICall: restCallString];
        
        self.SlackAccessToken  = [responseData objectForKey:@"access_token"];
    }
    @catch (NSException *exception) {
        @throw exception;
        
    }
}

-(BOOL) checkPresence:(NSString *)userID
{
    NSString *restCallString = [NSString stringWithFormat:@"%@/users.getPresence?token=%@&user=%@", slackAPIURL, self.SlackAccessToken , userID ];
    
    NSDictionary *responseData = [self makeRestAPICall: restCallString];
    
    return [[responseData objectForKey:@"presence"]boolValue];
}


- (void) postMessage:(NSString *)channelID :(NSString *)message
{
    NSString *restCallString = [NSString stringWithFormat:@"%@/chat.postMessage?token=%@&channel=%@&text=%@&as_user=true", slackAPIURL, self.SlackAccessToken , channelID, [ message stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet]];
    
    [self makeRestAPICall: restCallString];
    
}


- (NSDictionary *) makeRestAPICall : (NSString*) reqURL
{
    @try {
        __block NSDictionary *response = nil;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:reqURL]
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *resp,
                                                                    NSError *error) {
                                                    if(!error)
                                                        response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                
                                                    dispatch_semaphore_signal(semaphore);
                                                    
                                                }];
        [dataTask resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return response;
    }
    @catch (NSError *exception) {
        @throw exception;
    }
    
}

+ (id)sharedInstance
{
    //This will ensure that only one instance of the IMMSlackerClient object exists

    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

@end
