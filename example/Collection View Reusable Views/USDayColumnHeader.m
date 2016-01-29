//
//  MSDayColumnHeader.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "USDayColumnHeader.h"

@interface USDayColumnHeader ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *titleBackground;

@end

@implementation USDayColumnHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleBackground = [UIView new];
        self.titleBackground.layer.cornerRadius = nearbyintf(15.0);
        [self addSubview:self.titleBackground];
        
        self.backgroundColor = [UIColor clearColor];
        self.title = [UILabel new];
        self.title.backgroundColor = [UIColor blueColor];
        [self.title setTextColor:[UIColor whiteColor]];
        [self addSubview:self.title];
        
        [self.titleBackground makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.title).with.insets(UIEdgeInsetsMake(-6.0, -12.0, -4.0, -12.0));
        }];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
//        [self.layer setBorderColor:[UIColor redColor].CGColor];
//        [self.layer setBorderWidth:1.0f];
    }
    return self;
}

- (void)setDay:(NSDate *)day
{
    _day = day;
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"EEE MMM d" : @"EEEE MMMM d, YYYY");
    }
    self.title.text = [dateFormatter stringFromDate:day];
    [self setNeedsLayout];
}

- (void)setCurrentDay:(BOOL)currentDay
{
    _currentDay = currentDay;
    
    if (currentDay) {
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleBackground.backgroundColor = [UIColor colorWithHexString:@"fd3935"];
    } else {
        self.title.font = [UIFont systemFontOfSize:16.0];
        self.title.textColor = [UIColor blackColor];
        self.titleBackground.backgroundColor = [UIColor clearColor];
    }
}

@end
