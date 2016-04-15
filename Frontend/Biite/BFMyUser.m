//
//  BFMyUser.m
//  Biite
//
//  Created by JRRJ on 4/8/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFMyUser.h"
#import "BFAPI.h"
#import "BFFacebookUtils.h"
#import "NSDate+DateTools.h"
#import <SDWebImage/SDWebImageManager.h>
#import <CoreData/CoreData.h>
#import <CommonCrypto/CommonHMAC.h>
#import "UIDevice+Version.h"


NSString* const BFMyUserDidLogoutNotification = @"BFMyUserDidLogoutNotification";

static BFMyUser* sharedUser = nil;


@implementation BFMyUser

@synthesize deviceToken  = _deviceToken;

+ (instancetype) sharedUser
{
    return sharedUser;
}

+ (void)loadMyUserFromCoreWithAccessToken:(NSString*)aToken withCompletionHandler:(void (^)(NSError *, BFMyUser *))completionHandler
{
    sharedUser = nil;
    
    @synchronized(self)
    {
        sharedUser =[[BFMyUser alloc]init];
        
        NSManagedObjectContext *context = [BFMyUser managedObjectContext];
        
        //Load shared user from core data
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserObject"];
        request.predicate = [NSPredicate predicateWithFormat:@"universalToken = %@",aToken];
        
        NSError *error;
        NSArray *foundUser = [context executeFetchRequest:request error:&error];
        NSManagedObject *currentUser =nil;
        
        NSLog(@"data core count: %lu",(unsigned long)[foundUser count]);
        
        if (!foundUser || error ||([foundUser count]>1))
        {
            NSLog(@"ERROR found:%@",foundUser);
            if ([foundUser count]>1)
            {
                NSFetchRequest *errorRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserObject"];
                NSArray *errorUserArray =[context executeFetchRequest:errorRequest error:&error];
                for (NSManagedObject *deleteUser in errorUserArray) {
                    [context deleteObject:deleteUser];
                }
            }
            
            //logout
            completionHandler(nil, nil);
        }
        else if([foundUser count])
        {
            currentUser = [foundUser firstObject];
            
            sharedUser.userID = [currentUser valueForKey:@"userID"];
            sharedUser.username = [currentUser valueForKey:@"username"];
            sharedUser.email = [currentUser valueForKey:@"email"];
            sharedUser.firstName = [currentUser valueForKey:@"firstName"];
            sharedUser.lastName = [currentUser valueForKey:@"lastName"];
            sharedUser.displayName = [currentUser valueForKey:@"displayName"];
            sharedUser.profileImageURL = [currentUser valueForKey:@"profileImageURL"];
            sharedUser.coverImageURL = [currentUser valueForKey:@"coverImageURL"];
            sharedUser.wantsNewImage = YES;
            sharedUser.universalToken = aToken;
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:sharedUser.profileImageURL] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
            {
                sharedUser.profileImage = image;
            }];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:sharedUser.coverImageURL] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
            {
                sharedUser.coverImage = image;
            }];
            
            completionHandler(nil, sharedUser);
        }
        else
        {
            //logout
            completionHandler(nil, nil);
        }
    }
}

+ (NSDictionary*)universalTokenInfo
{
    NSString *universalToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"universalToken"];
    
    if (universalToken)
    {
        // User is logged in, do work such as go to next view controller.
        return @{@"auth_token":universalToken};
    }
    else
    {
        return nil;
    }
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    if (deviceToken)
    {
        _deviceToken = deviceToken;
        
        [BFAPI setDeviceToken:deviceToken withCompletionHandler:^(NSError *error, id result)
        {
            if(error)
            {
                NSLog(@"push error: %@", error);
            }
        }];
    }
}

- (void)recordTokens
{
    [[NSUserDefaults standardUserDefaults] setObject:self.universalToken forKey:@"universalToken"];
    [[NSUserDefaults standardUserDefaults] setObject:self.fbToken forKey:@"fbToken"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getAllTokens
{
    self.universalToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"universalToken"];
    self.fbToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"fbToken"];
}

