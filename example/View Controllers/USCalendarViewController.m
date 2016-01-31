//
//  USCalendarViewController.m
//  Example
//
//  Created by 赵兴满 on 16/1/24.
//  Copyright © 2016年 hulianjia. All rights reserved.
//

#import "USCalendarViewController.h"
#import "USCollectionViewCalendarLayout.h"

// Collection View Reusable Views
#import "USGridline.h"
#import "USTimeRowHeaderBackground.h"
#import "USEventCell.h"
#import "USTimeRowHeader.h"

//#import "UIGestureRecognizer+DraggingAdditions.h"

// Added
#import "USTimeRowBodyBackground.h"

//NSString * const USEventCellReuseIdentifier = @"USEventCellReuseIdentifier";
//NSString * const USDayColumnHeaderReuseIdentifier = @"USDayColumnHeaderReuseIdentifier";
//NSString * const USTimeRowHeaderReuseIdentifier = @"USTimeRowHeaderReuseIdentifier";

@interface USCalendarViewController ()<USCollectionViewDelegateCalendarLayout, USEventCellDelegate>
@property(nonatomic,strong) USCollectionViewCalendarLayout *collectionViewCalendarLayout;
@end

@implementation USCalendarViewController

static NSString * const reuseIdentifier = @"Cell";

-(id)init{
    self.collectionViewCalendarLayout = [[USCollectionViewCalendarLayout alloc]init];
    self.collectionViewCalendarLayout.sectionLayoutType = USSectionLayoutTypeHorizontalTile;
    self.collectionViewCalendarLayout.delegate = self;
    self = [super initWithCollectionViewLayout:self.collectionViewCalendarLayout];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[USEventCell class] forCellWithReuseIdentifier:USEventCellReuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    
    NSInteger numberOfItemsInSection = 0;
    if(self.eventOpenningTimeArray){
        numberOfItemsInSection = [self.eventOpenningTimeArray count] - 1;
    }
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    USEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:USEventCellReuseIdentifier forIndexPath:indexPath];
   
//    UIEdgeInsets sectionMargin = self.collectionViewCalendarLayout.sectionMargin;
//    cell.hourHeight = self.collectionViewCalendarLayout.hourHeight;
//    cell.collectionViewSectionMargin = sectionMargin;
//    cell.topGuideline = self.collectionViewCalendarLayout.topGuideline;
//    cell.bottomGuideline = self.collectionViewCalendarLayout.bottomGuideline;
//    cell.calendarLayoutDelegate = self;
//    cell.delegate = self;
    // Configure the cell
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    
 if (kind == USCollectionElementKindTimeRowHeader) {
//        USTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:USTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
//        timeRowHeader.time = [self.eventOpenningTimeArray objectAtIndex:indexPath.item];
//        view = timeRowHeader;
    }
    return view;
}

#pragma mark <UICollectionViewDelegate>
-(void)initialize{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = YES;
    
//    [self.collectionView registerClass:USEventCell.class forCellWithReuseIdentifier:USEventCellReuseIdentifier];
//    [self.collectionView registerClass:USTimeRowHeader.class forSupplementaryViewOfKind:USCollectionElementKindTimeRowHeader withReuseIdentifier:USTimeRowHeaderReuseIdentifier];
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:USGridline.class forDecorationViewOfKind:USCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:USGridline.class forDecorationViewOfKind:USCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:USTimeRowHeaderBackground.class forDecorationViewOfKind:USCollectionElementKindTimeRowHeaderBackground];
    
    // Added
    [self.collectionViewCalendarLayout registerClass:USTimeRowBodyBackground.class  forDecorationViewOfKind:USCollectionElementKindTimeRowBodyBackground];
    
    // cached
    self.cachedOrderedTimeSpanData = [NSMutableDictionary new];
    [self.cachedOrderedTimeSpanData setObject:@(2) forKey:@(0)];
    [self.cachedOrderedTimeSpanData setObject:@(3) forKey:@(5)];
    
    self.eventRuleArray = [NSMutableArray array];
    self.eventOpenningTimeArray = [NSMutableArray array];
    [self createOpenningTime];
    
    USEventRule *rule9_23 = [[USEventRule alloc]init];
    rule9_23.startTimeNumber = 0;
    rule9_23.timeSpan = 28;
    rule9_23.price = 20;
    rule9_23.valuationType = USPerHour;
    [self.eventRuleArray addObject:rule9_23];
    
    USEventRule *rule235_8 = [[USEventRule alloc]init];
    rule235_8.startTimeNumber = 21;
    rule235_8.timeSpan = 3;
    rule235_8.total = 300;
    rule235_8.valuationType = USPackage;
    [self.eventRuleArray addObject:rule235_8];
    
    USEventRule *rule8_12 = [[USEventRule alloc]init];
    rule8_12.startTimeNumber = 24;
    rule8_12.timeSpan = 8;
    rule8_12.price = 20;
    rule8_12.valuationType = USPerHour;
    [self.eventRuleArray addObject:rule8_12];

}

