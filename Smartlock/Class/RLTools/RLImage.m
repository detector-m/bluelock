//
//  RLImage.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLImage.h"

@implementation RLImage
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        return img;
        
    }
}

+ (UIImage *)scaleImage:(UIImage *)originalImage toScale:(CGFloat)ratio {
    if(!originalImage) {
        return nil;
    }
    if(!ratio) {
        return originalImage;
    }
    
    ratio = fabsf(ratio);
    
    CGSize oriImgSize = originalImage.size;
    CGSize contextSize = CGSizeMake(oriImgSize.width*ratio, oriImgSize.height*ratio);
    UIGraphicsBeginImageContext(contextSize);
    [originalImage drawInRect:CGRectMake(0, 0, contextSize.width, contextSize.height)];
    UIImage *subImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return subImg;
}

+ (UIImage *)resizeImage:(UIImage *)originalImage size:(CGSize)size {
    if(originalImage == nil) {
        return nil;
    }
    if(CGSizeEqualToSize(size, CGSizeZero)) {
        return originalImage;
    }
    
    size = CGSizeMake(fabsf(size.width), fabsf(size.height));
    
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *subImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return subImg;
}

+ (UIImage *)captureView:(UIView *)view {
    if(view == nil)
        return nil;
    
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)cropImage:(UIImage *)originalImage rect:(CGRect)rect {
    if(originalImage == nil)
        return nil;
    if(CGRectIsEmpty(rect))
        return originalImage;
    
    CGImageRef imageRef = originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    CGSize size = rect.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);
    UIImage *subImg = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    
    return subImg;
    
}

- (UIImage *)iconImage:(UIImage *)oriImage {
    if(oriImage == nil)
        return nil;
    CGFloat cellHeight = 70;
    CGSize iconSize = CGSizeMake(cellHeight-10,cellHeight-10);
    UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0f, 0.0f, iconSize.width, iconSize.height);
    [oriImage drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