+ (void)clearAllTokens
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"universalToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)hashPassword:(NSString*)password
{
    const char *s=[password cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (unsigned)(int)keyData.length, digest);
    NSData *out1=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    NSString *hash=[out1 description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}

+ (void)usernameLogin:(NSString*)email
             password:(NSString*)password
withCompletionHandler:(void (^)(NSError *error, BFMyUser *sharedUser))completionHandler
{
    NSString* hashPass = [self hashPassword:password];
    
    [BFAPI loginWithUsername:email password:hashPass withCompletionHandler:^(NSError *error, id result)
    {
        if (error)
        {
            completionHandler(error,nil);
        }
        else
        {
            NSLog(@"USER! %@",result);
            sharedUser = nil;
            
            @synchronized(self)
            {
                sharedUser = [[BFMyUser alloc] init];
                
                [sharedUser configureWithDictionary:result[@"user"]];
                [sharedUser syncDataCore];
                
                completionHandler(error,sharedUser);
            }
        }
    }];
}

+ (void)fbLoginwithCompletionHandler:(void (^)(NSError *, BFMyUser *))completionHandler
{
    if(![BFFacebookUtils accessTokenInfo])
    {
        if(completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, nil);
            });
        }
        return;
    }
    
    [BFAPI loginWithFB:[BFFacebookUtils accessTokenInfo] withCompletionHandler:^(NSError *error, id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                completionHandler(error,nil);
            }
            else
            {
                sharedUser = nil;
                
                @synchronized(self)
                {
                    sharedUser = [[BFMyUser alloc] init];
                    
                    [sharedUser configureWithDictionary:result[@"user"]];
                    [sharedUser syncDataCore];
                    
                    completionHandler(error,sharedUser);
                }
            }
        });
    }];
}

//- (void)refreshWithCompletionHandler:(void (^)(NSError *, BFUser *))completionHandler
//{
//    NSLog(@"ATTEMPTING LOGIN");
//    if(![BFFacebookUtils accessTokenInfo])
//    {
//        if(completionHandler)
//        {
//            completionHandler(nil, nil);
//        }
//        return;
//    }
//    
//    NSMutableDictionary* dataDict = [[BFFacebookUtils accessTokenInfo] mutableCopy];
//    
//    dataDict[@"loginType"] = @"facebook";
//    if(!dataDict) return;
//    
//    [MTNetworkUtils postToRoute:@"user/login"
//                     withParams:nil
//                 withJSONObject:dataDict
//          withCompletionHandler:^(NSError *error, id result)
//     {
//         NSLog(@"RECEIVED LOGIN INFO");
//         if(error)
//         {
//             sharedUser = nil;
//             if(completionHandler)
//             {
//                 completionHandler(error, nil);
//             }
//             return;
//         }
//         
//         [self configureWithDictionary:result[@"user"]];
//         if(completionHandler)
//         {
//             completionHandler(nil, self);
//         }
//     }];
//}

- (void)linkFacebook:(void (^)(NSError *))completionHandler
{
    if(![BFFacebookUtils accessTokenInfo])
    {
        if(completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil);
            });
        }
        return;
    }
    
    [BFFacebookUtils getMeInfoWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *fbError)
     {
         if(!fbError)
         {
             if (result[@"id"])
             {
                 NSLog(@"Facebook Login results: %@",result);
                 
                 NSString *extID = result[@"id"];
                 
                 [BFAPI linkFacebook:extID withCompletionHandler:^(NSError *error, id result)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (error)
                          {
                              completionHandler(error);
                          }
                          else
                          {
                              [self configureWithDictionary:result[@"user"]];
                              [self syncDataCore];
                              completionHandler(error);
                          }
                      });
                  }];
             }
         }
     }];
}

+ (BOOL)isLoggedIn
{
    NSString *universalToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"universalToken"];
    
    if (universalToken)
    {
        // User is logged in, do work such as go to next view controller.
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (void)createNewSharedUserWithDict:(NSDictionary*)userDict
{
    sharedUser = nil;
    
    @synchronized(self)
    {
        sharedUser =[[BFMyUser alloc]init];
        
        [sharedUser configureWithDictionary:userDict];
        [sharedUser syncDataCore];
    }
}

- (void)refreshDataCoreFromInternet
{
    [BFAPI getRefreshUserWithCompletionHandler:^(NSError *error, id result)
    {
        if(error)
        {
            return;
        }
        
        [self configureWithDictionary:result[@"user"]];        
        [self syncDataCore];
    }];
}

- (void)configureWithDictionary:(NSDictionary*)userDict
{
    NSLog(@"userdict %@",userDict);
    
    self.userID = userDict[@"_id"];
    self.username = userDict[@"username"];
    self.email = userDict[@"email"];
    self.firstName = userDict[@"firstName"];
    self.lastName = userDict[@"lastName"];
    self.displayName = userDict[@"displayName"];
    self.biography = userDict[@"biography"];
    self.profileImageURL = userDict[@"profileImageURL"];
    self.coverImageURL = userDict[@"coverImageURL"];
    self.wantsNewImage = YES;
    self.lastActive = [NSDate date];
    self.universalToken =userDict[@"universalToken"];
    self.fbToken = userDict[@"fbToken"];
    self.isLoaded=YES;
    
//    self.isAllNotificationOff = [userDict[@"notifications"][@"notificationAllOff"] boolValue];
    
//    [BFMyUser addPushNotification];
//    
//    self.numNotification = [userDict[@"numNotif"] integerValue];
//    
//    //    NSUInteger numUnreadMessages = [BFMyUser numberOfUnReadNotifications:0];
//    
//    NSDictionary *dictNotif = @{@"numNotif":[NSNumber numberWithInteger:self.numNotification]};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarBadge" object:nil userInfo:dictNotif];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.profileImageURL] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         self.profileImage = image;
     }];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.coverImageURL] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         self.coverImage = image;
     }];
}

