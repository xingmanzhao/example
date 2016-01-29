//
//  USEventRule.h
//  example
//
//  Created by 赵兴满 on 16/1/27.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,USValuationType){
    USPerHour,
    USPackage
};

@interface USEventRule : NSObject
@property(nonatomic,assign) NSInteger startTimeNumber;
@property(nonatomic,assign) NSInteger timeSpan;
@property(nonatomic,assign) CGFloat price;
@property(nonatomic,assign) CGFloat total;
@property(nonatomic,assign) CGFloat discount;
@property(nonatomic,assign) USValuationType valuationType;

 @end
