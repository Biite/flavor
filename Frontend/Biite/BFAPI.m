//
//  BFAPI.m
//  Biite
//
//  Created by JRRJ on 3/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFAPI.h"
#import "BFMyUser.h"
#import "BFFacebookUtils.h"
#import <CommonCrypto/CommonHMAC.h>
#import <AFNetworking/AFNetworking.h>


NSString* const BFNetworkErrorStatusCodeKey = @"BFNetworkErrorStatusCodeKey";
NSString* const BFNetworkErrorDomain        = @"BFNetworkErrorDomain";
NSString* const BFNetworkErrorMessageKey    = @"BFNetworkErrorMessageKey";
NSString* const kBackendVersion             = @"v1.0";

static const BOOL DEVEL_SERVER = YES;


@implementation BFAPI

+ (NSURL *)serverURL
{
    if(!DEVEL_SERVER)
    {
        return [NSURL URLWithString:[NSString stringWithFormat:@"https://biite.herokuapp.com:443/%@", kBackendVersion]];
    }
    else
    {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5000/%@", kBackendVersion]];
    }
}

+ (NSURL *)serverURLWithPath:(NSString*)path
{
    if(!DEVEL_SERVER)
    {
        return [NSURL URLWithString:[NSString stringWithFormat:@"https://biite.herokuapp.com:443/%@/%@", kBackendVersion, path]];
    }
    else
    {
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5000/%@/%@", kBackendVersion, path]];
    }
}

#pragma mark - Param Check

/**
 A function that check if any param is nil
 @param1 the first param
 @param2 the second number
 ...
 @returns bool value for check result
 */
+ (BOOL)checkStringParamsNil:(NSString*)param1, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, param1);
    for (NSString *arg = param1; arg != nil; arg = va_arg(args, NSString*))
    {
        if (!arg || arg.length < 1)
        {
            return NO;
        }
    }
    va_end(args);
    
    return YES;
}

//+ (BOOL)isConnectedInternet
//{
//    if (![[AppData appData] wifiAvaiable])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:@"No internet connection! Please check your wifi or cell signal and try again."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        
//        [alert show];
//        
//        return false;
//    }
//    
//    return true;
//}


#pragma mark - Authentication

+ (void)signupWithUsername:(NSString *)username
                     email:(NSString *)email
                  password:(NSString *)password
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                    gender:(NSString *)gender
                 biography:(NSString *)biography
           profileImageURL:(NSString *)profileImageURL
             coverImageURL:(NSString *)coverImageURL
     withCompletionHandler:(void (^)(NSError * error, id result))completionHandler
{
//    if (![BFAPI isConnectedInternet])
//    {
//        completionHandler([[NSError alloc] initWithDomain:@"" code:NETWORK_NO_INTERNET userInfo:nil], nil);
//        return;
//    }
//    if (![BFAPI checkStringParamsNil:username, email, password, firstName, lastName, gender, biography, profileImageURL, coverImageURL, nil])
//    {
//        completionHandler([[NSError alloc] initWithDomain:@"" code:BFNETWORK_GENERIC_ERROR_CODE userInfo:nil], nil);
//        return;
//    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"username"] = username;
    userInfo[@"email"] = email;
    userInfo[@"password"] = password;
    userInfo[@"firstName"] = firstName;
    userInfo[@"lastName"] = lastName;
    userInfo[@"gender"] = gender;
    userInfo[@"biography"] = biography;
    userInfo[@"profileImageURL"] = profileImageURL;
    userInfo[@"coverImageURL"] = coverImageURL;
    
    [self postToRoute:@"user/signup" withParams:nil withJSONObject:userInfo withCompletionHandler:^(NSError *error, id result)
    {
        completionHandler(error, result);
    }];
}

+ (void)emailValidation:(NSString *)email withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    [self getRoute:@"emailvalidation" withParams:@{@"email":email} withJSONResultHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)userValidation:(NSString *)username withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    [self getRoute:@"uservalidation" withParams:@{@"username":username} withJSONResultHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSDictionary *loginInfo = @{@"username":username, @"password":password};
    
    NSLog(@"LOGIN INFO %@",loginInfo);
    
    [self postToRoute:@"user/usernamelogin" withParams:nil withJSONObject:loginInfo withCompletionHandler:^(NSError * error, id result)
    {
        completionHandler(error, result);
    }];
}

