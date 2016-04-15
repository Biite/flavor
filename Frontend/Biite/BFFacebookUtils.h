//
//  MTFacebookUtils.h
//  Movett
//
//  Created by Jarrett Chen on 9/12/15.
//  Copyright (c) 2015 Movett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

extern NSString* const BFFacebookUserDidLoginNotification;
extern NSString* const BFFacebookUserDidLogoutNotification;
extern NSString* const BFFacebookUserDidCancelNotification;
extern NSString* const BFFacebookSessionErrorNotification;
extern NSString* const BFFacebookSessionErrorNotificationErrorMessageKey;
extern NSString* const BFFacebookAccessTokenKey;

@interface BFFacebookUtils : NSObject

+ (void)clearAccessToken;
+ (void)openSession;
+ (BOOL)isLoggedIn;
+ (NSDictionary *)accessTokenInfo;
+ (void)getMeInfoWithCompletionHandler:(void (^)(FBSDKGraphRequestConnection *connection, id result, NSError *fbError))completionHandler;

@end
