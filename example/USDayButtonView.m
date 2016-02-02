//
//  USDayButtonView.m
//  example
//
//  Created by 赵兴满 on 16/2/1.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "USDayButtonView.h"
@interface USDayButtonView()
{
    UILabel *weekLabel;
    UILabel *dayLabel;
}
@end

@implementation USDayButtonView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIEdgeInsets contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        
        CGFloat labelWidth = CGRectGetWidth(frame);
        CGFloat weekLabelMinY = contentEdgeInsets.top;
        CGFloat weekLabelHeight =  (CGRectGetHeight(frame) - contentEdgeInsets.top - contentEdgeInsets.bottom) / 2.0;
        
        weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, weekLabelMinY, labelWidth, weekLabelHeight)];
        [weekLabel setText:@""];
        CGFloat weekFontOfSize = (([[UIScreen mainScreen] scale] == 2.0) ? 10.0 : 12.0);
        [weekLabel setFont:[UIFont systemFontOfSize:weekFontOfSize]];
        [weekLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:weekLabel];
        
        CGRect weekFrame = weekLabel.frame;
        dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(weekFrame), CGRectGetMaxY(weekFrame), labelWidth, CGRectGetHeight(weekFrame))];
        [dayLabel setText:@""];
        
        CGFloat dayFontOfSize = (([[UIScreen mainScreen] scale] == 2.0) ? 14.0 : 20.0);
        [dayLabel setFont:[UIFont systemFontOfSize:dayFontOfSize]];
        [dayLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:dayLabel];
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGFloat topLayerHeight = (scale == 2.0 ? 0.5f : 0.5f);
        CGRect topLayerBounds = CGRectMake(0, 0, self.bounds.size.width, topLayerHeight);
        CGPoint topLayerPosition = CGPointMake(0, 0);
        [self addBorderBounds:topLayerBounds withPosition:topLayerPosition];
        
        CGFloat bottomLayerHeight = (scale == 2.0 ? 0.5f : 0.5f);
        CGRect bottomLayerBounds = CGRectMake(0, self.bounds.size.height - 1.0, self.bounds.size.width, bottomLayerHeight);
        CGPoint bottomLayerPosition = CGPointMake(0, self.bounds.size.height - bottomLayerHeight);
        [self addBorderBounds:bottomLayerBounds withPosition:bottomLayerPosition];
        
        CGFloat leftLayerWidth = (scale == 2.0 ? 0.25f : 0.25f);
        CGRect leftLayerBounds = CGRectMake(0, 0, leftLayerWidth, self.bounds.size.height);
        CGPoint leftLayerPosition = CGPointMake(0, 0);
        [self addBorderBounds:leftLayerBounds withPosition:leftLayerPosition];
        
        CGFloat rightLayerWidth = (scale == 2.0 ? 0.25f : 0.25f);
        CGRect rightLayerBounds = CGRectMake(self.bounds.size.width - rightLayerWidth, 0, rightLayerWidth, self.bounds.size.height);
        CGPoint rightLayerPosition = CGPointMake(self.bounds.size.width - rightLayerWidth, 0);
        [self addBorderBounds:rightLayerBounds withPosition:rightLayerPosition];
    }
    return self;
}

-(void)addBorderBounds:(CGRect)bounds withPosition:(CGPoint)position{
    CALayer *border = [CALayer layer];
    [border setBackgroundColor:[[UIColor colorWithHexString:@"939393"] colorWithAlphaComponent:0.8f].CGColor];
    [border setBounds:bounds];
    [border setPosition:position];
    [border setAnchorPoint:CGPointZero];
    [self.layer addSublayer:border];
}

-(void)setShowDate:(NSDate *)showDate{
    _showDate = showDate;
    if(_showDate){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"EEE"];
        NSString *week = [formatter stringFromDate:showDate];
        
        //        [weekLabel setText:[NSString stringWithFormat:@"%d",showDate.weekday]];
        [weekLabel setText:week];
        [dayLabel setText:[NSString stringWithFormat:@"%d",showDate.day]];
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.backgroundColor = [self backgroundHighlightColor];
    [weekLabel setTextColor:[self foregroundHightColor]];
    [dayLabel setTextColor:[self foregroundHightColor]];
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
