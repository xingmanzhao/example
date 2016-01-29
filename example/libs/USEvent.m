//
//  MSEvent.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "USEvent.h"

@implementation USEvent

@synthesize  remoteID;
@synthesize start;
@synthesize title;
@synthesize location;
@synthesize dateToBeDecided;
@synthesize timeToBeDecided;

- (NSDate *)day
{
    return [self.start beginningOfDay];
}

@end
