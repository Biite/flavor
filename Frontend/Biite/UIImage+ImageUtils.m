//
//  UIImage+ImageUtils.m
//  Movett
//
//  Created by Jarrett Chen on 10/14/15.
//  Copyright © 2015 Movett. All rights reserved.
//

#import "UIImage+ImageUtils.h"

@implementation UIImage (ImageUtils)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);
    
    [color set];
    CGContextFillRect(context, area);
    
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextDrawImage(context, area, image.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}
+ (UIImage*) imageWithImage:(UIImage *)image withColorMask:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!context) return nil;
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(context, color.CGColor); //Fill the image
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop); //Using a mask
    CGContextFillRect(context, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage*)circularImageWithImage:(UIImage *)image inRect:(CGRect)frame withBorderWidth:(CGFloat)borderWidth withBorderColor:(UIColor*)borderColor{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(borderWidth, borderWidth, imageWidth - borderWidth * 2, imageHeight - borderWidth * 2);
    [image drawInRect:myRect];
    
    [borderColor setStroke];
    CGContextSetLineWidth(context, borderWidth);
    CGRect circleRect = CGRectInset(frame, borderWidth * 0.5, borderWidth * 0.5);
    CGContextStrokeEllipseInRect(context, circleRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage*) fitImage:(UIImage*)image inBox:(CGSize)size withBackground:(UIColor*)color {
    
    if (image.size.width==size.width && image.size.height==size.height)
        return image;
    
    if (image.size.width<size.width && image.size.height<size.height)
        return [UIImage imageWithImage:image scaledToSize:size];
    
    float widthFactor = size.width / image.size.width;
    float heightFactor = size.height / image.size.height;
    
    CGSize scaledSize = size;
    if (widthFactor<heightFactor) {
        scaledSize.width = size.width;
        scaledSize.height = image.size.height * widthFactor;
    } else {
        scaledSize.width = image.size.width * heightFactor;
        scaledSize.height = size.height;
    }
    
    UIGraphicsBeginImageContextWithOptions( size, NO, 0.0 );
    
    float marginX = (size.width-scaledSize.width)/2;
    float marginY = (size.height-scaledSize.height)/2;
    CGRect scaledImageRect = CGRectMake(marginX, marginY, scaledSize.width, scaledSize.height );
    
    UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
    [color set];
    UIRectFill(CGRectMake(0.0, 0.0, temp.size.width, temp.size.height));
    [image drawInRect:scaledImageRect];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    return scaledImage;
}
@end
