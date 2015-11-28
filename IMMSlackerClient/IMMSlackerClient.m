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
        
        NSString *responseString = [self makeRestAPICall: restCallString];
        NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
//        if([jsonArray objectForKey:@"ok"])
//            self.loggedinUserName = [jsonArray objectForKey:@"user"];
        return [jsonArray objectForKey:@"ok"];
    }
    
    return NO;
    
}


- (NSString*) getSlackAccessCode:(NSString *) slackCode
{
    

        NSString *restCallString = [NSString stringWithFormat:@"%@/oauth.access?client_id=%@&client_secret=%@&code=%@", slackAPIURL , self.SlackClientID , self.SlackClientSecret, slackCode ];
        
        NSString *responseString = [self makeRestAPICall: restCallString];
        NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        return  [jsonArray objectForKey:@"access_token"];
    
    
}



- (NSString *) makeRestAPICall : (NSString*) reqURL
{
    NSURLRequest *Request = [NSURLRequest requestWithURL:[NSURL URLWithString: reqURL]];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: Request returningResponse: &resp error: &error];
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    return responseString;
}


@end
