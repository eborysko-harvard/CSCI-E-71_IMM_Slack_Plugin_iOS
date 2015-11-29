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

- (NSURLRequest* ) slackAuthenticateURL:(NSDictionary* ) options
{
    
    NSString *scope = @"read";
    
    if(!options)
    {
        scope = [options objectForKey:@"scopes"];
    }
    
    NSString *slackAPIURL = [NSString  stringWithFormat:@"https://slack.com/oauth/authorize?client_id=%@&scope=%@&", self.SlackClientID,scope];
    NSURLRequest *slackRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:slackAPIURL]];
    
    return slackRequest;
    
}


- (BOOL) checkTokenValidity:(NSString *)accessToken
{
    if (accessToken)
    {
        
        NSString *restCallString = [NSString stringWithFormat:@"%@/auth.test?token=%@", slackAPIURL, accessToken];
        
        NSDictionary *responseData = [self makeRestAPICall: restCallString];
        return [responseData objectForKey:@"ok"];
    }
    
    return NO;
    
}


- (NSString*) getSlackAccessCode:(NSString *) slackCode
{
    
    
    NSString *restCallString = [NSString stringWithFormat:@"%@/oauth.access?client_id=%@&client_secret=%@&code=%@", slackAPIURL , self.SlackClientID , self.SlackClientSecret, slackCode ];
    
    NSDictionary *responseData = [self makeRestAPICall: restCallString];
    
    return  [responseData objectForKey:@"access_token"];
}

-(BOOL) checkPresence:(NSString *)userID
{
    NSString *restCallString = [NSString stringWithFormat:@"%@/users.getPresence?token=%@&user=%@", slackAPIURL, self.SlackAccessToken , userID ];
    
    NSDictionary *responseData = [self makeRestAPICall: restCallString];
    
    return [responseData objectForKey:@"presence"];
}



- (NSDictionary *) makeRestAPICall : (NSString*) reqURL
{
    __block NSDictionary *response = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:reqURL]
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *resp,
                                                                NSError *error) {
                                                if(!error)
                                                    response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                else
                                                    @throw error;
                                                dispatch_semaphore_signal(semaphore);
                                                
                                            }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return response;
}


@end
