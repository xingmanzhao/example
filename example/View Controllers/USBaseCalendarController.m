//
//  USBaseController.m
//  example
//
//  Created by 赵兴满 on 16/1/30.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "USBaseCalendarController.h"

@interface USBaseCalendarController()
{
    NSMutableArray *updateControllerArray;
}
@end

@implementation USBaseCalendarController

-(void)add:(USBaseCalendarController*)controller{
    if (updateControllerArray == nil) {
        updateControllerArray = [NSMutableArray array];
    }
}

-(void)update{
    if(updateControllerArray){
        for (USBaseCalendarController *controller in updateControllerArray) {
            [controller update];
        }
    }
}

-(void)remove:(USBaseCalendarController*)controller{
    if(updateControllerArray){
        for (USBaseCalendarController *obj in updateControllerArray) {
            if([obj isEqual:controller] == YES){
                [updateControllerArray removeObject:controller];
                break;
            }
        }
    }
}

@end
