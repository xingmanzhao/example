//
//  MSEventCell.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "USEventCell.h"

@interface USEventCell ()
{
    UIButton *topDragButton;
    UIButton *bottomDragButton;
    CALayer *topLayer;
//    CALayer *bottomLayer;
}

@property(nonatomic,assign) NSInteger startTimeNumber;
@property(nonatomic,assign) NSInteger timeSpan;

@end

@implementation USEventCell

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addBorderLayer];
    
        self.isOrdered = NO;
        [self updateColorsOrdered];
    }
    
    // Cell width , height
    CGFloat widthForCell = self.bounds.size.width;
    CGFloat heightForCell = self.bounds.size.height;
    
    // Top And Bottom button width , height
    CGFloat widthForButton = 26.0f;
    CGFloat heightForButton = 26.0f;
    
    // Top Drag Button On Cell
    CGFloat xForTopButton = widthForCell * 0.8;
    CGFloat yForTopButton = -heightForButton / 2;
    
    topDragButton = [[UIButton alloc]initWithFrame:CGRectMake(xForTopButton , yForTopButton, widthForButton, heightForButton)];
    [topDragButton setTitle:@"" forState:UIControlStateNormal];
    [topDragButton setBackgroundColor:[UIColor whiteColor]];
    [topDragButton.layer setBorderColor:[UIColor colorWithHexString:@"e9466b"].CGColor];
    [topDragButton.layer setBorderWidth:2.0f];
    [topDragButton.layer setCornerRadius:topDragButton.bounds.size.width / 2];
    [self addSubview:topDragButton];
    
    // Top Button Pan Gesture Recognizer
    UIPanGestureRecognizer *topButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerForTopButton:)];
    [topDragButton addGestureRecognizer:topButtonPanGestureRecognizer];
    
    [topDragButton makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(26));
        make.width.equalTo(@(26));
        make.right.equalTo(self.mas_right).with.offset(-30);
        make.top.equalTo(self.mas_top).with.offset(0);
    }];

    // Bottom Drag Button On Cell
    CGFloat xForBottomButton = widthForCell * 0.2 - widthForButton;
    CGFloat yForBottomButton = heightForCell - heightForButton / 2;
    
    bottomDragButton = [[UIButton alloc]initWithFrame:CGRectMake(xForBottomButton , yForBottomButton, widthForButton, heightForButton)];
    [bottomDragButton setTitle:@"" forState:UIControlStateNormal];
    [bottomDragButton setBackgroundColor:[UIColor whiteColor]];
    [bottomDragButton.layer setBorderColor:[UIColor colorWithHexString:@"e9466b"].CGColor];
    [bottomDragButton.layer setBorderWidth:2.0f];
    [bottomDragButton.layer setCornerRadius:bottomDragButton.bounds.size.width / 2];
    [self addSubview:bottomDragButton];
    
    [bottomDragButton makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(26));
        make.width.equalTo(@(26));
        make.left.equalTo(self.mas_left).with.offset(30);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    // Bottom Button Pan Gesture Recognizer
    UIPanGestureRecognizer *bottomButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerForBottomButton:)];
    [bottomDragButton addGestureRecognizer:bottomButtonPanGestureRecognizer];

    // Cell Pan Gesture Recognizer
    UIPanGestureRecognizer *cellPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerForCell:)];
    [self addGestureRecognizer:cellPanGestureRecognizer];
    
    return self;
}

-(void)setHourHeight:(CGFloat)hourHeight{
    if(hourHeight == 0){
         _hourHeight = 1;
    }else{
        _hourHeight = hourHeight;
    }
}



#pragma mark - UICollectionViewCell

//- (void)longPressGesture{
//    [self.delegate cellLongPressGesture:self];
//}

- (void)setSelected:(BOOL)selected{
//    if (selected && (self.selected != selected)) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.transform = CGAffineTransformMakeScale(1.025, 1.025);
//            self.layer.shadowOpacity = 0.2;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                self.transform = CGAffineTransformIdentity;
//            }];
//        }];
//    } else if (selected) {
//        self.layer.shadowOpacity = 0.2;
//    } else {
//        self.layer.shadowOpacity = 0.0;
//    }
    [super setSelected:selected]; // Must be here for animation to fire
//    [self updateColors];
}

#pragma mark - MSEventCell

- (void)setEvent:(USEvent *)event{
    _event = event;
}

