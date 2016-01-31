//
//  UILabel+Content.m
//  HomeNetApp
//
//  Created by zhaoxingman on 15/10/26.
//  Copyright © 2015年 HomeNetGroup. All rights reserved.
//

#import "UILabel+Content.h"


@implementation UILabel(Content)

/*说明：获取指定字符串的宽度
 *描述：待续
 *参数：
 *  1.text:字符串
 *  2.font:指定字体
 *返回：宽度
 */
+(CGFloat)contentWidthWithText:(NSString *)text withFont:(UIFont*)font{
    CGFloat width = 0;
    if([text isKindOfClass:[NSString class]] == YES && font != nil){
        CGSize size = CGSizeMake(kScreenWidth, kScreenHeight);
        if(IS_IOS_7_0){
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
            size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        }else{
            size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        }
        width = size.width + 1;
    }
    return width;
}

/*说明：获取指定字符串的高度
 *描述：待续
 *参数：
 *  1.text:字符串
 *  2.font:指定字体
 *返回：高度
 */
+(CGFloat)contentHeightWithText:(NSString *)text withFont:(UIFont*)font{
    CGFloat height = 0;
    if([text isKindOfClass:[NSString class]] == YES && font != nil){
        CGSize size = CGSizeMake(kScreenWidth, kScreenHeight);
        if(IS_IOS_7_0){
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
            size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        }else{
            size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        }
        
        height = size.height + 1;
    }
    return height;
}

/*说明：获取指定字符串的高度
 *描述：待续
 *参数：
 *  1.text:字符串
 *  2.font:指定字体
 *  2.width:字符串宽度
 *返回：高度
 */
+(CGFloat)contentHeightWithText:(NSString *)text withFont:(UIFont*)font withWidth:(CGFloat)width{
    CGFloat height = 0;
    if([text isKindOfClass:[NSString class]] == YES && font != nil && width > 0){
        CGSize size = CGSizeMake(width, kScreenHeight);
        if(IS_IOS_7_0){
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
            size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        }else{
            size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        }
        
        height = size.height + 1;
    }
    return height;
}






/*说明：获取指定属性字符串的宽度
 *描述：待续
 *参数：
 *  1.text:带属性字符串
 *返回：宽度
 */
+(CGFloat)contentWidthWithAttributedText:(NSAttributedString *)text{
    CGFloat width = 0;
    if([text isKindOfClass:[NSAttributedString class]] == YES){
        CGSize size = CGSizeMake(kScreenWidth, kScreenHeight);
        size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        width = size.width + 1;
    }
    return width;
}

/*说明：获取指定属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带属性字符串
 *返回：高度
 */
+(CGFloat)contentHeightWithAttributedText:(NSAttributedString *)text{
    CGFloat height = 0;
    if([text isKindOfClass:[NSAttributedString class]] == YES){
        CGSize size = CGSizeMake(kScreenWidth, kScreenHeight);
        size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        height = size.height + 1;
    }
    return height;
}

/*说明：获取指定属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带属性字符串
 *  2.width:字符串宽度
 *返回：高度
 */
+(CGFloat)contentHeightWithAttributedText:(NSAttributedString *)text withWidth:(CGFloat)width{
    CGFloat height = 0;
    if([text isKindOfClass:[NSAttributedString class]] == YES && width > 0){
        CGSize size = CGSizeMake(width, kScreenHeight);
        size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        height = size.height + 1;
    }
    return height;
}




/*说明：获取指定可变属性字符串的宽度
 *描述：待续
 *参数：
 *  1.text:带可变属性字符串
 *返回：宽度
 */
+(CGFloat)contentWidthWithMutableAttributedText:(NSMutableAttributedString *)text{
    CGFloat width = 0;
    if([text isKindOfClass:[NSMutableAttributedString class]] == YES){
        CGSize size = CGSizeMake(kScreenWidth, kScreenHeight);
        size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        width = size.width + 1;
    }
    return width;
}

/*说明：获取指定可变属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带可变属性字符串
 *返回：高度
 */
+(CGFloat)contentHeightWithMutableAttributedText:(NSMutableAttributedString *)text{
    CGFloat height;
    if([text isKindOfClass:[NSMutableAttributedString class]] == YES){
        CGSize size = CGSizeMake(kScreenWidth, kScreenHeight);
        size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        height = size.height + 1;
    }
    return height;
}

/*说明：获取指定可变属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带可变属性字符串
 *  2.width:字符串宽度
 *返回：高度
 */
+(CGFloat)contentHeightWithMutableAttributedText:(NSMutableAttributedString *)text withWidth:(CGFloat)width{
    CGFloat height;
    if([text isKindOfClass:[NSMutableAttributedString class]] == YES && width > 0){
        CGSize size = CGSizeMake(width, MAXFLOAT);
        size = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        height = size.height + 1;
    }
    return height;
}



@end
