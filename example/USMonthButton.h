//
//  USMonthButton.h
//  example
//
//  Created by 赵兴满 on 16/1/31.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USMonthButton : UIButton

-(id)initWithFrame:(CGRect)frame withIcon:(UIImage*)icon;

@property(nonatomic,strong) NSDate *showDate;
@property(nonatomic,assign) BOOL isSelected;
//@property(nonatomic,strong) NSString *yearTitle;
//@property(nonatomic,strong) NSString *monthTitle;
@end
