//
//  BFUser.m
//  Biite
//
//  Created by JRRJ on 4/8/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFUser.h"
#import "BFMyUser.h"
#import "BFAPI.h"
#import "BFFacebookUtils.h"
#import <SDWebImage/SDWebImageManager.h>
#import "NSDate+DateTools.h"


static NSCache* users = nil;

#define VCUSER_IMAGE_CACHE_COST_LIMIT 10*1024*1024


@implementation BFUser

+ (BFUser *)userWithDictionary:(NSDictionary *)userDict
{
    if(!userDict || ![userDict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    return [[BFUser alloc] initWithDictionary:userDict];
}

- (instancetype)initWithDictionary:(NSDictionary *)userDict
{
    self = [super init];
    if(self)
    {
        [self configureWithDictionary:userDict];
    }
    return self;
}

- (void)configureWithDictionary:(NSDictionary*)userDict
{
    NSLog(@"userdict %@",userDict);
    
    self.userID = userDict[@"_id"];
    self.username = userDict[@"username"];
    self.firstName = userDict[@"firstName"];
    self.displayName = userDict[@"displayName"];
    self.biography = userDict[@"biography"];
    self.profileImageURL = userDict[@"profileImageURL"];
    self.coverImageURL = userDict[@"coverImageURL"];
    self.onlineStatus = [userDict[@"onlineStatus"] boolValue];
    
    [self retrieveProfileImageWithCompletionHandler:^(NSError *error, UIImage *image, id result) {} andKey:nil];
    [self retrieveCoverImageWithCompletionHandler:^(NSError *error, UIImage *image, id result) {} andKey:nil];
}

+ (instancetype)userForID:(NSString *)userID withCompletionHandler:(void (^)(NSError *, BFUser *))completionHandler
{
    NSLog(@"Getting user for ID: %@", userID);
    if(!userID || userID == (id)[NSNull null])
    {
        if(completionHandler)
        {
            completionHandler(nil, nil);
        }
        return nil;
    }

    if([userID isEqualToString:[BFMyUser sharedUser].userID])
    {
        if(completionHandler)
        {
            completionHandler(nil, [BFMyUser sharedUser]);
        }
        return [BFMyUser sharedUser];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        users = [[NSCache alloc] init];
        [users setCountLimit:250];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:BFMyUserDidLogoutNotification object:nil];
    });

    BFUser* user = [users objectForKey:userID];
    if(user)
    {
        if(completionHandler)
        {
            completionHandler(nil, user);
        }
        return user;
    }
    
    user = [[BFUser alloc] init];
    user.userID = userID;
    user.firstName = @"BF";
    
    [user refreshWithCompletionHandler:^(NSError *error, BFUser *user) {
        if(!error) {
            [users setObject:user forKey:user.userID];
        }
        if(completionHandler) {
            completionHandler(error, user);
        }
    }];
    return user;
}

- (void)refreshWithCompletionHandler:(void (^)(NSError *, BFUser *))completionHandler
{
    [BFAPI getUserInfo:self.userID withCompletionHandler:^(NSError *error, id result)
    {
        if(error)
        {
            if([error.domain isEqualToString:BFNetworkErrorDomain] || error.code == BFNETWORK_NOT_FOUND_ERROR_CODE)
            {
                error = nil;
            }
            if(completionHandler)
            {
                completionHandler(error, self);
            }
            return;
        }
        else
        {
            NSDictionary *userDict = result;
            
            self.userID = userDict[@"_id"];
            self.username = userDict[@"username"];
            self.firstName = userDict[@"firstName"];
            self.displayName = userDict[@"displayName"];
            self.biography = userDict[@"biography"];
            self.profileImageURL = userDict[@"profileImageURL"];
            self.coverImageURL = userDict[@"coverImageURL"];
            self.onlineStatus = [userDict[@"onlineStatus"] boolValue];
            
            self.lastActive = [BFUser dateFromString:userDict[@"lastActive"]];

            if(completionHandler) {
                completionHandler(nil, self);
            }
        }
    }];
}

- (void)retrieveProfileImageWithCompletionHandler:(void (^)(NSError *, UIImage *, id))completionHandler andKey:(id)key
{
    if (!self.userID || self.userID == (id)[NSNull null] || !self.profileImageURL || self.profileImageURL == (id)[NSNull null])
    {
        if(completionHandler)
        {
            completionHandler(nil, [UIImage imageNamed:@"pf_placeholder"], key);
        }
        return;
    }
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.profileImageURL]
                                                    options:(self.wantsNewImage ? SDWebImageRefreshCached :0)
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if(error)
        {
            if(completionHandler)
            {
                completionHandler(error, [UIImage imageNamed:@"pf_placeholder"], key);
            }
            return;
        }
        else
        {
            self.profileImage = image;
            self.wantsNewImage=NO;
            if(completionHandler)
            {
                completionHandler(nil, image, key);
            }
        }
    }];
}

- (void)retrieveCoverImageWithCompletionHandler:(void (^)(NSError *, UIImage *, id))completionHandler andKey:(id)key
{
    if(!self.userID || self.userID == (id)[NSNull null] || !self.coverImageURL || self.coverImageURL == (id)[NSNull null])
    {
        if(completionHandler)
        {
            //            completionHandler(nil, [UIImage imageNamed:@"coverImage"], key);
            completionHandler(nil, [UIImage imageNamed:@""], key);
        }
        return;
    }
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.coverImageURL]
                                                    options:(self.wantsNewImage ? SDWebImageRefreshCached :0)
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if(error)
        {
            if(completionHandler)
            {
                //                completionHandler(error, [UIImage imageNamed:@"coverImage"], key);
                completionHandler(error, [UIImage imageNamed:@""], key);
            }
            return;
        }
        else
        {
            self.coverImage = image;
            self.wantsNewImage=NO;
            if(completionHandler)
            {
                completionHandler(nil, image, key);
            }
        }
    }];
}

+ (NSDate*)dateFromString:(NSString*)dateString
{
    static NSDateFormatter* formatter = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate ,^ {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
    });
    return [formatter dateFromString:dateString];
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (![object isKindOfClass:[BFUser class]])
    {
        return NO;
    }
    
    BFUser* other = object;
    return [self.userID isEqualToString:other.userID];
}

- (NSUInteger)hash
{
    return [self.userID hash];
}

- (void)clearCache
{
    [users removeAllObjects];
}

@end
