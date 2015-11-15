//
//  immCommonFunctions.h
//  Slacker
//
//  Created by Manoj Shenoy on 11/12/15.
//
//

#import <Foundation/Foundation.h>


@interface immCommonFunctions : NSObject;

+ (NSString *) makeRestAPICall : (NSString*) reqURLStr;

+ (NSString*) getClientID;

+ (void) sendCordovaError: (NSString *) errorMessage;

@end
