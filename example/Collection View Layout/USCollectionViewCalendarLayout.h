//
//  USCollectionViewCalendarLayout.h
//  example
//
//  Created by 赵兴满 on 16/1/25.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import <UIKit/UIKit.h>

// Added
extern NSString *const USCollectionElementKindTimeRowBodyBackground;

extern NSString * const USCollectionElementKindTimeRowHeader;
extern NSString * const USCollectionElementKindDayColumnHeader;
extern NSString * const USCollectionElementKindTimeRowHeaderBackground;
extern NSString * const USCollectionElementKindDayColumnHeaderBackground;
extern NSString * const USCollectionElementKindCurrentTimeIndicator;
extern NSString * const USCollectionElementKindCurrentTimeHorizontalGridline;
extern NSString * const USCollectionElementKindVerticalGridline;
extern NSString * const USCollectionElementKindHorizontalGridline;

typedef NS_ENUM(NSUInteger, USSectionLayoutType) {
    USSectionLayoutTypeHorizontalTile,
    USSectionLayoutTypeVerticalTile
};

typedef NS_ENUM(NSUInteger, USHeaderLayoutType) {
    USHeaderLayoutTypeTimeRowAboveDayColumn,
    USHeaderLayoutTypeDayColumnAboveTimeRow
};

@class USCollectionViewCalendarLayout;
@protocol USCollectionViewDelegateCalendarLayout;

@interface USCollectionViewCalendarLayout : UICollectionViewLayout

@property(nonatomic,weak) id<USCollectionViewDelegateCalendarLayout> delegate;
@property(nonatomic,assign) CGFloat sectionWidth;
@property(nonatomic,assign) CGFloat hourHeight;
@property(nonatomic,assign) CGFloat timeRowHeaderWidth;
@property(nonatomic,assign) CGFloat horizontalGridlineHeight;
@property(nonatomic,assign) CGFloat verticalGridlineWidth;
@property(nonatomic,assign) UIEdgeInsets sectionMargin;
@property(nonatomic,assign) UIEdgeInsets contentMargin;
@property(nonatomic,assign) UIEdgeInsets cellMargin;

@property(nonatomic,assign) USSectionLayoutType sectionLayoutType;
@property(nonatomic,assign) USHeaderLayoutType headerLayoutType;
@property(nonatomic,assign) BOOL displayHeaderBackgroundAtOrigin;

-(NSDate*)dateForTimeRowHeaderAtIndexPath:(NSIndexPath*)indexPath;
-(void)invalidateLayoutCache;

@end


@protocol USCollectionViewDelegateCalendarLayout <UICollectionViewDelegate>

@required


-(NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSInteger)section;
-(NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSInteger)section;
-(NSTimeInterval)collectionView:(UICollectionView*)collectionView layout:(USCollectionViewCalendarLayout*)collectionViewLayout;

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout dayForSection:(NSInteger)section;
//- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath;
//- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout;


// Added
//-(CGFloat)hourHeightForcollectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout;
// saved order time span data
-(NSArray*)orderedTimeSpanForCollectionView:(UICollectionView*)collectionView layout:(USCollectionViewCalendarLayout*)collectionViewLayout;



@optional

@end
