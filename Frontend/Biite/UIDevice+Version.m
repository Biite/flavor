//
//  UIDevice+Version.m
//  Movett
//
//  Created by Jarrett Chen on 9/14/15.
//  Copyright (c) 2015 Movett. All rights reserved.
//

#import "UIDevice+Version.h"

@implementation UIDevice (Version)
- (BOOL)iOSVersionIsAtLeast:(NSString*)version {
    NSComparisonResult result = [[self systemVersion] compare:version options:NSNumericSearch];
    return (result == NSOrderedDescending || result == NSOrderedSame);
}
@end