+ (void)loginWithFB:(id)accessToken withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    [self postToRoute:@"user/facebooklogin" withParams:nil withJSONObject:accessToken withCompletionHandler:^(NSError *error, id result)
    {
        completionHandler(error, result);
    }];
}

+ (void)linkFacebook:(NSString *)extID withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSMutableDictionary *dict = [[BFMyUser universalTokenInfo] mutableCopy];
    dict[@"extId"] = extID;
    dict[@"fbToken"] = [FBSDKAccessToken currentAccessToken].tokenString;
    
    [self postToRoute:@"user/linkfacebook" withParams:nil withJSONObject:dict withCompletionHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)logoutWithUsername:(NSString *)username withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    [self postToRoute:@"user/usernamelogout" withParams:nil withJSONObject:[BFMyUser universalTokenInfo] withCompletionHandler:^(NSError * error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)forgotPasswordWithEmail:(NSString*)email withCompletionHandler:(void (^)(NSError *))completionHandler
{
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self postToRoute:@"user/forgot" withParams:nil withJSONObject:@{@"email":email} withCompletionHandler:^(NSError *error, id result)
    {
         completionHandler(error);
    }];
}

+ (void)getRefreshUserWithCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    [self postToRoute:@"user/" withParams:nil withJSONObject:[BFMyUser universalTokenInfo] withCompletionHandler:^(NSError *error, id result)
    {
        completionHandler(error, result);
    }];
}

+ (void)getUserInfo:(NSString *)userID withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    [self getRoute:[NSString stringWithFormat:@"user/%@", userID] withParams:[BFFacebookUtils accessTokenInfo] withJSONResultHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)setDeviceToken:(NSString *)deviceToken withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSMutableDictionary* dataDict = [[BFMyUser universalTokenInfo] mutableCopy];
    
    if(!dataDict) return;
    if(!deviceToken) deviceToken = (NSString*)[NSNull null];
    
    dataDict[@"deviceToken"] = deviceToken;
    dataDict[@"deviceType"] = @"iOS";
    
    [self postToRoute:@"user/nofitifcations" withParams:nil withJSONObject:dataDict withCompletionHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)getFavoriteUsersWithCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSMutableDictionary *dict = [[BFMyUser universalTokenInfo] mutableCopy];
    
    [self postToRoute:@"user/getfavorites" withParams:nil withJSONObject:dict withCompletionHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)addFavoriteUser:(NSString *)userID withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSMutableDictionary *dict = [[BFMyUser universalTokenInfo] mutableCopy];
    dict[@"favoriteID"] = userID;
    
    [self postToRoute:@"user/addfavorite" withParams:nil withJSONObject:dict withCompletionHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)delFavoriteUser:(NSString *)userID withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSMutableDictionary *dict = [[BFMyUser universalTokenInfo] mutableCopy];
    dict[@"favoriteID"] = userID;
    
    [self postToRoute:@"user/delfavorite" withParams:nil withJSONObject:dict withCompletionHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)postNewRecipe:(NSString *)recipeName
          ingredients:(NSString *)ingredients
          portionSize:(NSString *)portionSize
             prepTime:(NSString *)prepTime
            orderMode:(NSString *)orderMode
                price:(NSString *)price
         privacyTerms:(NSString *)privacyTerms
             imageURL:(NSString *)imageURL
           imageWidth:(NSString *)imageWidth
          imageHeight:(NSString *)imageHeight
withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSMutableDictionary *dict = [[BFMyUser universalTokenInfo] mutableCopy];
    dict[@"recipeName"] = recipeName;
    dict[@"ingredients"] = ingredients;
    dict[@"portionSize"] = portionSize;
    dict[@"prepareTime"] = prepTime;
    dict[@"orderMode"] = orderMode;
    dict[@"price"] = price;
    dict[@"privacyTerms"] = privacyTerms;
    dict[@"imageURL"] = imageURL;
    dict[@"imageWidth"] = imageWidth;
    dict[@"imageHeight"] = imageHeight;
    
    [self postToRoute:@"post/createnewrecipe" withParams:nil withJSONObject:dict withCompletionHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)getAllRecipesWithCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    [self postToRoute:@"post/getallrecipes" withParams:nil withJSONObject:[BFMyUser universalTokenInfo] withCompletionHandler:^(NSError *error, id result)
     {
         completionHandler(error, result);
     }];
}

