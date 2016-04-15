//
//  BFOrderMenuTableCell.m
//  Biite
//
//  Created by JRRJ on 3/27/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFOrderMenuTableCell.h"

@implementation BFOrderMenuTableCell

- (void)awakeFromNib {
    // Initialization code
    
    self.qtyLabel.layer.cornerRadius = 6.0;
    self.qtyLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.qtyLabel.layer.borderWidth = 2.0;
    
    self.orderModeView.layer.cornerRadius = 6.0;
    self.orderModeView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.orderModeView.layer.borderWidth = 2.0;
    
    self.removeButton.layer.cornerRadius = 5.0;
    self.removeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.removeButton.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
