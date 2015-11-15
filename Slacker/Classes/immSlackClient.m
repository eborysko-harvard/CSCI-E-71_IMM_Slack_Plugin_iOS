//
//  immSlackClient.m
//  Slacker
//
//  Created by Manoj Shenoy on 11/11/15.
//
//

#import "immSlackClient.h"
#import "AppDelegate.h"
#import "immCommonFunctions.h"

//static void slackLoadMethod(Class class, SEL destinationSelector, SEL sourceSelector);

const NSString *slackAPIURL = @"https://slack.com/api/";
static NSString *slackClientSecret = @"75d676a163b2e485f8428a1b0d1f710c"; // move to UI - supplied by user
NSString *slackClientID;
NSString *currentCallBackID;


NSString *slackAccessToken;

@implementation AppDelegate (SlackReturnHandle)


- (BOOL)application: (UIApplication *)application
                     openURL: (NSURL *)url
           sourceApplication: (NSString *)sourceApplication
                  annotation: (id)annotation {
            // call super
    
    if([url.scheme isEqualToString:@"slacker"]){
        
        //unload the authentication page if loaded.
        for(UIView *subview in [self.viewController.view subviews]){
            if(subview.tag == 5)
            {
                [subview removeFromSuperview];
            }
        }
        
        
        NSArray *queryParams = [[url query] componentsSeparatedByString:@"&"];
        NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];

        if([codeParam count] == 0)
        {
            // Need to send error to UI here.
            [self.viewController.webView stringByEvaluatingJavaScriptFromString:@"errorHandlerFunction('Unable to authenticate with Slack');"];
            return NO;
          //  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
          //                                                    messageAsString:@"Unable to authenticate with Slack"];
            //[self.commandDelegate sendPluginResult:pluginResult callbackId:currentCallBackID ];
        }
        else
        {
            NSString *codeQuery = [codeParam objectAtIndex:0];
            NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
            immSlackClient *immClient = [immSlackClient alloc];
            [immClient getSlackAccessCode:code];
        }
        

        
        
    }
    
   // return [self application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
    
}




@end


@implementation immSlackClient


- (void) cordovaSlackAuthenticate:(CDVInvokedUrlCommand *)command
{
 
    currentCallBackID = command.callbackId;
    slackClientID =[immCommonFunctions getClientID];
    
    if(!slackClientID)
    {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"Missing client ID url scheme in app .plist"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
        return;
    }
    
    [self slackAuthenticate];

    
}

- (void) cordovaSlackPresence:(CDVInvokedUrlCommand *)command
{
    NSString* userID = [command.arguments objectAtIndex:0];

    
    NSString *presence = [self slackPresence:userID];
    NSDictionary *jsonObj = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"success",
                             presence, @"presence", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getSlackAccessCode:(NSString *) slackCode
{
    
    NSURLConnection *slackConnection;
    if(!slackClientID)
    {
        slackClientID = [immCommonFunctions getClientID];
    }
    
    if(!slackCode)
    {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"Unable to authenticate with Slack"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:currentCallBackID ];
        return;
    }

    // Create the REST call string.
    NSString *restCallString = [NSString stringWithFormat:@"%@/oauth.access?client_id=%@&client_secret=%@&code=%@", slackAPIURL , slackClientID , slackClientSecret , slackCode ];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    NSString *responseString = [immCommonFunctions makeRestAPICall: restCallString];
    NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    slackAccessToken = [jsonArray objectForKey:@"access_token"];
   
    
    slackConnection = [[NSURLConnection alloc]   initWithRequest:restRequest delegate:self];
    
    //This should be stub code. Need to figure how to move this one
  
  //  AppDelegate *slackAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
   // NSString *slackNavigatePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
   // [slackAppDelegate.viewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:slackNavigatePath]]];
    
    NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",
                             slackAccessToken, @"accessToken", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:jsonObj];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:currentCallBackID ]; //This callback is not working
    
}



#pragma mark - Slack_Utility

-(void)slackAuthenticate
{
    
    NSString *slackAPIURL = [NSString  stringWithFormat:@"https://slack.com/oauth/authorize?client_id=%@&scope=read", slackClientID];
    NSURLRequest *slackRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:slackAPIURL]];
    
    CDVViewController* viewController = [CDVViewController new];
    viewController.view.tag = 5;
    [self.viewController.view addSubview:viewController.view];

    [viewController.webView loadRequest:slackRequest];
    
    NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",
                             slackAccessToken, @"accessToken", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:jsonObj];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];

    //[self.commandDelegate sendPluginResult:pluginResult callbackId: currentCallBackID];
    

}

- (NSString *)slackPresence:(NSString *)userID
{
    NSString *restCallString = [NSString stringWithFormat:@"%@/users.getPresence?token=%@&user=%@", slackAPIURL, slackAccessToken , userID ];
    
    NSString *responseString = [immCommonFunctions makeRestAPICall: restCallString];
    NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    return  [jsonArray objectForKey:@"presence"];

}







@end