-(void)addBorderLayer{
    
    CGFloat borderHeight = ([[UIScreen mainScreen] scale] == 2.0 ? 2.0f : 3.0f);
    topLayer = [CALayer layer];
    [topLayer setBounds:CGRectMake(0, 0, self.bounds.size.width, borderHeight)];
    [topLayer setPosition:CGPointMake(0, 0)];
    [topLayer setAnchorPoint:CGPointZero];
    [topLayer setCornerRadius:2.0f];
    [self.layer addSublayer:topLayer];
    
//    bottomLayer = [CALayer layer];
//    [bottomLayer setBounds:CGRectMake(0, 0, self.bounds.size.width, borderHeight / 2)];
//    [bottomLayer setPosition:CGPointMake(0, self.bounds.size.height - borderHeight / 2)];
//    [bottomLayer setAnchorPoint:CGPointZero];
//    [bottomLayer setCornerRadius:2.0f];
//    [self.layer addSublayer:bottomLayer];
    
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 4.0);
    self.layer.shadowRadius = 10.0;
    self.layer.shadowOpacity = 0.2;
}

- (void)updateColorsOrdered{
    self.contentView.backgroundColor = [self backgroundColorOrdered:self.isOrdered];
    if(topLayer){
        [topLayer setBackgroundColor:[self borderColorOrdered:self.isOrdered].CGColor];
        [topLayer setPosition: CGPointMake(0,0)];
    }
    
    [topDragButton.layer setBorderColor:[self dragButtonBorderColorOrdered:self.isOrdered].CGColor];
    [bottomDragButton.layer setBorderColor:[self dragButtonBorderColorOrdered:self.isOrdered].CGColor];
    [self setNeedsLayout];
}

- (void)updateColorsSelected{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.isSelected];
    if(topLayer){
        [topLayer setBackgroundColor:[self borderColorOrdered:NO].CGColor];
    }
    [self setNeedsLayout];
}

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0],
        NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
        NSParagraphStyleAttributeName : paragraphStyle
    };
}

- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName : [UIFont systemFontOfSize:12.0],
        NSForegroundColorAttributeName : [self textColorHighlighted:highlighted],
        NSParagraphStyleAttributeName : paragraphStyle
    };
}

- (UIColor *)backgroundColorHighlighted:(BOOL)selected{
    //item选中时的颜色
//    return selected ? [[UIColor colorWithHexString:@"32a46a"]  colorWithAlphaComponent:0.8]: [[UIColor colorWithHexString:@"63c191"] colorWithAlphaComponent:0.6];
    return selected ? [[UIColor colorWithHexString:@"e9466b"]  colorWithAlphaComponent:0.8]: [[UIColor colorWithHexString:@"e9466b"] colorWithAlphaComponent:0.6];
}

- (UIColor *)backgroundColorOrdered:(BOOL)ordered{
    //item选中时的颜色
//    return ordered ? [[UIColor colorWithHexString:@"ec8788"] colorWithAlphaComponent:0.8] : [[UIColor colorWithHexString:@"63c191"] colorWithAlphaComponent:0.6];
    return ordered ? [[UIColor colorWithHexString:@"595959"] colorWithAlphaComponent:0.5] : [[UIColor colorWithHexString:@"e9466b"] colorWithAlphaComponent:0.6];
}

- (UIColor *)dragButtonBorderColorOrdered:(BOOL)ordered{
    //item选中时的颜色
    return ordered ? [UIColor colorWithHexString:@"595959"] : [UIColor colorWithHexString:@"e9466b"];
}

- (UIColor *)borderColorOrdered:(BOOL)ordered{
    //item选中时的颜色
//    return ordered ? [[UIColor colorWithHexString:@"e35354"]  colorWithAlphaComponent:0.8] : [[UIColor colorWithHexString:@"1fa561"]  colorWithAlphaComponent:0.6];
    return ordered ? [[UIColor colorWithHexString:@"595959"]  colorWithAlphaComponent:0.5] : [[UIColor colorWithHexString:@"e9466b"]  colorWithAlphaComponent:0.6];
}

- (UIColor *)textColorHighlighted:(BOOL)selected{
    return selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"21729c"];
}

- (UIColor *)borderColor:(BOOL)ordered{
    return [[self backgroundColorHighlighted:NO] colorWithAlphaComponent:1.0];
}

#pragma mark - Pan Gesture Recognizer

