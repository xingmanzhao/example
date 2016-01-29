//
//  MSData.h
//  Example
//
//  Created by Ricky on 14-1-4.
//  Copyright (c) 2014年 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USData : NSObject
{

}


+(NSMutableArray *)initWithData;
+(NSMutableArray *)initWithDataSection:(int)sections withStartDate:(NSDate *)startDate;
- (void)addEventToSection:(int)section
        withEventRemoteID:(NSNumber *)remoteID
            withStartDate:(NSDate *) startDate
                withTitle:(NSString *)title
             withLocation:(NSString *)location
      withTimeToBeDecided:(NSNumber *)timeToBeDecided
      withDateToBeDecided:(NSNumber *)date;
@end
