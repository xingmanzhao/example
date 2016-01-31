//
//  DemoViewController.m
//  example
//
//  Created by 赵兴满 on 16/1/29.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "DemoViewController.h"
#import "USCollectionViewCalendarLayout.h"

// Collection View Reusable Views
#import "USGridline.h"
#import "USTimeRowHeaderBackground.h"
#import "USEventCell.h"
#import "USTimeRowHeader.h"

//#import "UIGestureRecognizer+DraggingAdditions.h"

// Added
#import "USTimeRowBodyBackground.h"
#import "USMonthButton.h"
#import "USDayButton.h"


NSString * const USEventCellReuseIdentifier = @"USEventCellReuseIdentifier";
NSString * const USDayColumnHeaderReuseIdentifier = @"USDayColumnHeaderReuseIdentifier";
NSString * const USTimeRowHeaderReuseIdentifier = @"USTimeRowHeaderReuseIdentifier";

@interface DemoViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,USEventCellDelegate,USCollectionViewDelegateCalendarLayout>
{
//    UILabel *yearLabel;
    //    UILabel *monthLabel;
    UIView *selectedMonthView;
    USMonthButton *selectedMonthButton;
    UIScrollView *dateScrollView;
}

@property(nonatomic,strong) USCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSDate *selectedDate;
@property(nonatomic,strong) NSMutableArray *canSelectedMonthArray;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.numberOfMonth = 3;
    self.monthWidth = 56;
    self.monthHeight = 56;
    self.dayWidth = 56;
    self.dayHeight = 56;
    
    [self initialize];
    [self createMonthView];
    [self createDayScrollView];
    
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