+ (void)getSellerRecipes:(NSString *)userID withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    NSMutableDictionary *dict = [[BFMyUser universalTokenInfo] mutableCopy];
    dict[@"userID"] = userID;
    
    [self postToRoute:@"post/getrecipesbyuser" withParams:nil withJSONObject:dict withCompletionHandler:^(NSError *error, id result)
    {
        completionHandler(error, result);
    }];
}











+ (NSString*)routeString:(NSString*)route withParams:(NSDictionary*)params
{    
    NSMutableString* routeMutable = [route mutableCopy];
    [routeMutable appendString:@"?"];
    BOOL first = true;
    for(NSString* param in params)
    {
        if(!first)
        {
            [routeMutable appendString:@"&"];
        }
        [routeMutable appendString:param];
        [routeMutable appendString:@"="];
        [routeMutable appendString:[[params objectForKey:param] description]];
        first = false;
    }
    return routeMutable;
}

+ (void)getRoute:(NSString *)route withDataHandler:(void (^)(NSError *, NSData *))dataHandler withMethod:(NSString*)method forceRefresh:(BOOL)refresh
{
    NSURL* serverURL = [BFAPI serverURLWithPath:route];
    NSLog(@"Biite URL: %@",serverURL);
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:serverURL];
    if(refresh)
    {
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    request.HTTPMethod = method;
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:[BFAPI processNSDataWithCompletionHandler:dataHandler]];
    [task resume];
}

+ (void)getRoute:(NSString *)route withDataHandler:(void (^)(NSError *, NSData *))dataHandler withMethod:(NSString*)method
{
    [self getRoute:route withDataHandler:dataHandler withMethod:method forceRefresh:NO];
}

+ (void)getRoute:(NSString *)route withDataHandler:(void (^)(NSError *, NSData *))dataHandler
{
    [self getRoute:route withDataHandler:dataHandler withMethod:@"GET"];
}

+ (void)getRoute:(NSString *)route withDataHandler:(void (^)(NSError *, NSData *))dataHandler forceRefresh:(BOOL)refresh
{
    [self getRoute:route withDataHandler:dataHandler withMethod:@"GET" forceRefresh:refresh];
}

+ (void)getRoute:(NSString*)route withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler
{
    [BFAPI getRoute:route withDataHandler:[BFAPI processJSONWithCompletionHandler:resultHandler]];
}

+ (void)getRoute:(NSString*)route withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler forceRefresh:(BOOL)refresh
{
    [BFAPI getRoute:route withDataHandler:[BFAPI processJSONWithCompletionHandler:resultHandler] forceRefresh:refresh];
}

+ (void)getRoute:(NSString*)route withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler withMethod:(NSString*)method
{
    [BFAPI getRoute:route withDataHandler:[BFAPI processJSONWithCompletionHandler:resultHandler] withMethod:method];
}

+ (void)getRoute:(NSString*)route withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler withMethod:(NSString*)method forceRefresh:(BOOL)refresh
{
    [BFAPI getRoute:route withDataHandler:[BFAPI processJSONWithCompletionHandler:resultHandler] withMethod:method forceRefresh:refresh];
}

+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withDataHandler:(void (^)(NSError* error, NSData* data))dataHandler withMethod:(NSString*)method
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withDataHandler:dataHandler withMethod:method];
}

+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withDataHandler:(void (^)(NSError* error, NSData* data))dataHandler withMethod:(NSString*)method forceRefresh:(BOOL)refresh
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withDataHandler:dataHandler withMethod:method forceRefresh:refresh];
}

+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withDataHandler:(void (^)(NSError* error, NSData* data))dataHandler
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withDataHandler:dataHandler];
}

+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withDataHandler:(void (^)(NSError* error, NSData* data))dataHandler forceRefresh:(BOOL)refresh
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withDataHandler:dataHandler forceRefresh:refresh];
}


+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withJSONResultHandler:resultHandler];
}

+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler forceRefresh:(BOOL)refresh
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withJSONResultHandler:resultHandler forceRefresh:refresh];
}

+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler withMethod:(NSString*)method
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withJSONResultHandler:resultHandler withMethod:method];
}

+ (void)getRoute:(NSString*)route withParams:(NSDictionary*)params withJSONResultHandler:(void (^)(NSError* error, id result))resultHandler withMethod:(NSString*)method forceRefresh:(BOOL)refresh
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI getRoute:newRouteString withJSONResultHandler:resultHandler withMethod:method forceRefresh:refresh];
}

