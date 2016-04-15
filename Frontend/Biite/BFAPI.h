//
//  BFAPI.h
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFUser.h"


extern NSString* const BFNetworkErrorStatusCodeKey;
extern NSString* const BFNetworkErrorMessageKey;
extern NSString* const BFNetworkErrorDomain;
extern NSString* const kBackendVersion;

#define BFNETWORK_GENERIC_ERROR_CODE 1400
#define BFNETWORK_FORBIDDEN_ERROR_CODE 1403
#define BFNETWORK_NOT_FOUND_ERROR_CODE 404
#define BFNETWORK_REJECT_ERROR_CODE 1401
#define NETWORK_NOT_AUTHORIZED_ERROR_CODE 401
#define BFNETWORK_VALIDATION_ERROR_CODE 1422
#define BFNETWORK_SERVER_ERROR_CODE 1500
#define BFNETWORK_SUCCESS_CODE 200
#define BFNETWORK_FACEBOOK_REJECT 500
#define NETWORK_NO_HOST -1004
#define NETWORK_NO_INTERNET -1009


@interface BFAPI : NSObject

+ (NSURL *)serverURL;
+ (NSURL *)serverURLWithPath:(NSString *)path;

+ (void)signupWithUsername:(NSString *)username
                     email:(NSString *)email
                  password:(NSString *)password
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                    gender:(NSString *)gender
                 biography:(NSString *)biography
           profileImageURL:(NSString *)profileImageURL
             coverImageURL:(NSString *)coverImageURL
     withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

+ (void)emailValidation:(NSString *)email withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;
+ (void)userValidation:(NSString *)username withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;
+ (void)logoutWithUsername:(NSString *)username withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

+ (void)loginWithFB:(id)accessToken withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;
+ (void)linkFacebook:(NSString *)extID withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

+ (void)forgotPasswordWithEmail:(NSString*)email withCompletionHandler:(void (^)(NSError *))completionHandler;

+ (void)getRefreshUserWithCompletionHandler:(void(^)(NSError * error, id result))completionHandler;
+ (void)getUserInfo:(NSString *)userID withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

//+ (void)getAllRecipes

+ (void)getSellerRecipes:(NSString *)userID withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

+ (void)setDeviceToken:(NSString *)deviceToken withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

+ (void)getFavoriteUsersWithCompletionHandler:(void(^)(NSError * error, id result))completionHandler;
+ (void)addFavoriteUser:(NSString *)userID withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;
+ (void)delFavoriteUser:(NSString *)userID withCompletionHandler:(void(^)(NSError * error, id result))completionHandler;

@end
