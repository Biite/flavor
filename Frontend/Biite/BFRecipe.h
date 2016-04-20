//
//  BFRecipe.h
//  Biite
//
//  Created by JRRJ on 3/26/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BFUser.h"


@interface BFRecipe : NSObject

@property (strong, nonatomic) NSString *recipeName;
@property (strong, nonatomic) NSString *ingredients;
@property (strong, nonatomic) NSString *portionSize;
@property (strong, nonatomic) NSString *prepareTime;
@property (strong, nonatomic) NSString *orderMode;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *privacyTerms;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *imageWidth;
@property (strong, nonatomic) NSString *imageHeight;
@property (strong, nonatomic) UIImage *image;

@property (nonatomic) BOOL wantsNewImage;

@property (strong, nonatomic) BFUser *owner;

+ (BFRecipe *)recipeWithDictionary:(NSDictionary *)recipeDict;
- (instancetype)initWithDictionary:(NSDictionary *)recipeDict;
- (void)configureWithDictionary:(NSDictionary *)recipeDict;

@end
