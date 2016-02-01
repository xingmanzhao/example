//
//  USMonthButtonView.h
//  example
//
//  Created by 赵兴满 on 16/2/1.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USMonthButtonView : UIView
-(id)initWithFrame:(CGRect)frame withIcon:(UIImage*)icon;

@property(nonatomic,strong) NSDate *showMonthDate;
@property(nonatomic,assign) BOOL isSelected;
@end
