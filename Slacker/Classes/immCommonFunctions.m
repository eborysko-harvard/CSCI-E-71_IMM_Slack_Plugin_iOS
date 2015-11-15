//
//  immCommonFunctions.m
//  Slacker
//
//  Created by Manoj Shenoy on 11/12/15.
//
//

#import "immCommonFunctions.h"

@implementation immCommonFunctions

+ (NSString *) makeRestAPICall : (NSString*) reqURLStr
{
    NSURLRequest *Request = [NSURLRequest requestWithURL:[NSURL URLWithString: reqURLStr]];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: Request returningResponse: &resp error: &error];
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    return responseString;
}

+ (NSString*) getClientID {
    NSArray* URLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    
    if (URLTypes != nil) {
        for (NSDictionary* dict in URLTypes) {
            NSString *urlName = [dict objectForKey:@"CFBundleURLName"];
            if ([urlName isEqualToString:@"slackClientID"]) {
                NSArray* URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
                if (URLSchemes != nil) {
                    return [URLSchemes objectAtIndex:0];
                }
            }
        }
    }
    return nil;
}



+ (void) sendCordovaError:(NSString *)errorMessage
{

 
  //  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
  //                                                messageAsString:@"Unable to authenticate with Slack"];

    
    //[CDVPluginHandleOpenURLNotification commandDelegate sendPluginResult:pluginResult callbackId:currentCallBackID ];
}
@end
