//
//  MSButton.h
//  Example
//
//  Created by Ricky on 14-1-4.
//  Copyright (c) 2014年 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USButton : UIButton
@property (nonatomic, strong) NSNumber *remoteID;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSNumber *timeToBeDecided;
@property (nonatomic, strong) NSNumber *dateToBeDecided;

@end
