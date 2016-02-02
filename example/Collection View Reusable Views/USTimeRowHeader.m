//
//  MSTimeRowHeader.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "USTimeRowHeader.h"

@implementation USTimeRowHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.title = [UILabel new];
        self.title.backgroundColor = [UIColor clearColor];
       CGFloat titleFontOfSize = (([[UIScreen mainScreen] scale] == 2.0) ? 11.0 : 13.0);
        self.title.font = [UIFont boldSystemFontOfSize:titleFontOfSize];
        [self.title setTextColor:[UIColor colorWithHexString:@"aaaaaa"]];
        [self.title setTextAlignment: NSTextAlignmentRight];
        [self addSubview:self.title];
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right.equalTo(self.right).offset(-5.0);
        }];
    }
    return self;
}

#pragma mark - MSTimeRowHeader

- (void)setTime:(NSDate *)time
{
    _time = time;
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    }
    
    NSCalendar *gregorianCalender = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorianCalender components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:time];
    if(comp.minute == 0){
        dateFormatter.dateFormat = @"H:mm";
    }else{
        dateFormatter.dateFormat = @":mm";
    }
    NSString *text = [dateFormatter stringFromDate:time];
    [self.title setTextColor:[UIColor colorWithHexString:@"aaaaaa"]];
    self.title.text = text;
    [self setNeedsLayout];
}

@end
