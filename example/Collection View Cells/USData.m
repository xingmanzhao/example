//
//  MSData.m
//  Example
//
//  Created by Ricky on 14-1-4.
//  Copyright (c) 2014年 Monospace Ltd. All rights reserved.
//

#import "USData.h"
#import "USEvent.h"

@implementation USData
+(NSMutableArray *)initWithData{
    NSMutableArray *data = [NSMutableArray array];
    
    //section 1
    NSMutableArray *section = [NSMutableArray array];
    //row 1
    USEvent *event = [[USEvent alloc]init];
    event.remoteID=[NSNumber numberWithInt:001];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-mm-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:@"2014-01-01 00:00:00"];
    event.start=date;
    event.title=@"section1 rowFirst";
    event.location=@"loaction";
    event.dateToBeDecided=[NSNumber numberWithInt:0];
    event.timeToBeDecided=[NSNumber numberWithInt:2];
    [section addObject:event];
    
    USEvent *event10 = [[USEvent alloc]init];
    event10.remoteID=[NSNumber numberWithInt:010];
    NSDateFormatter *formatter10 = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone10 = [NSTimeZone localTimeZone];
    [formatter10 setTimeZone:timeZone10];
    [formatter10 setDateFormat : @"yyyy-mm-dd HH:mm:ss"];
    NSDate *date10 = [formatter10 dateFromString:@"2014-01-02 00:00:00"];
    event10.start=date10;
    event10.title=@"section1 rowLast";
    event10.location=@"loaction";
    event10.dateToBeDecided=[NSNumber numberWithInt:0];
    event10.timeToBeDecided=[NSNumber numberWithInt:0];
    [section addObject:event10];
    
    //row 2
    USEvent *event2 = [[USEvent alloc]init];
    event2.remoteID=[NSNumber numberWithInt:002];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone2 = [NSTimeZone localTimeZone];
    [formatter2 setTimeZone:timeZone2];
    [formatter2 setDateFormat : @"yyyy-mm-dd HH:mm:ss"];
    NSDate *date2 = [formatter2 dateFromString:@"2014-01-01 11:00:00"];
    event2.start=date2;
    event2.title=@"section1 row2";
    event2.location=@"loaction";
    event2.dateToBeDecided=[NSNumber numberWithInt:0];
    event2.timeToBeDecided=[NSNumber numberWithInt:146];
    [section addObject:event2];

    
    
    
    //section 2
    NSMutableArray *section2 = [NSMutableArray array];
    //row 1
    
    USEvent *event20 = [[USEvent alloc]init];
    event20.remoteID=[NSNumber numberWithInt:021];
    NSDateFormatter *formatter20 = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone20 = [NSTimeZone localTimeZone];
    [formatter20 setTimeZone:timeZone20];
    [formatter20 setDateFormat : @"yyyy-mm-dd HH:mm:ss"];
    NSDate *date20 = [formatter20 dateFromString:@"2014-01-02 05:00:00"];
    event20.start=date20;
    event20.title=@"section2 row1";
    event20.location=@"loaction";
    event20.dateToBeDecided=[NSNumber numberWithInt:0];
    event20.timeToBeDecided=[NSNumber numberWithInt:3.7];
    [section2 addObject:event20];
    
    //row 2
    USEvent *event21 = [[USEvent alloc]init];
    event21.remoteID=[NSNumber numberWithInt:022];
    NSDateFormatter *formatter21 = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone21 = [NSTimeZone localTimeZone];
    [formatter21 setTimeZone:timeZone21];
    [formatter21 setDateFormat : @"yyyy-mm-dd HH:mm:ss"];
    NSDate *date21 = [formatter21 dateFromString:@"2014-01-02 13:00:00"];
    event21.start=date21;
    event21.title=@"secion2 row2";
    event21.location=@"loaction";
    event21.dateToBeDecided=[NSNumber numberWithInt:0];
    event21.timeToBeDecided=[NSNumber numberWithInt:1];
    [section2 addObject:event21];
    
    [data addObject:section];
    [data addObject:section2];
    return data ;
}

+(NSMutableArray *)initWithDataSection:(int)sections withStartDate:(NSDate *)startDate{
    
    NSMutableArray *data = [NSMutableArray array];
    if (sections <=0) {
        sections = 1;
    }
    
    for (int i = 0; i < sections ;i++) {
        //section 1
        NSMutableArray *section = [NSMutableArray array];
        //row 1
        USEvent *event = [[USEvent alloc]init];
        event.remoteID=[NSNumber numberWithInt:001+i];
        if (startDate != nil) {
            event.start = [startDate  dateByAddingTimeInterval:(60 * 60 * 24 * (i-1))];
        } else{
            
            NSDate *now = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * (i-1)];
            NSString *nowString = [NSString stringWithFormat:@"%@",now];
            NSString *nowDate = [NSString stringWithFormat:@"%@ 00:00:00",[nowString substringWithRange:NSMakeRange(0, 10)]];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat : @"yyyy-mm-dd HH:mm:ss"];
            NSDate *date = [formatter dateFromString:nowDate];
            event.start=date;
        }
        NSLog(@"event start:%@",event.start );
        event.title=@"section1 rowFirst";
        event.location=@"loaction";
        event.dateToBeDecided=[NSNumber numberWithInt:0];
        event.timeToBeDecided=[NSNumber numberWithInt:1];
        [section addObject:event];
        
        USEvent *event10 = [[USEvent alloc]init];
        event10.remoteID=[NSNumber numberWithInt:010+i];
        if (startDate != nil) {
            event10.start = [startDate  dateByAddingTimeInterval:(60 * 60 * 24 * i)];
        } else{
            NSDate *now = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * i];
            NSString *nowString = [NSString stringWithFormat:@"%@",now];
            NSString *nowDate = [NSString stringWithFormat:@"%@ 00:00:00",[nowString substringWithRange:NSMakeRange(0, 10)]];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat : @"yyyy-mm-dd HH:mm:ss"];
            NSDate *date = [formatter dateFromString:nowDate];
            event10.start=date;
        }
        NSLog(@"event10 start:%@",event10.start );
        event10.title=@"section1 rowLast";
        event10.location=@"loaction";
        event10.dateToBeDecided=[NSNumber numberWithInt:0];
        event10.timeToBeDecided=[NSNumber numberWithInt:1];
        [section addObject:event10];
        
        [data addObject:section];
    }
    return data ;
}
@end

