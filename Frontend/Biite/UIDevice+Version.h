//
//  UIDevice+Version.h
//  Movett
//
//  Created by Jarrett Chen on 9/14/15.
//  Copyright (c) 2015 Movett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Version)
- (BOOL)iOSVersionIsAtLeast:(NSString*)version;

@end
