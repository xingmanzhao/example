//
//  USCalendarViewController.h
//  Example
//
//  Created by 赵兴满 on 16/1/24.
//  Copyright © 2016年 hulianjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USEventRule.h"

@interface USCalendarViewController : UICollectionViewController
// cache ordered time span array
@property(nonatomic,strong) NSMutableDictionary *cachedOrderedTimeSpanData;
@property(nonatomic,strong) NSMutableArray *eventRuleArray;
@property(nonatomic,strong) NSMutableArray *eventOpenningTimeArray;
@end
