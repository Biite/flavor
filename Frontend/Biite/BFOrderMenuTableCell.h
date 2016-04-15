//
//  BFOrderMenuTableCell.h
//  Biite
//
//  Created by JRRJ on 3/27/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BFOrderMenuTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *recipeName;
@property (strong, nonatomic) IBOutlet UILabel *seller;
@property (strong, nonatomic) IBOutlet UILabel *servesCount;
@property (strong, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (strong, nonatomic) IBOutlet UILabel *qtyLabel;
@property (strong, nonatomic) IBOutlet UIImageView *orderModeImageView;
@property (strong, nonatomic) IBOutlet UIView *orderModeView;
@property (strong, nonatomic) IBOutlet UILabel *orderModeLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipePriceLabel;

@end
