//
//  DemoViewController.m
//  example
//
//  Created by 赵兴满 on 16/1/29.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "DemoViewController.h"

// Collection View Reusable Views
#import "USGridline.h"
#import "USTimeRowHeaderBackground.h"
#import "USEventCell.h"
#import "USTimeRowHeader.h"

//#import "UIGestureRecognizer+DraggingAdditions.h"

// Added
#import "USTimeRowBodyBackground.h"

#import "USMonthButtonView.h"
#import "USDayButtonView.h"

NSString * const USEventCellReuseIdentifier = @"USEventCellReuseIdentifier";
NSString * const USDayColumnHeaderReuseIdentifier = @"USDayColumnHeaderReuseIdentifier";
NSString * const USTimeRowHeaderReuseIdentifier = @"USTimeRowHeaderReuseIdentifier";

@interface DemoViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,USEventCellDelegate,USCollectionViewDelegateCalendarLayout>
{
//    UILabel *yearLabel;
    //    UILabel *monthLabel;
    UIView *selectedMonthView;
//    USMonthButton *selectedMonthButton;
    UIScrollView *dateScrollView;
    
    USMonthButtonView *selectedMonthButtonView;
}

@property(nonatomic,strong) USCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property(nonatomic,strong) UICollectionView *collectionView;
//@property(nonatomic,strong) NSDate *selectedDate;
//@property(nonatomic,strong) NSMutableArray *canSelectedMonthArray;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initializeMonthAndDaySelection];
    [self createMonthView];
    [self createDayScrollView];
    
    // update day scrollview
    [self updateSelectedMonth:self.selectedMonthDate];
    
    // initialize calendar
    [self initializeCalendar];
    
    [self.view bringSubviewToFront:selectedMonthButtonView];
    [self.view sendSubviewToBack:self.collectionView];
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


-(void)createMonthView{
    self.selectedMonthDate = self.selectedDay = [NSDate date];
    selectedMonthButtonView = [[USMonthButtonView alloc]initWithFrame:CGRectMake(0, 64, self.monthWidth, self.monthHeight) withIcon:[UIImage imageNamed:@"common_img_arrowDownStroke_normal"]];
    [self.view addSubview:selectedMonthButtonView];
    selectedMonthButtonView.isSelected = NO;
    [selectedMonthButtonView setBackgroundColor:[UIColor colorWithHexString:@"eeefef"]];
    
    UITapGestureRecognizer *selectedMonthButtonTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerForSelectedMonthButton:)];
    [selectedMonthButtonView addGestureRecognizer:selectedMonthButtonTapGestureRecognizer];
    
    CGRect selectedMonthViewFrame = CGRectMake(0, CGRectGetMaxY(selectedMonthButtonView.frame) - self.monthHeight * 3, self.monthWidth, self.monthHeight * 3);
    selectedMonthView = [[UIView alloc]initWithFrame:selectedMonthViewFrame];
    CGFloat borderWidth = ([[UIScreen mainScreen] scale] == 2.0 ? 0.5 : 0.5);
    [selectedMonthView.layer setBorderWidth:borderWidth];
    [selectedMonthView.layer setBorderColor:[[UIColor colorWithHexString:@"939393"] colorWithAlphaComponent:0.8f].CGColor];
//    [selectedMonthView.layer setBorderColor:[UIColor colorWithHexString:@"939393"].CGColor];
    selectedMonthView.alpha = 0;
    [self.view addSubview:selectedMonthView];

    for (int i = 0; i < self.numberOfMonthForSelected; i++) {
        USMonthButtonView *monthButtonView = [[USMonthButtonView alloc]initWithFrame:CGRectMake(0, i * self.monthHeight, self.monthWidth, self.monthHeight)];
        monthButtonView.tag = i;
        [monthButtonView setShowMonthDate:[self.selectedMonthDate dateByAddingMonths:i]];
        monthButtonView.isSelected = i == 0 ? YES:NO;
        [selectedMonthView addSubview:monthButtonView];
        
        UITapGestureRecognizer *monthButtonTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerForMonthButton:)];
        [monthButtonView addGestureRecognizer:monthButtonTapGestureRecognizer];
    }
}

-(void)tapGestureRecognizerForMonthButton:(UIGestureRecognizer*)recognizer{
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
    
    UIView *selectedView = recognizer.view;
    USMonthButtonView *selectedButtonView = (USMonthButtonView*)selectedView;
    
    if(selectedButtonView.showMonthDate.month != self.selectedDay.month){
        for (UIView *view in selectedView.superview.subviews) {
            if([view isKindOfClass:[USMonthButtonView class]] == YES){
                USMonthButtonView *monthButton = (USMonthButtonView *)view;
                if(monthButton.isSelected == YES){
                    monthButton.isSelected = NO;
                }
            }
        }
        
        selectedButtonView.isSelected = YES;
        // show date
        NSDate *selectedMonth = selectedButtonView.showMonthDate;
        
        // update day scrollview
        [self updateSelectedMonth:selectedMonth];
    }
}

