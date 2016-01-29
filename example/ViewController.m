//
//  ViewController.m
//  example
//
//  Created by 赵兴满 on 16/1/23.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//





#import "ViewController.h"
#import "USCalendarViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSInteger flagUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    NSInteger flagUnit =  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *today = [NSDate date];
    NSCalendar *calGre = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compGre = [calGre components:flagUnit fromDate:today];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSLog(@"%@-%@-%@ %@:%@:%@",@(compGre.year),@(compGre.month),@(compGre.day),@(compGre.hour),@(compGre.minute),@(compGre.second));
    
    NSCalendar *calChi = [[NSCalendar alloc]initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *compChi = [calChi components:flagUnit fromDate:today];
    NSLog(@"%@-%@-%@ %@:%@:%@",@(compChi.year),@(compChi.month),@(compChi.day),@(compChi.hour),@(compChi.minute),@(compChi.second));
    
    NSCalendar *calJap = [[NSCalendar alloc]initWithCalendarIdentifier:NSJapaneseCalendar];
    NSDateComponents *compJap = [calJap components:flagUnit fromDate:today];
    NSLog(@"%@-%@-%@ %@:%@:%@",@(compJap.year),@(compJap.month),@(compJap.day),@(compJap.hour),@(compJap.minute),@(compJap.second));
    
    
    NSTimeZone *sysZone = [NSTimeZone systemTimeZone];
    NSLog(@"sys data:%@",[sysZone data]);
    NSLog(@"abbr:%@",[sysZone abbreviation]);
    NSLog(@"%@",sysZone);
    NSLog(@"desp:%@",[sysZone description]);
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSLog(@"local zone:%@",localZone);
    NSLog(@"desp:%@",[localZone description]);
    
    NSString *todayString = [formatter stringFromDate:today];
    NSLog(@"string:%@",todayString);
    NSDate *formatterDate = [formatter dateFromString:todayString];
    NSLog(@"date:%@",formatterDate);
    
    BOOL isEqual = [today isEqualToDate:formatterDate];
    NSLog(@"isEqual:%@",isEqual ?@"YES":@"NO");
    
    NSDate *timeIntervalDate = [today dateByAddingTimeInterval:60 * 60 * 1];
    NSLog(@"timeIntervalDate:%@",timeIntervalDate);
    
    NSDate *earlierDate= [timeIntervalDate earlierDate:today];
    NSDate *laterDate = [timeIntervalDate laterDate:today];
    NSLog(@"earlierDate:%@",earlierDate);
    NSLog(@"laterDate:%@",laterDate);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)calendarAction:(id)sender {
    USCalendarViewController *calVC = [[USCalendarViewController alloc]init];
    [self.navigationController pushViewController:calVC animated:YES];
}

@end
