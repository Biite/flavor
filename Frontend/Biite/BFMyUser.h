//
//  BFMyUser.h
//  Biite
//
//  Created by JRRJ on 4/8/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFUser.h"
#import <CoreData/CoreData.h>


extern NSString* const BFMyUserDidLogoutNotification;


@interface BFMyUser : BFUser

@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* deviceToken;
@property (nonatomic, strong) NSString *universalToken;
@property (nonatomic, strong) NSString *fbToken;
@property (nonatomic, strong) NSMutableArray *favorites;
@property (nonatomic) NSUInteger numNotification;
@property (nonatomic) BOOL isAllNotificationOff;
@property (nonatomic) BOOL isLoaded;

+ (instancetype)sharedUser;

+ (void)loadMyUserFromCoreWithAccessToken:(NSString*)aToken withCompletionHandler:(void (^)(NSError *, BFMyUser *))completionHandler;

+ (NSDictionary*)universalTokenInfo;

- (void)recordTokens;
- (void)getAllTokens;
+ (void)clearAllTokens;

+ (NSString*)hashPassword:(NSString*)password;
+ (void)usernameLogin:(NSString*)email password:(NSString*)password withCompletionHandler:(void (^)(NSError *error, BFMyUser *sharedUser))completionHandler;
+ (void)fbLoginwithCompletionHandler:(void (^)(NSError *, BFMyUser *))completionHandler;
- (void)linkFacebook:(void (^)(NSError *))completionHandler;
+ (BOOL)isLoggedIn;

- (void)refreshDataCoreFromInternet;

+ (void)createNewSharedUserWithDict:(NSDictionary*)userDict;

- (void)syncDataCore;

- (void)followUserID:(NSString*)userID withCompletionHandler:(void (^)(NSError *))completionHandler;

+ (void)addPushNotification;
+ (void)readAllNotifications;
+ (NSInteger)numberOfUnReadNotifications:(NSUInteger)numNotif;

+ (void)logout;

@end
