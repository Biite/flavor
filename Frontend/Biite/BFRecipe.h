//
//  BFRecipe.h
//  Biite
//
//  Created by JRRJ on 3/26/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BFRecipe : NSObject

@property (strong, nonatomic) NSString *recipeName;
@property (strong, nonatomic) NSString *recipeImageURL;
@property (strong, nonatomic) NSString *recipeContents;
@property (strong, nonatomic) NSString *recipeDescription;
@property (strong, nonatomic) NSString *recipePrice;
@property (strong, nonatomic) NSString *prepareTime;

//@property (strong, nonatomic) BFSeller *recipeSeller;

- (instancetype)initWithDictionary:(NSDictionary *)recipeDict;
- (void)configureWithDictionary:(NSDictionary *)recipeDict;

@end
