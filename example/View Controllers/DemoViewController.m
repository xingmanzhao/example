//
//  DemoViewController.m
//  example
//
//  Created by 赵兴满 on 16/1/29.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()<UIScrollViewDelegate>
{
    UIView *monthView;
    UIScrollView *dateScrollView;
}
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

-(void)initialize{
    self.numberOfMonth = 3;
    self.monthWidth = 64;
    self.monthHeight = 64;
    self.dayWidth = 64;
    self.dayHeight = 64;
    
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];

    UIView *currentMonthView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.monthWidth, self.monthHeight)];
    UILabel *currentYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, CGRectGetWidth(currentMonthView.frame), 20)];
    UILabel *currentMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(currentYearLabel.frame) + 3, CGRectGetWidth(currentYearLabel.frame), 20)];
    
    [currentMonthView addSubview:currentYearLabel];
    [currentMonthView addSubview:currentMonthLabel];
    [self.view addSubview:currentMonthView];
    
    monthView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(currentMonthView.frame), self.monthWidth, self.monthHeight * self.numberOfMonth)];
    [monthView setClipsToBounds:YES];
    monthView.layer.masksToBounds = YES;
    [monthView.layer setBorderColor:[UIColor blueColor].CGColor];
    [monthView.layer setBorderWidth:1.0f];
    for (int i = 0; i < self.numberOfMonth; i++) {
        NSDate *currentDate = [today dateByAddingTimeInterval:i * 24 * 60 * 60];
        NSDateComponents *com =  [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
        UIButton *monthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.monthHeight * i, self.monthWidth, self.monthHeight)];
        [monthButton setTitle:[NSString stringWithFormat:@"%d",com.month] forState:UIControlStateNormal];
        [monthButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [monthButton.layer setBorderColor:[UIColor blackColor].CGColor];
        [monthButton.layer setBorderWidth:1.0f];
        [monthView addSubview:monthButton];
    }
    [self.view addSubview:monthView];
    
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comToday =  [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    NSLog(@"%d",numberOfDaysInMonth);
    
    CGFloat dayMinX = 0;
    CGFloat dayWidth = 64;
    CGFloat dayHeight = 64;
    
    dateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(monthView.frame), CGRectGetMinY(monthView.frame), kScreenWidth - CGRectGetWidth(monthView.frame), CGRectGetHeight(monthView.frame))];
    [dateScrollView.layer setBorderColor:[UIColor yellowColor].CGColor];
    [dateScrollView.layer setBorderWidth:1.0f];
    [dateScrollView setScrollEnabled:YES];

    for (NSInteger day = comToday.day; day <=range.length; day++) {
        UIButton *dayButton = [[UIButton alloc]initWithFrame:CGRectMake(dayWidth * (day - comToday.day), 0, dayWidth, dayHeight)];
        [dayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [dayButton setTitle:[NSString stringWithFormat:@"%d",day] forState:UIControlStateNormal];
        [dayButton setBackgroundColor:[UIColor orangeColor]];
        [dayButton.layer setBorderWidth:1.0f];
        [dayButton.layer setBorderColor:[UIColor redColor].CGColor];
        [dateScrollView addSubview:dayButton];
    }
    
    [dateScrollView setContentSize:CGSizeMake(dayWidth * (range.length - comToday.day), dayHeight)];
    
    


    
    
    
    
    [self.view addSubview:dateScrollView];

}

@end
