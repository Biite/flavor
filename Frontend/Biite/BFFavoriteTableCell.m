//
//  BFFavoriteTableCell.m
//  Biite
//
//  Created by JRRJ on 4/14/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import "BFFavoriteTableCell.h"

@implementation BFFavoriteTableCell

- (void)awakeFromNib {
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
