//
//  BFPersonalVC.h
//  Biite
//
//  Created by JRRJ on 4/11/16.
//  Copyright © 2016 JRRJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cloudinary.h"

@interface BFPersonalVC : UIViewController <CLUploaderDelegate>

@property (nonatomic,strong) NSMutableDictionary *userInfo;

@end
