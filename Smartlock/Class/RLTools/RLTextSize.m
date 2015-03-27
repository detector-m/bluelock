//
//  RLTextSize.m
//  GlobalVillage
//
//  Created by RivenL on 15/1/17.
//  Copyright (c) 2015年 RivenL. All rights reserved.
//

#import "RLTextSize.h"

@implementation RLTextSize
+ (CGSize)textSizeWithString:(NSString *)text andFont:(UIFont *)font {
    if(text == nil || text.length == 0)
        return CGSizeZero;
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    
    return size;
}

+ (CGFloat)textHeightWithString:(NSString *)text andFont:(UIFont *)font andWidth:(CGFloat)width {
    if(text == nil || text.length == 0)
        return 0.0f;
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    
    return size.height;
}
+ (CGFloat)textWidthWithString:(NSString *)text andFont:(UIFont *)font andHeight:(CGFloat)height {
    if(text == nil || text.length == 0)
        return 0.0f;
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    
    return size.height;
}
@end
