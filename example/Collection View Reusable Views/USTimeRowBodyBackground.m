//
//  USTimeRowBodyBackground.m
//  example
//
//  Created by 赵兴满 on 16/1/25.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "USTimeRowBodyBackground.h"

@implementation USTimeRowBodyBackground

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        self.backgroundColor = [UIColor colorWithRed:217 green:217 blue:217 alpha:1.0];
        self.backgroundColor = [[UIColor colorWithHexString:@"d9d9d9"] colorWithAlphaComponent:0.8];
//        [self.layer setBorderColor:[UIColor greenColor].CGColor];
//        [self.layer setBorderWidth:1.0f];
    }
    return self;
}

@end
