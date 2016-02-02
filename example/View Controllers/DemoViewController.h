//
//  DemoViewController.h
//  example
//
//  Created by 赵兴满 on 16/1/29.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCollectionViewCalendarLayout.h"

@interface DemoViewController : UIViewController
@property(nonatomic,assign) NSInteger numberOfMonthForSelected;
@property(nonatomic,assign) CGFloat monthWidth;
@property(nonatomic,assign) CGFloat monthHeight;
@property(nonatomic,assign) CGFloat dayWidth;
@property(nonatomic,assign) CGFloat dayHeight;

@property(nonatomic,strong) NSDate *selectedMonthDate;
@property(nonatomic,strong) NSDate *selectedDay;

@property(nonatomic,strong) NSDate *beginningDateForOpening;
@property(nonatomic,strong) NSDate *endDateForOpening;

@property(nonatomic,strong) NSMutableDictionary *cachedOrderedTimeSpanData;
@property(nonatomic,strong) NSMutableArray *eventRuleArray;
@property(nonatomic,strong) NSMutableArray *eventOpenningTimeArray;
@property(nonatomic,strong) USCollectionViewCalendarLayout *calendarLayout;


@end
