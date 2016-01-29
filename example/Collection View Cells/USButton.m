//
//  MSButton.m
//  Example
//
//  Created by Ricky on 14-1-4.
//  Copyright (c) 2014年 Monospace Ltd. All rights reserved.
//

#import "USButton.h"

@implementation USButton

@synthesize  remoteID;
@synthesize start;
@synthesize title;
@synthesize location;
@synthesize dateToBeDecided;
@synthesize timeToBeDecided;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