// Top Button Gesture Recognizer
-(void)panGestureRecognizerForTopButton:(UIPanGestureRecognizer*)recognizer{
    UIView *view = recognizer.view;
    UIView *superView = view.superview;
    CGPoint translationPoint = [recognizer translationInView:superView];
    CGRect currentFrame = superView.frame;
    
    CGFloat translationY = 0;
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.startCellHeight = CGRectGetHeight(currentFrame);
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat newCellHeight = CGRectGetHeight(currentFrame);
        CGFloat offsetY = newCellHeight - self.startCellHeight;
        CGFloat scale = fmodf(offsetY, self.hourHeight) / self.hourHeight;
        NSInteger multiple = offsetY / self.hourHeight;
        if(scale > 0.5f){
            translationY = (multiple + 1) * self.hourHeight;
        }else if(scale < -0.5f){
            translationY = (multiple - 1) * self.hourHeight;
        }else{
            translationY = multiple * self.hourHeight;
        }
        translationY -=offsetY;
        CGRect newFrame = CGRectMake(CGRectGetMinX(currentFrame), CGRectGetMinY(currentFrame) -  translationY, CGRectGetWidth(currentFrame),CGRectGetHeight(currentFrame) + translationY);
        superView.frame = newFrame;
        // selected time span
        [self selectedTimeSpan:newFrame];
        // reset background color
         [self updateBackground:self.startTimeNumber andTimeSpan:self. timeSpan];
    }else{
        translationY = -translationPoint.y;
        CGFloat currentHeight = CGRectGetHeight(currentFrame) + translationY;
        CGFloat currentMinY = CGRectGetMinY(currentFrame) + translationY;
        NSLog(@"%f,%f",currentMinY,self.topGuideline);
        if(currentHeight >= self.hourHeight * 2 && currentMinY >= self.topGuideline){
            CGRect newFrame = CGRectMake(CGRectGetMinX(currentFrame), CGRectGetMinY(currentFrame) -  translationY, CGRectGetWidth(currentFrame),currentHeight);
            superView.frame = newFrame;
            // selected time span
            [self selectedTimeSpan:newFrame];
        }
    }
    
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

// Bottom Button Gesture Recognizer
-(void)panGestureRecognizerForBottomButton:(UIPanGestureRecognizer*)recognizer{
    UIView *view = recognizer.view;
    UIView *superView = view.superview;
    CGPoint translationPoint = [recognizer translationInView:superView];
    CGRect currentFrame = superView.frame;
    
    CGFloat translationY = 0;
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.startCellHeight = CGRectGetHeight(currentFrame);
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat newCellHeight = CGRectGetHeight(currentFrame);
        CGFloat offsetY = newCellHeight - self.startCellHeight;
        CGFloat scale = fmodf(offsetY, self.hourHeight) / self.hourHeight;
        NSInteger multiple = offsetY / self.hourHeight;
        if(scale > 0.5f){
            translationY = (multiple + 1) * self.hourHeight;
        }else if(scale < -0.5f){
            translationY = (multiple - 1) * self.hourHeight;
        }else{
            translationY = multiple * self.hourHeight;
        }
        translationY -=offsetY;
        
        CGRect newFrame = CGRectMake(CGRectGetMinX(currentFrame), CGRectGetMinY(currentFrame), CGRectGetWidth(currentFrame), CGRectGetHeight(currentFrame) + translationY);
        superView.frame = newFrame;
        
        // selected time span
        [self selectedTimeSpan:newFrame];
        // reset background color
         [self updateBackground:self.startTimeNumber andTimeSpan:self. timeSpan];
    }else{
        translationY = translationPoint.y;
        CGFloat currentHeight = CGRectGetHeight(currentFrame) + translationY;
        CGFloat currentMaxY = CGRectGetMaxY(currentFrame) + translationY;
        if(currentHeight >= self.hourHeight * 2 && currentMaxY <= self.bottomGuideline){
            CGRect newFrame = CGRectMake(CGRectGetMinX(currentFrame), CGRectGetMinY(currentFrame), CGRectGetWidth(currentFrame), currentHeight);
            superView.frame = newFrame;
            
            // selected time span
            [self selectedTimeSpan:newFrame];
        }
    }
    
    [recognizer setTranslation:CGPointZero inView:view.superview];
}

