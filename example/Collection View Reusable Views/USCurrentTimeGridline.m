//
//  MSCurrentTimeGridline.m
//  Example
//
//  Created by Eric Horacek on 2/27/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "USCurrentTimeGridline.h"

@implementation USCurrentTimeGridline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"fd3935"];
//        [self.layer setBorderColor:[UIColor blueColor].CGColor];
//        [self.layer setBorderWidth:1.0f];
    }
    return self;
}

@end