-(void)initialize1{
    
    
    self.numberOfMonth = 3;
    self.monthWidth = 56;
    self.monthHeight = 56;
    self.dayWidth = 56;
    self.dayHeight = 56;
    


//    UIView *currentMonthView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.monthWidth, self.monthHeight)];
//    UILabel *currentYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(currentMonthView.frame), 20)];
//    UILabel *currentMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(currentYearLabel.frame) + 3, CGRectGetWidth(currentYearLabel.frame), 20)];
//    
//    [currentMonthView addSubview:currentYearLabel];
//    [currentMonthView addSubview:currentMonthLabel];
//    [self.view addSubview:currentMonthView];
    
    
//    UIView *monthView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(currentMonthView.frame), self.monthWidth, self.monthHeight * self.numberOfMonth)];
//    [monthView setClipsToBounds:YES];
//    monthView.layer.masksToBounds = YES;
//    [monthView.layer setBorderColor:[UIColor blueColor].CGColor];
//    [monthView.layer setBorderWidth:1.0f];
//    for (int i = 0; i < self.numberOfMonth; i++) {
//        NSDate *currentDate = [today dateByAddingTimeInterval:i * 24 * 60 * 60];
//        NSDateComponents *com =  [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
//        UIButton *monthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.monthHeight * i, self.monthWidth, self.monthHeight)];
//        [monthButton setTitle:[NSString stringWithFormat:@"%d",com.month] forState:UIControlStateNormal];
//        [monthButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [monthButton.layer setBorderColor:[UIColor blackColor].CGColor];
//        [monthButton.layer setBorderWidth:1.0f];
//        [monthView addSubview:monthButton];
//    }
//    [self.view addSubview:monthView];
    
    
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *comToday =  [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
//    
//    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
//    NSUInteger numberOfDaysInMonth = range.length;
//    NSLog(@"%d",numberOfDaysInMonth);
//    
//    CGFloat dayMinX = 0;
//    CGFloat dayWidth = 64;
//    CGFloat dayHeight = 64;
//    
//    dateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(monthView.frame), CGRectGetMinY(monthView.frame), kScreenWidth - CGRectGetWidth(monthView.frame), CGRectGetHeight(monthView.frame))];
//    [dateScrollView.layer setBorderColor:[UIColor yellowColor].CGColor];
//    [dateScrollView.layer setBorderWidth:1.0f];
//    [dateScrollView setScrollEnabled:YES];
//
//    for (NSInteger day = comToday.day; day <=range.length; day++) {
//        UIButton *dayButton = [[UIButton alloc]initWithFrame:CGRectMake(dayWidth * (day - comToday.day), 0, dayWidth, dayHeight)];
//        [dayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [dayButton setTitle:[NSString stringWithFormat:@"%d",day] forState:UIControlStateNormal];
//        [dayButton setBackgroundColor:[UIColor orangeColor]];
//        [dayButton.layer setBorderWidth:1.0f];
//        [dayButton.layer setBorderColor:[UIColor redColor].CGColor];
//        [dateScrollView addSubview:dayButton];
//    }
//    
//    [dateScrollView setContentSize:CGSizeMake(dayWidth * (range.length - comToday.day), dayHeight)];
//    
//    [self.view addSubview:dateScrollView];

}


-(void)createMonthView{
    
    NSDate *today = [[NSDate date] dateByAddingDays:1];
    selectedMonthButton = [[USMonthButton alloc]initWithFrame:CGRectMake(0, 64, self.monthWidth, self.monthHeight) withIcon:[UIImage imageNamed:@"common_img_arrowDownStroke_normal"]];
    [self.view addSubview:selectedMonthButton];
//    [selectedMonthButton.layer setBorderColor:[UIColor redColor].CGColor];
//    [selectedMonthButton.layer setBorderWidth:1.0f];
    [selectedMonthButton setShowDate:today];
    [selectedMonthButton setBackgroundColor:[[UIColor colorWithHexString:@"eeeeee"] colorWithAlphaComponent:0.8f]];
    selectedMonthButton.isSelected = NO;
    [selectedMonthButton addTarget:self action:@selector(monthSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect selectedMonthViewFrame = CGRectMake(0, CGRectGetMaxY(selectedMonthButton.frame) - self.monthHeight * 3, self.monthWidth, self.monthHeight * 3);
    selectedMonthView = [[UIView alloc]initWithFrame:selectedMonthViewFrame];
    [selectedMonthView.layer setBorderWidth:1.0f];
    [selectedMonthView.layer setBorderColor:[[UIColor colorWithHexString:@"939393"] colorWithAlphaComponent:0.8f].CGColor];
    selectedMonthView.alpha = 0;
    [self.view addSubview:selectedMonthView];
    [self.view bringSubviewToFront:selectedMonthButton];

    if(self.canSelectedMonthArray){
        for (int i = 0; i < [self.canSelectedMonthArray count]; i++) {
            USMonthButton *monthButton = [[USMonthButton alloc]initWithFrame:CGRectMake(0, i * self.monthHeight, self.monthWidth, self.monthHeight)];
            [selectedMonthView addSubview:monthButton];
//            [monthButton.layer setBorderColor:[UIColor redColor].CGColor];
//            [monthButton.layer setBorderWidth:1.0f];
            [monthButton setShowDate:[today dateByAddingMonths:i]];
            monthButton.isSelected = YES;
            [monthButton addTarget:self action:@selector(monthSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
            [selectedMonthView addSubview:monthButton];
        }
    }
}

-(void)monthSelectedAction:(id)sender{
    NSLog(@"fadfsadf");
    CGAffineTransform t = selectedMonthView.transform;
    [UIView animateWithDuration:0.2f animations:^{
        if(t.ty == 0){
            selectedMonthView.alpha = 1;
            selectedMonthView.transform = CGAffineTransformMakeTranslation(0, self.monthHeight * 3);
        }else{
            selectedMonthView.alpha = 0;
            selectedMonthView.transform = CGAffineTransformIdentity;
        }
    }];
}

//-(void)tapGestureReconizerForDefaultMonth:(UIGestureRecognizer*)recognizer{
////    selectedMonthView.transform
//    CGAffineTransform trans = selectedMonthView.transform;
//    if(trans.ty == CGAffineTransformIdentity.ty){
//        selectedMonthView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(selectedMonthView.frame));
//    }else{
//        selectedMonthView.transform = CGAffineTransformIdentity;
//    }
//}

-(void)createDayScrollView{
    CGRect selectedMonthButtonFrame = selectedMonthButton.frame;
    CGFloat dateScrollViewWidth = kScreenWidth - CGRectGetWidth(selectedMonthButtonFrame);
    self.dayWidth = dateScrollViewWidth / 7;
    dateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectedMonthButtonFrame), CGRectGetMinY(selectedMonthButtonFrame), dateScrollViewWidth, CGRectGetHeight(selectedMonthButtonFrame))];
//    [dateScrollView.layer setBorderColor:[UIColor yellowColor].CGColor];
//    [dateScrollView.layer setBorderWidth:1.0f];
    dateScrollView.showsHorizontalScrollIndicator = NO;
    dateScrollView.showsVerticalScrollIndicator = NO;
    [dateScrollView setScrollEnabled:YES];
    
    NSDate *today = [[NSDate date] dateByAddingDays:1];
    NSDate *dateAtEndOfDay = [today endOfMonth];
    
    
    for (NSInteger index = 0; index <=(dateAtEndOfDay.day - today.day); index++) {
        USDayButton *dayButton = [[USDayButton alloc]initWithFrame:CGRectMake(self.dayWidth * index, 0, self.dayWidth, self.dayHeight)];
        [dayButton setShowDate:[today dateByAddingDays:index]];
        [dateScrollView addSubview:dayButton];
    }
    
    [dateScrollView setContentSize:CGSizeMake(self.dayWidth * (dateAtEndOfDay.day - today.day + 1), self.dayHeight)];
    
    [self.view addSubview:dateScrollView];
}









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
    USEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:USEventCellReuseIdentifier forIndexPath:indexPath];
    
    UIEdgeInsets sectionMargin = self.collectionViewCalendarLayout.sectionMargin;
    cell.hourHeight = self.collectionViewCalendarLayout.hourHeight;
    cell.collectionViewSectionMargin = sectionMargin;
    cell.topGuideline = self.collectionViewCalendarLayout.topGuideline;
    cell.bottomGuideline = self.collectionViewCalendarLayout.bottomGuideline;
    cell.calendarLayoutDelegate = self;
    cell.delegate = self;
    // Configure the cell
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    
    if (kind == USCollectionElementKindTimeRowHeader) {
        USTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:USTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.eventOpenningTimeArray objectAtIndex:indexPath.item];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark <UICollectionViewDelegate>
-(void)initialize{
    
    
    self.canSelectedMonthArray = [NSMutableArray array];
   
    
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    NSDateComponents *com = [currentCalender components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSDate *january = [formatter dateFromString:@"2016-1-1 00:00:00"];
    NSDate *february = [formatter dateFromString:@"2016-2-1 00:00:00"];
    NSDate *march = [formatter dateFromString:@"2016-3-1 00:00:00"];
    [self.canSelectedMonthArray addObject:january];
    [self.canSelectedMonthArray addObject:february];
    [self.canSelectedMonthArray addObject:march];
    

    USCollectionViewCalendarLayout *layout = [[USCollectionViewCalendarLayout alloc]init];
    self.collectionViewCalendarLayout = layout;
    layout.sectionLayoutType = USSectionLayoutTypeHorizontalTile;
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100 - 60) collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[USEventCell class] forCellWithReuseIdentifier:USEventCellReuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.scrollEnabled = YES;
    
    [self.collectionView registerClass:USEventCell.class forCellWithReuseIdentifier:USEventCellReuseIdentifier];
    [self.collectionView registerClass:USTimeRowHeader.class forSupplementaryViewOfKind:USCollectionElementKindTimeRowHeader withReuseIdentifier:USTimeRowHeaderReuseIdentifier];
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:USGridline.class forDecorationViewOfKind:USCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:USGridline.class forDecorationViewOfKind:USCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:USTimeRowHeaderBackground.class forDecorationViewOfKind:USCollectionElementKindTimeRowHeaderBackground];
    
    // Added
    [self.collectionViewCalendarLayout registerClass:USTimeRowBodyBackground.class  forDecorationViewOfKind:USCollectionElementKindTimeRowBodyBackground];
    
    // cached
    self.cachedOrderedTimeSpanData = [NSMutableDictionary new];
    [self.cachedOrderedTimeSpanData setObject:@(2) forKey:@(0)];
    [self.cachedOrderedTimeSpanData setObject:@(3) forKey:@(4)];
    
    self.eventRuleArray = [NSMutableArray array];
    self.eventOpenningTimeArray = [NSMutableArray array];
    [self createOpenningTime];
    
    
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
