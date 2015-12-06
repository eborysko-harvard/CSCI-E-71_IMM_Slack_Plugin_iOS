//
//  IMMSlackerClientTests.m
//  IMMSlackerClientTests
//
//  Created by Manoj Shenoy on 12/1/15.
//  Copyright © 2015 IMM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IMMSlackerClient.h"

@interface IMMSlackerClientTests : XCTestCase

@end

@implementation IMMSlackerClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSlackAuthenticateURL
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
   NSString *slackURL = @"https://slack.com/oauth/authorize?client_id=(null)&scope=channels:read&";
    NSURLRequest *slackRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:slackURL]];
    XCTAssertEqualObjects(slackRequest , [immSlackerClient slackAuthenticateURL:nil]);
}

- (void)testSlackAuthenticateURLWithOptions
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    NSString *slackURL = @"https://slack.com/oauth/authorize?client_id=(null)&scope=channels:read+chat:write:user&";
    NSURLRequest *slackRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:slackURL]];
    NSDictionary *normalDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"channels:read+chat:write:user",@"scopes",nil];
    NSArray *options = [[NSArray alloc] initWithObjects:normalDict, nil];

    XCTAssertEqualObjects(slackRequest , [immSlackerClient slackAuthenticateURL:options]);
}


- (void)testsetSlackAccessCode
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    XCTAssertNoThrow( [immSlackerClient setSlackAccessCode:nil]);
}

- (void)testCheckTokenValidityFalse
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    immSlackerClient.SlackAccessToken = @"triojeoijrogjiofgjdfg"; // Invalid Token
    
    XCTAssertEqual(NO, [immSlackerClient checkTokenValidity]);
}

- (void)testCheckTokenValidityTrue
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    immSlackerClient.SlackAccessToken = @"xoxp-10020492535-10633604503-14277704819-ff5c0a80c0"; // Valid Token Token
    
    XCTAssertEqual(YES, [immSlackerClient checkTokenValidity]);
}

- (void)testCheckTokenValidityNil
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    immSlackerClient.SlackAccessToken = Nil;
    
    XCTAssertEqual(NO, [immSlackerClient checkTokenValidity]);
}

- (void)testPostMessage
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    immSlackerClient.SlackAccessToken = @"xoxp-10020492535-10633604503-14277704819-ff5c0a80c0";

    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];

    
    XCTAssertNoThrow([immSlackerClient postMessage:@"C0F6U0R5E" :[@"Automated Test Message at " stringByAppendingString:dateString ]] );
}

- (void)testcheckPresenceFalse
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    immSlackerClient.SlackAccessToken = @"xoxp-10020492535-10633604503-14277704819-ff5c0a80c0";
    

    XCTAssertFalse([immSlackerClient checkPresence:@"C0F6U0R5E"] );
}

-(void)testmakeRestAPICallError
{
    
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    immSlackerClient.SlackAccessToken = @"xoxp-10020492535-10633604503-14277704819-ff5c0a80c0";
    
    
    XCTAssertThrows([immSlackerClient makeRestAPICall:@"C0F6U0R5E"] );
}

@end
