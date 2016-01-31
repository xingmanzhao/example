//
//  UILabel+Content.h
//  HomeNetApp
//
//  Created by zhaoxingman on 15/10/26.
//  Copyright © 2015年 HomeNetGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,VerticalAlignment) {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};


@interface UILabel(Content)

/*说明：获取指定字符串的宽度
 *描述：待续
 *参数：
 *  1.text:字符串
 *  2.font:指定字体
 *返回：宽度
 */
+(CGFloat)contentWidthWithText:(NSString*)text withFont:(UIFont*)font;

/*说明：获取指定字符串的高度
 *描述：待续
 *参数：
 *  1.text:字符串
 *  2.font:指定字体
 *返回：高度
 */
+(CGFloat)contentHeightWithText:(NSString*)text withFont:(UIFont*)font;

/*说明：获取指定字符串的高度
 *描述：待续
 *参数：
 *  1.text:字符串
 *  2.font:指定字体
 *  2.width:字符串宽度
 *返回：高度
 */
+(CGFloat)contentHeightWithText:(NSString *)text withFont:(UIFont*)font withWidth:(CGFloat)width;



/*说明：获取指定属性字符串的宽度
 *描述：待续
 *参数：
 *  1.text:带属性字符串
 *返回：宽度
 */
+(CGFloat)contentWidthWithAttributedText:(NSAttributedString *)text;

/*说明：获取指定属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带属性字符串
 *返回：高度
 */
+(CGFloat)contentHeightWithAttributedText:(NSAttributedString *)text;

/*说明：获取指定属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带属性字符串
 *  2.width:字符串宽度
 *返回：高度
 */
+(CGFloat)contentHeightWithAttributedText:(NSAttributedString *)text withWidth:(CGFloat)width;




/*说明：获取指定可变属性字符串的宽度
 *描述：待续
 *参数：
 *  1.text:带可变属性字符串
 *返回：宽度
 */
+(CGFloat)contentWidthWithMutableAttributedText:(NSMutableAttributedString *)text;

/*说明：获取指定可变属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带可变属性字符串
 *返回：高度
 */
+(CGFloat)contentHeightWithMutableAttributedText:(NSMutableAttributedString *)text;

/*说明：获取指定可变属性字符串的高度
 *描述：待续
 *参数：
 *  1.text:带可变属性字符串
 *  2.width:字符串宽度
 *返回：高度
 */
+(CGFloat)contentHeightWithMutableAttributedText:(NSMutableAttributedString *)text withWidth:(CGFloat)width;
@end
