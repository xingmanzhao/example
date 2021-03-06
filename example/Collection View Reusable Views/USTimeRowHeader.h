//
//  MSTimeRowHeader.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USTimeRowHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, assign) BOOL isHalfAnHour;

@end
