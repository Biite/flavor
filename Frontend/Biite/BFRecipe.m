//
//  BFRecipe.m
//  Biite
//
//  Created by JRRJ on 3/26/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipe.h"


@implementation BFRecipe

- (instancetype)initWithDictionary:(NSDictionary *)recipeDict
{
    self = [super init];
    if (self)
    {
        [self configureWithDictionary:recipeDict];
    }
    
    return self;
}

- (void)configureWithDictionary:(NSDictionary *)recipeDict
{
//    NSLog(@"Recipe Dict %@", recipeDict);
    
    self.recipeName = recipeDict[@"name"];
    self.recipeImageURL = recipeDict[@"imageURL"];
    self.recipeDescription = recipeDict[@"description"];
    self.recipeContents = recipeDict[@"contents"];
    self.recipePrice = recipeDict[@"price"];
    self.prepareTime = recipeDict[@"prepareTime"];
    
//     *seller = [[BFSeller alloc] initWithDictionary:recipeDict[@"seller"]];
//    self.recipeSeller = seller;

}

@end
