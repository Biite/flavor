//
//  BFWalletTableCell.h
//  Biite
//
//  Created by JRRJ on 3/28/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFWalletTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *methodsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *paymentImageView;
@property (strong, nonatomic) IBOutlet UILabel *paymentMethodLabel;
@property (strong, nonatomic) IBOutlet UIImageView *paymentMethodCheckImageView;
@property (strong, nonatomic) IBOutlet UIImageView *methodSelectImageView;

@property (strong, nonatomic) IBOutlet UILabel *addMethodLabel;

@end