+ (void)postToRoute:(NSString*)route withData:(NSData*)data withCompletionHandler:(void (^)(NSError* error, NSData* data))completionHandler
{
    NSURL* serverURL = [BFAPI serverURLWithPath:route];
    NSLog(@"request: %@",serverURL);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:serverURL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:[BFAPI processNSDataWithCompletionHandler:completionHandler]];
    [task resume];
}

+ (void)postToRoute:(NSString*)route withParams:(NSDictionary*)params withData:(NSData*)data withCompletionHandler:(void (^)(NSError* error, NSData* data))completionHandler
{
    NSString* newRouteString = [BFAPI routeString:route withParams:params];
    [BFAPI postToRoute:newRouteString withData:data withCompletionHandler:completionHandler];
}

+ (void)postToRoute:(NSString *)route withParams:(NSDictionary*)params withJSONObject:(id)json withCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    if(!json)
    {
        [BFAPI postToRoute:route withParams:params withData:nil withCompletionHandler:[BFAPI processJSONWithCompletionHandler:completionHandler]];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError* JSONError = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&JSONError];
        
        if(JSONError)
        {
            if(completionHandler)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(JSONError, nil);
                });
            }
        }
        else
        {
            NSURL* serverURL = [BFAPI serverURLWithPath:route];
            
            NSLog(@"request: %@",serverURL);
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:serverURL];
            request.HTTPMethod = @"POST";
            request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
            request.HTTPBody = jsonData;
            NSURLSession* session = [NSURLSession sharedSession];
            NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:[BFAPI processNSDataWithCompletionHandler:[BFAPI processJSONWithCompletionHandler:completionHandler]]];
            [task resume];
        }
    });
}

+ (void (^)(NSError *error, NSData *data))processJSONWithCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    return ^(NSError *error, NSData *data)
    {
        if(!data)
        {
            if(completionHandler)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(error, nil);
                });
            }
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSError* JSONError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
            
            //Json output here
            if(!error && JSONError)
            {
                if(completionHandler)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(JSONError, result);
                    });
                }
            }
            else
            {
                if(completionHandler)
                {
                    NSError* parsedError = nil;
                    if(error)
                    {
                        NSMutableDictionary* userDict = [error.userInfo mutableCopy];
                        NSUInteger statusCode = 0;
                        if(result[@"statusCode"])
                        {
                            statusCode = [result[@"statusCode"] unsignedIntegerValue];
                            if(statusCode != BFNETWORK_SUCCESS_CODE)
                            {
                                statusCode+=1000;
                            }
                        }
                        if(!statusCode)
                        {
                            statusCode = error.code;
                        }
                        
                        if(result[@"result"][@"error"])
                        {
                            userDict[BFNetworkErrorMessageKey] = result[@"result"][@"error"];
                        }
                        
                        userDict[BFNetworkErrorStatusCodeKey] = [NSNumber numberWithUnsignedInteger:statusCode];
                        parsedError = [NSError errorWithDomain:BFNetworkErrorDomain code:statusCode userInfo:userDict];
                    }
                    else
                    {
                        parsedError = error;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"GET MAIN QUEUE");
                        completionHandler(parsedError, result);
                    });
                }
            }
        });
    };
}

+ (void)customQueryMYSQLsql:(NSString*)sql completionHandler:(void (^)(NSError *error, NSArray *jsonArray))completionHandler
{
    NSString *post = [NSString stringWithFormat:@"sql=%@",sql];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.pixelandprocessor.com/venturecity/query.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
    {
        if (!error)
        {
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:NSJSONReadingAllowFragments error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil,jsonArray);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(error,nil);
            });
        }
    }];
    [task resume];
}

+ (void (^)(NSData *data, NSURLResponse *response, NSError *error))processNSDataWithCompletionHandler:(void (^)(NSError *, id))completionHandler
{
    return ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(error)
        {
            if(completionHandler)
            {
                completionHandler(error, data);
            }
            return;
        }
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        if(statusCode != 200)
        {
            NSError* error = [NSError errorWithDomain:BFNetworkErrorDomain code:statusCode userInfo:@{BFNetworkErrorStatusCodeKey: [NSNumber numberWithInteger:statusCode]}];
            if(completionHandler)
            {
                completionHandler(error, data);
            }
            return;
        }
        if(completionHandler)
        {
            completionHandler(nil, data);
        }
    };
}

@end
