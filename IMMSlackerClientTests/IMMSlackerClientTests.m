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
    XCTAssertNoThrow([immSlackerClient slackAuthenticateURL:nil]);
}

- (void)testCheckTokenValidity
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    immSlackerClient.SlackAccessToken = @"triojeoijrogjiofgjdfg";
    
    XCTAssertEqual(NO, [immSlackerClient checkTokenValidity]);
}
@end