- (void)syncDataCore
{
    NSManagedObjectContext *context = [BFMyUser managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserObject"];
    request.predicate = [NSPredicate predicateWithFormat:@"userID = %@",self.userID];
    
    NSError *error;
    NSArray *foundUser = [context executeFetchRequest:request error:&error];
    
    NSLog(@"Sync datacore: %lu",(unsigned long)[foundUser count]);
    
    NSManagedObject *currentUser =nil;
    
    if (!foundUser || error ||([foundUser count]>1))
    {
        NSLog(@"ERROR found:%@",foundUser);
        abort();
    }
    else if([foundUser count])
    {
        currentUser = [foundUser firstObject];
    }
    else
    {
        //if not found, put the new user from database to data core
        currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserObject" inManagedObjectContext:context];
        NSLog(@"create the new user for data core");
    }
    
    [currentUser setValue:self.userID forKey:@"userID"];
    [currentUser setValue:self.username forKey:@"username"];
    [currentUser setValue:self.email forKey:@"email"];
    [currentUser setValue:self.firstName forKey:@"firstName"];
    [currentUser setValue:self.lastName forKey:@"lastName"];
    [currentUser setValue:self.displayName forKey:@"displayName"];
    [currentUser setValue:self.profileImageURL forKey:@"profileImageURL"];
    [currentUser setValue:self.coverImageURL forKey:@"coverImageURL"];
    [currentUser setValue:self.universalToken forKey:@"universalToken"];
    [context save:nil];
    
    [self recordTokens];
}

- (void)followUserID:(NSString*)userID withCompletionHandler:(void (^)(NSError *))completionHandler
{
    if (![self.userID isEqualToString:userID])
    {
        [BFAPI addFavoriteUser:userID withCompletionHandler:^(NSError *error, id result)
        {
            if(!error)
            {
                [self.favorites addObject:userID];
            }
            completionHandler(error);
        }];
    }
}

+ (void)addPushNotification
{
    if([[UIDevice currentDevice] iOSVersionIsAtLeast:@"8.0"])
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
        //        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

+ (void)readAllNotifications
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"readNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)numberOfUnReadNotifications:(NSUInteger)numNotif
{
    NSNumber *readNotif = [[NSUserDefaults standardUserDefaults] objectForKey:@"readNotification"];
    
    if (numNotif != 0)
    {
        //        if (readNotif == nil) {
        
        //            readNotif = [NSNumber numberWithInteger:numNotif];
        //            NSLog(@"nill and saved %@",readNotif);
        //
        //        }else{
        readNotif = [NSNumber numberWithInteger:[readNotif integerValue]+numNotif];
        //        }
        
        NSLog(@"saved %ld",(long)[readNotif integerValue]);
        [[NSUserDefaults standardUserDefaults] setObject:readNotif forKey:@"readNotification"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return [readNotif integerValue];
}

+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

+ (void)logout
{
    if(sharedUser != nil)
    {
        [BFAPI logoutWithUsername:[BFMyUser sharedUser].username withCompletionHandler:^(NSError *error, id result)
        {
            [sharedUser setDeviceToken:nil];
            [BFFacebookUtils clearAccessToken];
            [BFMyUser clearAllTokens];
            
            [BFMyUser readAllNotifications];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:BFMyUserDidLogoutNotification object:nil userInfo:nil];
        }];
    }
    sharedUser = nil;
}

@end
