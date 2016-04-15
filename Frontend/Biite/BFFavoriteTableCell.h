//
//  BFFavoriteTableCell.h
//  Biite
//
//  Created by JRRJ on 4/14/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFFavoriteTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *sellerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sellerCategoryImageView;
@property (strong, nonatomic) IBOutlet UILabel *sellerCategoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *sellerDisplayName;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) IBOutlet UIButton *deleteFavoriteButton;

@end
