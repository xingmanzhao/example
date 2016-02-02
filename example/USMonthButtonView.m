//
//  USMonthButtonView.m
//  example
//
//  Created by 赵兴满 on 16/2/1.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "USMonthButtonView.h"

@interface USMonthButtonView()
{
    UILabel *yearLabel;
    UILabel *monthLabel;
}
@end

@implementation USMonthButtonView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIEdgeInsets contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        CGFloat yearLabelMinY = contentEdgeInsets.top;
        CGFloat yearLabelHeight = (CGRectGetHeight(frame) - contentEdgeInsets.top - contentEdgeInsets.bottom) / 2.0;
        yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yearLabelMinY, CGRectGetWidth(frame), yearLabelHeight)];
        
        [yearLabel setText:@""];
        CGFloat yearFontOfSize = (([[UIScreen mainScreen] scale] == 2.0) ? 10.0 : 12.0);
        [yearLabel setFont:[UIFont systemFontOfSize:yearFontOfSize]];
        [yearLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:yearLabel];
        
        monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(yearLabel.frame), CGRectGetMaxY(yearLabel.frame), CGRectGetWidth(yearLabel.frame), CGRectGetHeight(yearLabel.frame))];
        [monthLabel setText:@""];
        CGFloat monthFontOfSize = (([[UIScreen mainScreen] scale] == 2.0) ? 20.0 : 24.0);
        [monthLabel setFont:[UIFont systemFontOfSize:monthFontOfSize]];
        [monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:monthLabel];
        
        CGFloat borderWidth = ([[UIScreen mainScreen] scale] == 2.0 ? 0.25 : 0.5);
        [self.layer setBorderColor:[[UIColor colorWithHexString:@"939393"] colorWithAlphaComponent:0.8f].CGColor];
        [self.layer setBorderWidth:borderWidth];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withIcon:(UIImage*)icon{
    self = [super initWithFrame:frame];
    if(self){
        UIEdgeInsets contentEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        
        CGFloat labelWidth = CGRectGetWidth(frame);
        CGFloat yearLabelMinY = contentEdgeInsets.top;
        CGFloat yearLabelHeight =  (CGRectGetHeight(frame) - contentEdgeInsets.top - contentEdgeInsets.bottom) / 4.0;
        CGFloat monthLabelHeight =  (CGRectGetHeight(frame) - contentEdgeInsets.top - contentEdgeInsets.bottom) / 2.0;
        
        yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yearLabelMinY, labelWidth, yearLabelHeight)];
        [yearLabel setText:@""];
        CGFloat yearFontOfSize = (([[UIScreen mainScreen] scale] == 2.0) ? 10.0 : 12.0);
        [yearLabel setFont:[UIFont systemFontOfSize:yearFontOfSize]];
        [yearLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:yearLabel];
        
        monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yearLabel.frame), labelWidth, monthLabelHeight)];
        [monthLabel setText:@""];
        CGFloat monthFontOfSize = (([[UIScreen mainScreen] scale] == 2.0) ? 20.0 : 24.0);
        [monthLabel setFont:[UIFont systemFontOfSize:monthFontOfSize]];
        [monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:monthLabel];
        
        CGFloat iconWidth = 20 / 2;
        CGFloat iconHeight = 12 / 2;
        CGFloat iconMinX = (labelWidth - iconWidth) / 2;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconMinX, CGRectGetMaxY(monthLabel.frame), iconWidth, iconHeight)];
        if(icon){
            [imageView setImage:icon];
        }
        [self addSubview:imageView];

    }
    return self;
}

-(void)setShowMonthDate:(NSDate *)showMonthDate{
    _showMonthDate = showMonthDate;
    if(_showMonthDate){
        [yearLabel setText:[NSString stringWithFormat:@"%d",_showMonthDate.year]];
        [monthLabel setText:[NSString stringWithFormat:@"%d",_showMonthDate.month]];
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.backgroundColor = [self backgroundHighlightColor];
//    self.backgroundColor = [[self backgroundHighlightColor] colorWithAlphaComponent:0.8];
    [yearLabel setTextColor:[self foregroundHightColor]];
    [monthLabel setTextColor:[self foregroundHightColor]];
    [self setNeedsDisplay];
}

-(UIColor*)backgroundHighlightColor{
    return self.isSelected ? [UIColor colorWithHexString:@"e9466b"] : [UIColor whiteColor];
}

-(UIColor*)foregroundHightColor{
    return self.isSelected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"5f6060"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