// Cell Gesture Recognizer
-(void)panGestureRecognizerForCell:(UIPanGestureRecognizer*)recognizer{
    // self view
    UIView *view = recognizer.view;
    // super view
    UIView *superView = view.superview;
    // translation
    CGPoint translationPoint = [recognizer translationInView:superView];
    CGPoint currentCellCenter = view.center;
    
    CGFloat translationY = 0;
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.startCellCenter = currentCellCenter;
        if([superView isKindOfClass:[UICollectionView class]] == YES){
            UICollectionView *superView = (UICollectionView*)self.superview;
            superView.scrollEnabled = NO;
        }
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat offsetY = currentCellCenter.y - self.startCellCenter.y;
        CGFloat scaleY = fmodf(offsetY, self.hourHeight) / self.hourHeight;
        NSInteger multipleY = offsetY / self.hourHeight;
        if(scaleY > 0.5f){
            translationY = (multipleY + 1) * self.hourHeight;
        }else if(scaleY < -0.5f){
            translationY = (multipleY - 1) * self.hourHeight;
        }else{
            translationY = multipleY * self.hourHeight;
        }
        translationY -=offsetY;
        
        if([superView isKindOfClass:[UICollectionView class]] == YES){
            UICollectionView *superView = (UICollectionView*)self.superview;
            superView.scrollEnabled = YES;
        }
        self.startCellCenter = CGPointZero;
        self.selected = NO;
        
        // reset center
        view.center = CGPointMake(currentCellCenter.x, currentCellCenter.y + translationY);
        
        // selected time span
        [self selectedTimeSpan:view.frame];
        
        // reset background color
         [self updateBackground:self.startTimeNumber andTimeSpan:self. timeSpan];
    }else{
        translationY = translationPoint.y;
        CGFloat currentMinY = CGRectGetMinY(view.frame) + translationY;
        CGFloat currentMaxY = CGRectGetMaxY(view.frame) + translationY;
//        CGFloat topGuideline = self.collectionViewContentMargin.top + self.collectionViewSectionMargin.top;
//        CGFloat bottomGuideline = CGRectGetHeight(view.superview.frame) - self.collectionViewContentMargin.bottom - self.collectionViewSectionMargin.bottom;
        if(currentMinY >= self.topGuideline && currentMaxY <= self.bottomGuideline){
            // reset center
            view.center = CGPointMake(currentCellCenter.x, currentCellCenter.y + translationY);
            
            // selected time span
            [self selectedTimeSpan:view.frame];
        }
        NSLog(@"max Y : %f,%f",currentMaxY,CGRectGetMaxY(superView.frame));
        if(currentMaxY > CGRectGetMaxY(superView.frame)){
            UICollectionView *collectionView = (UICollectionView*)superView;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:20 inSection:0];
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }
    }
    
    [recognizer setTranslation:CGPointZero inView:superView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.selected = YES;
    [self updateColorsSelected];
    NSLog(@"touchesBegan");
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.selected = NO;
    [self updateColorsSelected];
    NSLog(@"touchesEnded");
}

// Selected Time Span
-(void)selectedTimeSpan:(CGRect)frame{
    CGFloat minY = CGRectGetMinY(frame);
    CGFloat maxY = CGRectGetMaxY(frame);
    
    CGFloat collectionViewContentMarginTop = self.collectionViewContentMargin.top;
    CGFloat collectionViewSectionMarginTop = self.collectionViewSectionMargin.top;
    CGFloat startTimeY = minY - collectionViewContentMarginTop - collectionViewSectionMarginTop;
    self.startTimeNumber = startTimeY / self.hourHeight;
    self. timeSpan = (maxY - minY) / self.hourHeight;
    
    if(self.delegate){
        [self.delegate updateSelectedTimeSpan:self.startTimeNumber withTimeSpan:self.timeSpan];
    }
}

-(void)updateBackground:(NSInteger)startTimeNumber andTimeSpan:(NSInteger)timeSpan{
    if(self.calendarLayoutDelegate){
        NSArray *orderedTimeSpanArray = [self.calendarLayoutDelegate orderedTimeSpanForCollectionView:nil layout:nil];
        NSInteger endTimeNumber = startTimeNumber + timeSpan;
        BOOL isOrdered = NO;
        for (NSInteger i = 0; i < [orderedTimeSpanArray count]; i++) {
            NSInteger timeNumber = [[orderedTimeSpanArray objectAtIndex:i] integerValue];
            if(timeNumber >= startTimeNumber && timeNumber < endTimeNumber){
                isOrdered = YES;
                continue;
            }
        }
        
        self.isOrdered = isOrdered;
        [self updateColorsOrdered];
    }
}

@end
