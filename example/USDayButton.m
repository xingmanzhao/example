//
//  USDayButton.m
//  example
//
//  Created by 赵兴满 on 16/1/31.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "USDayButton.h"
@interface USDayButton()
{
    UILabel *weekLabel;
    UILabel *dayLabel;
}
@end
@implementation USDayButton

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 0);
        
        CGFloat labelWidth = CGRectGetWidth(frame);
        CGFloat weekLabelMinY = self.contentEdgeInsets.top;
        CGFloat weekLabelHeight =  (CGRectGetHeight(frame) - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom) / 2.0;
        
        weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, weekLabelMinY, labelWidth, weekLabelHeight)];
        [weekLabel setText:@""];
        [weekLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [weekLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:weekLabel];
        
        CGRect weekFrame = weekLabel.frame;
        dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(weekFrame), CGRectGetMaxY(weekFrame), labelWidth, CGRectGetHeight(weekFrame))];
        [dayLabel setText:@""];
        [dayLabel setFont:[UIFont systemFontOfSize:24.0f]];
        [dayLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:dayLabel];
        
        CGRect topLayerBounds = CGRectMake(0, 0, self.bounds.size.width, 1.0f);
        CGPoint topLayerPosition = CGPointMake(0, 0);
        [self addBorderBounds:topLayerBounds withPosition:topLayerPosition];
        
        CGRect bottomLayerBounds = CGRectMake(0, self.bounds.size.height - 1.0, self.bounds.size.width, 1.0f);
        CGPoint bottomLayerPosition = CGPointMake(0, self.bounds.size.height - 1.0);
        [self addBorderBounds:bottomLayerBounds withPosition:bottomLayerPosition];
        
        CGRect leftLayerBounds = CGRectMake(0, 0, 0.5f, self.bounds.size.height);
        CGPoint leftLayerPosition = CGPointMake(0, 0);
        [self addBorderBounds:leftLayerBounds withPosition:leftLayerPosition];
        
        CGRect rightLayerBounds = CGRectMake(self.bounds.size.width - 0.5, 0, 0.5f, self.bounds.size.height);
        CGPoint rightLayerPosition = CGPointMake(self.bounds.size.width - 0.5, 0);
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
    [border setCornerRadius:2.0f];
    [self.layer addSublayer:border];
}

-(void)setShowDate:(NSDate *)showDate{
    if(showDate){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"EEE"];
        NSString *week = [formatter stringFromDate:showDate];
        
//        [weekLabel setText:[NSString stringWithFormat:@"%d",showDate.weekday]];
        [weekLabel setText:week];
        [dayLabel setText:[NSString stringWithFormat:@"%d",showDate.day]];
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    self.backgroundColor = [self backgroundHighlightColor];
    [weekLabel setTextColor:[self foregroundHightColor]];
    [dayLabel setTextColor:[self foregroundHightColor]];
    [self setNeedsDisplay];
}

-(UIColor*)backgroundHighlightColor{
    return self.isSelected ? [[UIColor colorWithHexString:@"e9466b"] colorWithAlphaComponent:0.8] : [UIColor whiteColor];
}

-(UIColor*)foregroundHightColor{
    return self.isSelected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"383a3a"];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
