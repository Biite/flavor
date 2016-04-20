//
//  BFRecipe.m
//  Biite
//
//  Created by JRRJ on 3/26/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipe.h"
#import <SDWebImage/SDWebImageManager.h>


@implementation BFRecipe

+ (BFRecipe *)recipeWithDictionary:(NSDictionary *)recipeDict
{
    if(!recipeDict || ![recipeDict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    return [[BFRecipe alloc] initWithDictionary:recipeDict];
}

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
    
    self.recipeName = recipeDict[@"recipeName"];
    self.ingredients = recipeDict[@"ingredients"];
    self.portionSize = recipeDict[@"portionSize"];
    self.prepareTime = recipeDict[@"prepareTime"];
    self.orderMode = recipeDict[@"orderMode"];
    self.price = recipeDict[@"price"];
    self.privacyTerms = recipeDict[@"privacyTerms"];
    self.imageURL = recipeDict[@"imageURL"][@"url"];
    self.imageWidth = recipeDict[@"imageURL"][@"width"];
    self.imageHeight = recipeDict[@"imageURL"][@"height"];
    
    self.owner = [BFUser userWithDictionary:recipeDict[@"owner"]];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageURL]
                                                    options:(self.wantsNewImage ? SDWebImageRefreshCached :0)
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if(!error)
         {
             self.image = image;
             self.wantsNewImage=NO;
         }
     }];
}

@end
