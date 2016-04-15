//
//  UIImage+ImageUtils.h
//  Movett
//
//  Created by Jarrett Chen on 10/14/15.
//  Copyright © 2015 Movett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageUtils)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage*) imageWithImage:(UIImage *)image withColorMask:(UIColor *)color;
+ (UIImage*)circularImageWithImage:(UIImage *)image inRect:(CGRect)frame withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor*)borderColor;
+ (UIImage*) fitImage:(UIImage*)image inBox:(CGSize)size withBackground:(UIColor*)color;

@end
