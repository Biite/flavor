//
//  BFRecipesListCollectionCell.m
//  Biite
//
//  Created by JRRJ on 3/26/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFRecipesListCollectionCell.h"


@implementation BFRecipesListCollectionCell

- (void)awakeFromNib
{
    // Initialization code
    self.recipeImageView.layer.cornerRadius = 5.0;
    self.recipeImageView.layer.masksToBounds = YES;
}

@end
