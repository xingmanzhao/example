//
//  MSEventCell.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCollectionViewCalendarLayout.h"

@class USEvent;
@protocol USEventCellDelegate;

@interface USEventCell : UICollectionViewCell

@property (nonatomic, weak) USEvent *event;
@property(nonatomic,strong) NSDate *beginDate;
@property(nonatomic,strong) NSDate *endDate;
@property (nonatomic, weak) id<USEventCellDelegate>delegate;

@property(nonatomic,weak) id<USCollectionViewDelegateCalendarLayout> calendarLayoutDelegate;
//
@property(nonatomic,assign) CGPoint startCellCenter;
@property(nonatomic,assign) CGFloat startCellHeight;
@property(nonatomic,assign) CGFloat hourHeight;
@property(nonatomic,assign) UIEdgeInsets collectionViewContentMargin;
@property(nonatomic,assign) UIEdgeInsets collectionViewSectionMargin;
@property(nonatomic,assign) BOOL isOrdered;
@property(nonatomic,assign) CGFloat topGuideline;
@property(nonatomic,assign) CGFloat bottomGuideline;


@end

@protocol USEventCellDelegate

- (void)updateSelectedTimeSpan:(NSInteger )startTimeNumber withTimeSpan:(NSInteger)timeSpan;

@end