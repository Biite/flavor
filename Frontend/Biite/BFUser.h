//
//  BFUser.h
//  Biite
//
//  Created by JRRJ on 4/8/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BFUser : NSObject

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *displayName;

@property (nonatomic, strong) NSString *biography;

@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *coverImageURL;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, strong) NSDate *lastActive;

@property (nonatomic) BOOL onlineStatus;

@property (nonatomic) BOOL genericName;
@property (nonatomic) BOOL deletedUser;
@property (nonatomic) BOOL wantsNewImage;

@property (nonatomic) BOOL facebookFollow;

+ (BFUser*)userWithDictionary:(NSDictionary *)userDict;
- (void)configureWithDictionary:(NSDictionary*)userDict;

+ (instancetype)userForID:(NSString*)userID withCompletionHandler:(void (^)(NSError* error, BFUser* user))completionHandler;
- (void)refreshWithCompletionHandler:(void (^)(NSError* error, BFUser* user))completionHandler;

- (void)retrieveProfileImageWithCompletionHandler:(void (^)(NSError *, UIImage *, id))completionHandler andKey:(id)key;
- (void)retrieveCoverImageWithCompletionHandler:(void (^)(NSError *, UIImage *, id))completionHandler andKey:(id)key;

+ (NSDate*) dateFromString:(NSString*) dateString;

@end
