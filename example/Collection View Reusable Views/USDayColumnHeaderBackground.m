//
//  MSDayColumnHeaderBackground.m
//  Example
//
//  Created by Eric Horacek on 2/28/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "USDayColumnHeaderBackground.h"

@implementation USDayColumnHeaderBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //头部标题的颜色
//        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        self.backgroundColor = [UIColor greenColor];
        [self.layer setBorderColor:[UIColor redColor].CGColor];
        [self.layer setBorderWidth:1.0f];
    }
    return self;
}

@end
