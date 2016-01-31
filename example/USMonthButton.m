//
//  USMonthButton.m
//  example
//
//  Created by 赵兴满 on 16/1/31.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "USMonthButton.h"
@interface USMonthButton()
{
    UILabel *yearLabel;
    UILabel *monthLabel;
}
@end

@implementation USMonthButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        CGFloat yearLabelMinY = self.contentEdgeInsets.top;
        CGFloat yearLabelHeight = (CGRectGetHeight(frame) - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom) / 2.0;
        yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yearLabelMinY, CGRectGetWidth(frame), yearLabelHeight)];
        
        [yearLabel setText:@""];
        [yearLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [yearLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:yearLabel];
        
        monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(yearLabel.frame), CGRectGetMaxY(yearLabel.frame), CGRectGetWidth(yearLabel.frame), CGRectGetHeight(yearLabel.frame))];
        [monthLabel setText:@""];
        [monthLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
        [monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:monthLabel];
        
        [self.layer setBorderColor:[[UIColor colorWithHexString:@"939393"] colorWithAlphaComponent:0.8f].CGColor];
        [self.layer setBorderWidth:0.8f];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withIcon:(UIImage*)icon{
    self = [super initWithFrame:frame];
    if(self){
        self.contentEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0);
        
        CGFloat labelWidth = CGRectGetWidth(frame);
        CGFloat yearLabelMinY = self.contentEdgeInsets.top;
        CGFloat yearLabelHeight =  (CGRectGetHeight(frame) - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom) / 4.0;
        CGFloat monthLabelHeight =  (CGRectGetHeight(frame) - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom) / 2.0;
        
        yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yearLabelMinY, labelWidth, yearLabelHeight)];
        [yearLabel setText:@""];
        [yearLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [yearLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:yearLabel];
        
        monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yearLabel.frame), labelWidth, monthLabelHeight)];
        [monthLabel setText:@""];
        [monthLabel setFont:[UIFont boldSystemFontOfSize:28.0f]];
        [monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:monthLabel];
        
        CGFloat iconWidth = 20;
        CGFloat iconHeight = 13;
        CGFloat iconMinX = (labelWidth - iconWidth) / 2;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconMinX, CGRectGetMaxY(monthLabel.frame), iconWidth, iconHeight)];
        if(icon){
            [imageView setImage:icon];
        }
        [self addSubview:imageView];
        
    }
    return self;
}

-(void)setShowDate:(NSDate *)showDate{
    if(showDate){
        [yearLabel setText:[NSString stringWithFormat:@"%d",showDate.year]];
        [yearLabel setTextColor:[UIColor redColor]];
        [monthLabel setText:[NSString stringWithFormat:@"%d",showDate.month]];
        [monthLabel setTextColor:[UIColor redColor]];
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    self.backgroundColor = [self backgroundHighlightColor];
    [yearLabel setTextColor:[self foregroundHightColor]];
    [monthLabel setTextColor:[self foregroundHightColor]];
    [self setNeedsDisplay];
}

-(UIColor*)backgroundHighlightColor{
    return self.isSelected ? [[UIColor colorWithHexString:@"e9466b"] colorWithAlphaComponent:0.8] : [UIColor whiteColor];
}

-(UIColor*)foregroundHightColor{
    return self.isSelected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"383a3a"];
}

//-(void)setBackgroundColor:(UIColor *)backgroundColor{
//    [super setBackgroundColor:backgroundColor];
//    [yearLabel setBackgroundColor:backgroundColor];
//    [monthLabel setBackgroundColor:backgroundColor];
//}


@end