#pragma mark - USCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *currentTime = [formatter dateFromString:@"2016-1-26 10:00:00"];

    return currentTime;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *startTime = [formatter dateFromString:@"2016-1-26 9:00:00"];
    return startTime;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *endTime = [formatter dateFromString:@"2016-1-27 12:00:00"];
    return endTime;
}

-(NSTimeInterval)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewLayout{
    NSTimeInterval timeInterval = 30 * 60;
    return timeInterval;
}

// saved ordered time span data
-(NSArray*)orderedTimeSpanForCollectionView:(UICollectionView*)collectionView layout:(USCollectionViewCalendarLayout*)collectionViewLayout{
    
    NSMutableArray *orderedTimeSpanArray = [NSMutableArray array];
    if(self.cachedOrderedTimeSpanData == nil || [self.cachedOrderedTimeSpanData count] == 0){
        return orderedTimeSpanArray;
    }else{
        NSArray *allKeys = [self.cachedOrderedTimeSpanData allKeys];
        for (id key in allKeys) {
            int timespan = [[self.cachedOrderedTimeSpanData objectForKey:key] intValue];
            int keyInt = [key intValue];
            
            // preview add 0.5
            if(keyInt > 0){
                int prewOrderNumber = keyInt - 1;
                if([orderedTimeSpanArray containsObject:@(prewOrderNumber)] == NO){
                    [orderedTimeSpanArray addObject:@(prewOrderNumber)];
                }
            }
            
            for(int i = 0;i < timespan;i++){
                int value = i + keyInt;
                if([orderedTimeSpanArray containsObject:@(value)] == NO){
                    [orderedTimeSpanArray addObject: @(value)];
                }
            }
            
            // nexe add 0.5
            int nextOrderNumber = keyInt + timespan;
            if([orderedTimeSpanArray containsObject:@(nextOrderNumber)] == NO){
                 [orderedTimeSpanArray addObject: @(nextOrderNumber)];
            }
        }
        return orderedTimeSpanArray;
    }
}

-(void)createOpenningTime{
    if(self.eventOpenningTimeArray){
        // start date
        NSDate *startDate = [self collectionView:self.collectionView layout:self.collectionViewCalendarLayout startTimeForItemAtIndexPath:nil];
        // end date
        NSDate *endDate = [self collectionView:self.collectionView layout:self.collectionViewCalendarLayout endTimeForItemAtIndexPath:nil];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
        
        // middle date
        NSDateComponents *comp = [self dateComponent:startDate];
        NSDate *middleDate = [formatter dateFromString: [NSString stringWithFormat:@"%d-%d-%d 23:30:00",comp.year,comp.month,comp.day]];
        
        // total time interval
        NSTimeInterval timeSpan = [middleDate timeIntervalSinceDate:startDate];
        // per time interval
        NSTimeInterval setTimeSpan = [self collectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        // total number of time span
        NSInteger numberOfTimespan = timeSpan / setTimeSpan;
    
        for (NSInteger i = 0; i < numberOfTimespan + 1; i++) {
            NSDate *currentDate = [startDate dateByAddingTimeInterval:setTimeSpan * i];
            [self.eventOpenningTimeArray addObject:currentDate];
        }
        
        
        NSDateComponents *compTomorrow = [self dateComponent:endDate];
        NSDate *tomorrow = [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 08:00:00",compTomorrow.year,compTomorrow.month,compTomorrow.day]];
        
        for (NSInteger i = 0; i < 9; i++) {
            NSDate *currentDate = [tomorrow dateByAddingTimeInterval:setTimeSpan * i];
            [self.eventOpenningTimeArray addObject:currentDate];
        }
    }
}

-(NSDateComponents*)dateComponent:(NSDate*)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    return [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
}

- (void)updateSelectedTimeSpan:(NSInteger )startTimeNumber withTimeSpan:(NSInteger)timeSpan{
    NSLog(@"startNumber:%d, timeSpan:%d",startTimeNumber,timeSpan);
}


@end
