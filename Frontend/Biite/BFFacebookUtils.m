//
//  MTFacebookUtils.m
//  Movett
//
//  Created by Jarrett Chen on 9/12/15.
//  Copyright (c) 2015 Movett. All rights reserved.
//

#import "BFFacebookUtils.h"


NSString* const BFFacebookUserDidLoginNotification = @"BFFacebookUserDidLoginNotification";
NSString* const BFFacebookUserDidLogoutNotification = @"BFFacebookUserDidLogoutNotification";
NSString* const BFFacebookSessionErrorNotification = @"BFFacebookSessionErrorNotification";
NSString* const BFFacebookUserDidCancelNotification = @"BFFacebookUserDidCancelNotification";
NSString* const BFFacebookSessionErrorNotificationErrorMessageKey = @"BFFacebookSessionErrorNotificationErrorMessageKey";
NSString* const BFFacebookAccessTokenKey = @"BFFacebookAccessTokenKey";


@implementation BFFacebookUtils

+ (NSArray*)initialReadPermissions
{
    return @[@"public_profile", @"email", @"user_friends"];
}

+ (void)clearAccessToken
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

+ (void)openSession
{
    NSLog(@"OPENSESSION");
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:[BFFacebookUtils initialReadPermissions]
                 fromViewController:nil
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error)
        {
            // Process error
            NSLog(@"error %@",error);
            [[NSNotificationCenter defaultCenter] postNotificationName:BFFacebookSessionErrorNotification object:nil];
        }
        else if (result.isCancelled)
        {
            // Handle cancellations
            NSLog(@"error cancled");
        }
        else
        {
            NSLog(@"fab result: %@",result.token.tokenString);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BFFacebookUserDidLoginNotification object:nil];
        }
    }];
}

+ (BOOL)isLoggedIn
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        // User is logged in, do work such as go to next view controller.
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSDictionary *)accessTokenInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        // User is logged in, do work such as go to next view controller.
        return @{@"access_token":[FBSDKAccessToken currentAccessToken].tokenString};
    }
    else
    {
        return nil;
    }

    //    if(FBSession.activeSession.isOpen) {
    //        DLog(@"access %@", [FBSettings sdkVersion]);
    //        return @{@"access_token":FBSession.activeSession.accessTokenData.accessToken};
    //    }
    //    return nil;
}

+ (void)getMeInfoWithCompletionHandler:(void (^)(FBSDKGraphRequestConnection *connection, id result, NSError *fbError))completionHandler
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields":@"id,email,first_name,last_name,gender,link,picture.width(400).height(400)"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
    {
         dispatch_async(dispatch_get_main_queue(), ^{
             if(completionHandler)
             {
                 completionHandler(connection, result, error);
             }
         });
    }];
}

@end