// update selected day on scroll view
-(void)updateSelectedMonth:(NSDate*)selectedMonth{
    
    // update selected month
    [selectedMonthButtonView setShowMonthDate:selectedMonth];
    
    if([dateScrollView.subviews count] > 0){
        [dateScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    NSDate *startDate = nil;
    NSDate *today = [NSDate date];
    
    if(today.month == selectedMonth.month){
        startDate = today;
    }else{
        startDate = [selectedMonth beginningOfMonth];
    }

    NSDate *endDate = [startDate endOfMonth];
    NSInteger daySpan = [endDate timeIntervalSinceDate:startDate] / (60 * 60  *24);
    
    for (NSInteger index = 0; index <= daySpan; index++) {
        USDayButtonView *dayButtonView = [[USDayButtonView alloc]initWithFrame:CGRectMake(self.dayWidth * index, 0, self.dayWidth, self.dayHeight)];
        dayButtonView.tag = index;
        NSDate *currentDate = [startDate dateByAddingDays:index];
        BOOL isSelected =  [currentDate isEqualToDateIgnoringTime:startDate];
        if(isSelected == YES){
            self.selectedDay = currentDate;
        }
        dayButtonView.isSelected = isSelected;
        [dayButtonView setShowDate:currentDate];
        [dateScrollView addSubview:dayButtonView];
        
        UITapGestureRecognizer *dayButtonTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerForDayButton:)];
        [dayButtonView addGestureRecognizer:dayButtonTapGestureRecognizer];
    }
    
    [dateScrollView setContentSize:CGSizeMake(self.dayWidth * (daySpan + 1), self.dayHeight)];
    
    NSInteger offsetDay = 0;
    if(self.selectedDay.month == today.month){
        offsetDay = self.selectedDay.day - today.day;
    }else{
        offsetDay = self.selectedDay.day - [selectedMonth beginningOfMonth].day;
    }
    
    CGFloat  offsetX = self.dayWidth * offsetDay;
    [UIView animateWithDuration:0.2f animations:^{
        [dateScrollView setContentOffset:CGPointMake(offsetX, 0)];
    }];
    
    [self setOpeningDate];
}

-(void)tapGestureRecognizerForSelectedMonthButton:(UIGestureRecognizer*)recognizer{
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

-(void)createDayScrollView{
    CGRect selectedMonthButtonFrame = selectedMonthButtonView.frame;
    CGFloat dateScrollViewWidth = kScreenWidth - CGRectGetWidth(selectedMonthButtonFrame);
    self.dayWidth = dateScrollViewWidth / 7;
    dateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectedMonthButtonFrame), CGRectGetMinY(selectedMonthButtonFrame), dateScrollViewWidth, CGRectGetHeight(selectedMonthButtonFrame))];
    dateScrollView.showsHorizontalScrollIndicator = NO;
    dateScrollView.showsVerticalScrollIndicator = NO;
    [dateScrollView setScrollEnabled:YES];
    
    [self.view addSubview:dateScrollView];
}

-(void)tapGestureRecognizerForDayButton:(UIGestureRecognizer*)recognizer{
    
    [self tapGestureRecognizerForCalendar:nil];
    
    UIView *view = recognizer.view;
    for (UIView *subview in view.superview.subviews) {
        USDayButtonView *dayButtonView = (USDayButtonView*)subview;
        if(dayButtonView.isSelected == YES){
            dayButtonView.isSelected = NO;
            break;
        }
    }
    
    USDayButtonView *selectedDayButtonView = (USDayButtonView*)view;
    selectedDayButtonView.isSelected = YES;
    self.selectedDay = selectedDayButtonView.showDate;
    
    [self setOpeningDate];
}

-(void)setOpeningDate{
    // update time span selected uiview
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    
    NSDate *tomorrow = [self.selectedDay dateByAddingDays:1];
    self.beginningDateForOpening =  [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 9:00:00", self.selectedDay.year, self.selectedDay.month,self.selectedDay.day]];
    self.endDateForOpening =  [formatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:00:00", tomorrow.year, tomorrow.month, tomorrow.day]];
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
    NSLog(@"indexPath:%d,%d,%d",indexPath.item,indexPath.row,indexPath.section);
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
-(void)initializeMonthAndDaySelection{
    
    // month and date selection
    self.numberOfMonthForSelected = 3;
    CGFloat scale = [[UIScreen mainScreen] scale];
    self.monthWidth = scale == 2.0 ? 50.0 : 56.0;
    self.monthHeight = scale == 2.0 ? 50.0 : 56.0;
    self.dayWidth = scale == 2.0 ? 50.0 : 56.0;
    self.dayHeight = scale == 2.0 ? 50.0 : 56.0;
}

-(void)initializeCalendar{
    // time selection
    self.calendarLayout = [[USCollectionViewCalendarLayout alloc]init];
    self.collectionViewCalendarLayout = self.calendarLayout;
    self.calendarLayout.sectionLayoutType = USSectionLayoutTypeHorizontalTile;
    self.calendarLayout.delegate = self;
    CGFloat timeSelectedMinY = CGRectGetMaxY(selectedMonthButtonView.frame);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, timeSelectedMinY, kScreenWidth, kScreenHeight - timeSelectedMinY - 60) collectionViewLayout:self.calendarLayout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
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
    
    UITapGestureRecognizer *calendarTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerForCalendar:)];
    [self.collectionView addGestureRecognizer:calendarTapGestureRecognizer];
}

-(void)tapGestureRecognizerForCalendar:(UIGestureRecognizer*)recognizer{
    CGAffineTransform t = selectedMonthView.transform;
    [UIView animateWithDuration:0.2f animations:^{
        if(t.ty != 0){
            selectedMonthView.alpha = 0;
            selectedMonthView.transform = CGAffineTransformIdentity;
        }
    }];
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
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
//    NSDate *startTime = [formatter dateFromString:@"2016-1-26 9:00:00"];
    return self.beginningDateForOpening;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(USCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
//    NSDate *endTime = [formatter dateFromString:@"2016-1-27 12:00:00"];
    return self.endDateForOpening;
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
    self.calendarLayout.cachedSelectedTimeNumber = startTimeNumber;
    self.calendarLayout.cachedSelectedTimeSpan = timeSpan;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.calendarLayout invalidateLayoutCache];
    [self.collectionView reloadData];
}


@end
