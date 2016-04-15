//
//  BFRecipesListCollectionCell.h
//  Biite
//
//  Created by JRRJ on 3/26/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BFRecipesListCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *priceImageView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *recipeButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeNameLabel;

@end
