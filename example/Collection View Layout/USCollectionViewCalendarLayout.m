//
//  USCollectionViewCalendarLayout.m
//  example
//
//  Created by 赵兴满 on 16/1/25.
//  Copyright © 2016年 zhaoxingman. All rights reserved.
//

#import "USCollectionViewCalendarLayout.h"

// Added
NSString * const USCollectionElementKindTimeRowBodyBackground = @"USCollectionElementKindTimeRowBodyBackground";

NSString * const USCollectionElementKindTimeRowHeader = @"USCollectionElementKindTimeRow";
NSString * const USCollectionElementKindDayColumnHeader = @"USCollectionElementKindDayHeader";
NSString * const USCollectionElementKindTimeRowHeaderBackground = @"USCollectionElementKindTimeRowHeaderBackground";
NSString * const USCollectionElementKindDayColumnHeaderBackground = @"USCollectionElementKindDayColumnHeaderBackground";
NSString * const USCollectionElementKindCurrentTimeIndicator = @"USCollectionElementKindCurrentTimeIndicator";
NSString * const USCollectionElementKindCurrentTimeHorizontalGridline = @"USCollectionElementKindCurrentTimeHorizontalGridline";
NSString * const USCollectionElementKindVerticalGridline = @"USCollectionElementKindVerticalGridline";
NSString * const USCollectionElementKindHorizontalGridline = @"USCollectionElementKindHorizontalGridline";

NSUInteger const USCollectionMinOverlayZ = 1000.0; // Allows for 900 items in a sectio without z overlap issues
NSUInteger const USCollectionMinCellZ = 100.0;  // Allows for 100 items in a section's background
NSUInteger const USCollectionMinBackgroundZ = 0.0;

@interface MSTimerWeakTarget : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
- (SEL)fireSelector;
@end

@implementation MSTimerWeakTarget
- (id)initWithTarget:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
    }
    return self;
}
- (void)fire:(NSTimer*)timer
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:timer];
#pragma clang diagnostic pop
}
- (SEL)fireSelector
{
    return @selector(fire:);
}
@end

@interface USCollectionViewCalendarLayout ()

// Minute Timer
@property (nonatomic, strong) NSTimer *minuteTimer;

// Caches
@property (nonatomic, assign) BOOL needsToPopulateAttributesForAllSections;
@property (nonatomic, assign) CGFloat cachedMaxSectionHeight;

// Added
@property(nonatomic,assign) NSTimeInterval cachedTimeInterval;
@property(nonatomic,strong) NSMutableDictionary *cachedStartTimeDate;
@property(nonatomic,strong) NSMutableDictionary *cachedEndTimeDate;
@property(nonatomic,strong) NSMutableDictionary *cachedDefaultSelectedTimeDate;

// Registered Decoration Classes
@property (nonatomic, strong) NSMutableDictionary *registeredDecorationClasses;

// Attributes
@property (nonatomic, strong) NSMutableArray *allAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
//@property (nonatomic, strong) NSMutableDictionary *dayColumnHeaderAttributes;
//@property (nonatomic, strong) NSMutableDictionary *dayColumnHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *horizontalGridlineAttributes;
@property (nonatomic, strong) NSMutableDictionary *verticalGridlineAttributes;
//@property (nonatomic, strong) NSMutableDictionary *currentTimeIndicatorAttributes;
//@property (nonatomic, strong) NSMutableDictionary *currentTimeHorizontalGridlineAttributes;

// Added
@property (nonatomic, strong) NSMutableDictionary *timeRowBodyBackgroundAttributes;


- (void)initialize;
// Layout
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache;
- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache;

// Scrolling
- (NSInteger)closestSectionToCurrentTime;

// Section Sizing
- (CGRect)rectForSection:(NSInteger)section;
- (CGFloat)maxSectionHeight;
- (CGFloat)stackedSectionHeight;
- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection;
- (CGFloat)sectionHeight:(NSInteger)section;
- (CGFloat)minuteHeight;

// Z Index
- (CGFloat)zIndexForElementKind:(NSString *)elementKind;
- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating;

// Hours
- (NSInteger)earliestHour;
- (NSInteger)latestHour;
- (NSInteger)earliestHourForSection:(NSInteger)section;
- (NSInteger)latestHourForSection:(NSInteger)section;

// Delegate Wrappers
- (NSDateComponents *)dayForSection:(NSInteger)section;
//- (NSDateComponents *)startTimeForIndexPath:(NSIndexPath *)indexPath;
//- (NSDateComponents *)endTimeForIndexPath:(NSIndexPath *)indexPath;
//- (NSDateComponents *)currentTimeDateComponents;

- (NSDateComponents *)startTimeForSection:(NSInteger)section;
- (NSDateComponents *)endTimeForSection:(NSInteger)section;

@end
@implementation USCollectionViewCalendarLayout

- (void)dealloc
{
    [self.minuteTimer invalidate];
    self.minuteTimer = nil;
}

-(id)init{
    self=[super init];
    if(self){
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
//    NSLog(@"-------------------------prepareForCollectionViewUpdates:%d",[updateItems count]);
    [self invalidateLayoutCache];
    
    // Update the layout with the new items
    [self prepareLayout];
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)finalizeCollectionViewUpdates
{
//    NSLog(@"-------------------------finalizeCollectionViewUpdates");
    
    // This is a hack to prevent the error detailed in :
    // http://stackoverflow.com/questions/12857301/uicollectionview-decoration-and-supplementary-views-can-not-be-moved
    // If this doesn't happen, whenever the collection view has batch updates performed on it, we get multiple instantiations of decoration classes
    for (UIView *subview in self.collectionView.subviews) {
        for (Class decorationViewClass in self.registeredDecorationClasses.allValues) {
            if ([subview isKindOfClass:decorationViewClass]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)decorationViewKind
{
//    NSLog(@"-------------------------registerClass forDecorationViewOfKind:%@",decorationViewKind);
    [super registerClass:viewClass forDecorationViewOfKind:decorationViewKind];
    self.registeredDecorationClasses[decorationViewKind] = viewClass;
}


- (void)prepareLayout
{
//    NSLog(@"-------------------------prepareLayout");
    [super prepareLayout];
    
    if (self.needsToPopulateAttributesForAllSections) {
        [self prepareSectionLayoutForSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
        self.needsToPopulateAttributesForAllSections = NO;
    }
    
    BOOL needsToPopulateAllAttribtues = (self.allAttributes.count == 0);
    if (needsToPopulateAllAttribtues) {
        [self.allAttributes addObjectsFromArray:[self.timeRowHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.timeRowHeaderBackgroundAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.verticalGridlineAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.horizontalGridlineAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.itemAttributes allValues]];
        
        // Added
        [self.allAttributes addObjectsFromArray:[self.timeRowBodyBackgroundAttributes allValues]];
    }
}

- (void)prepareSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
//    NSLog(@"-------------------------prepareSectionLayoutForSections");
    switch (self.sectionLayoutType) {
        case USSectionLayoutTypeHorizontalTile:
            [self prepareHorizontalTileSectionLayoutForSections:sectionIndexes];
            break;
        case USSectionLayoutTypeVerticalTile:
            //            [self prepareVerticalTileSectionLayoutForSections:sectionIndexes];
            break;
    }
}

- (void)prepareHorizontalTileSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    BOOL needsToPopulateItemAttributes = (self.itemAttributes.count == 0);
    BOOL needsToPopulateVerticalGridlineAttributes = (self.verticalGridlineAttributes.count == 0);
    
    // grid line min x
    CGFloat calendarGridMinX = (self.sectionMargin.left + self.timeRowHeaderWidth);
    // grid line min y
    CGFloat calendarGridMinY = self.sectionMargin.top;
    
    // calendar grid height
    NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:0];
    CGFloat calendarGridHeight = numberOfItemsInSection * self.hourHeight;
    
    // section height
    CGFloat sectionHeight = calendarGridHeight + self.sectionMargin.top + self.sectionMargin.bottom;
    
    // Time Row Header
    CGFloat timeRowHeaderMinX = fmaxf(self.collectionView.contentOffset.x, 0.0) + self.sectionMargin.left;
    BOOL timeRowHeaderFloating = ((timeRowHeaderMinX != 0) || self.displayHeaderBackgroundAtOrigin);
    
    // Time Row Header Background
    NSIndexPath *timeRowHeaderBackgroundIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *timeRowHeaderBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:timeRowHeaderBackgroundIndexPath ofKind:USCollectionElementKindTimeRowHeaderBackground withItemCache:self.timeRowHeaderBackgroundAttributes];
    
    // Frame
    CGFloat timeRowHeaderBackgroundHeight = calendarGridHeight + self.hourHeight;
    CGFloat timeRowHeaderBackgroundWidth = self.timeRowHeaderWidth;
    CGFloat timeRowHeaderBackgroundMinX = self.sectionMargin.left;
    CGFloat timeRowHeaderBackgroundMinY = self.sectionMargin.top - nearbyintf(self.hourHeight / 2.0);
    
    timeRowHeaderBackgroundAttributes.frame = CGRectMake(timeRowHeaderBackgroundMinX, timeRowHeaderBackgroundMinY, timeRowHeaderBackgroundWidth, timeRowHeaderBackgroundHeight);
    
    // Floating
    timeRowHeaderBackgroundAttributes.hidden = !timeRowHeaderFloating;
    timeRowHeaderBackgroundAttributes.zIndex = [self zIndexForElementKind:USCollectionElementKindTimeRowHeaderBackground floating:timeRowHeaderFloating];
    
    // Time Row Headers
    for (NSInteger item = 0; item <= numberOfItemsInSection; item++) {
        NSIndexPath *timeRowHeaderIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *timeRowHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:timeRowHeaderIndexPath ofKind:USCollectionElementKindTimeRowHeader withItemCache:self.timeRowHeaderAttributes];
        
        CGFloat titleRowHeaderMinY = calendarGridMinY + self.hourHeight * item - nearbyintf(self.hourHeight / 2.0);
        timeRowHeaderAttributes.frame = CGRectMake(timeRowHeaderMinX, titleRowHeaderMinY, self.timeRowHeaderWidth, self.hourHeight);
        timeRowHeaderAttributes.zIndex = [self zIndexForElementKind:USCollectionElementKindTimeRowHeader floating:timeRowHeaderFloating];
        timeRowHeaderAttributes.hidden = (item % 2 != 0);
    }
    
    // Time Row Body Background
    NSArray *orderedTimeSpanData = [self.delegate orderedTimeSpanForCollectionView:self.collectionView layout:self];
    
    for (NSInteger item = 0; item <= numberOfItemsInSection; item++) {
        NSIndexPath *timeRowBodyBackgroundIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        UICollectionViewLayoutAttributes *timeRowBodyBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:timeRowBodyBackgroundIndexPath ofKind:USCollectionElementKindTimeRowBodyBackground withItemCache:self.timeRowBodyBackgroundAttributes];
        
        //        CGFloat timeRowBodyBackgroundMinY = (calendarContentMinY + (self.hourHeight * item) - nearbyintf(self.hourHeight / 2.0));
        CGFloat timeRowBodyBackgroundMinX = calendarGridMinX;
        CGFloat timeRowBodyBackgroundMinY = calendarGridMinY + self.hourHeight * (item);
        CGFloat timeRowBodyBackgroundWidth = self.calendarGridWidth;
        
        timeRowBodyBackgroundAttributes.frame = CGRectMake(timeRowBodyBackgroundMinX, timeRowBodyBackgroundMinY, timeRowBodyBackgroundWidth, self.hourHeight);
        timeRowBodyBackgroundAttributes.zIndex = [self zIndexForElementKind:USCollectionElementKindTimeRowBodyBackground floating:timeRowHeaderFloating];
        
        timeRowBodyBackgroundAttributes.hidden = ![orderedTimeSpanData containsObject:[NSNumber numberWithInteger:item]];
    }
    
//    if(needsToPopulateVerticalGridlineAttributes == YES){
//        for (NSInteger item = 0; item <= numberOfItemsInSection; item++) {
//            
//            NSIndexPath *verticalGridlineIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
//            UICollectionViewLayoutAttributes *verticalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:verticalGridlineIndexPath ofKind:USCollectionElementKindVerticalGridline withItemCache:self.verticalGridlineAttributes];
//            
//            CGFloat verticalGridlineMinX = nearbyintf(calendarGridMinX - self.verticalGridlineWidth / 2.0);
//            CGFloat verticalGridlineMinY = self.sectionMargin.top - self.hourHeight / 2.0 + self.hourHeight * item;
//            CGFloat verticalGridlineHeight = self.hourHeight;
//            verticalGridlineAttributes.frame = CGRectMake(verticalGridlineMinX, verticalGridlineMinY, self.verticalGridlineWidth, verticalGridlineHeight);
//            
//            BOOL isOrdered = [orderedTimeSpanData containsObject:[NSNumber numberWithInteger:item]];
//            if(isOrdered == YES){
//            }
//        }
//    }

    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        if (needsToPopulateVerticalGridlineAttributes) {
            // Vertical Gridline
            NSIndexPath *verticalGridlineIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes *verticalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:verticalGridlineIndexPath ofKind:USCollectionElementKindVerticalGridline withItemCache:self.verticalGridlineAttributes];
            
            CGFloat verticalGridlineMinX = nearbyintf(calendarGridMinX - self.verticalGridlineWidth / 2.0);
            CGFloat verticalGridlineMinY = self.sectionMargin.top - self.hourHeight / 2.0;
            CGFloat verticalGridlineHeight = sectionHeight - self.sectionMargin.top - self.sectionMargin.bottom + self.hourHeight;
            verticalGridlineAttributes.frame = CGRectMake(verticalGridlineMinX, verticalGridlineMinY, self.verticalGridlineWidth, verticalGridlineHeight);
        }
        
        if (needsToPopulateItemAttributes) {
            // Items
            NSMutableArray *sectionItemAttributes = [NSMutableArray new];
            
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForCellAtIndexPath:itemIndexPath withItemCache:self.itemAttributes];
            [sectionItemAttributes addObject:itemAttributes];
            
//            NSDate *startTimeForSection = [self startTimeForSection:section];
//            NSDate *defaultSelectedTimeForSection = [self defaultSelectedTimeForSection:section];
//            NSTimeInterval timeSpan = [self.delegate collectionView:self.collectionView layout:self];
//            NSTimeInterval defaultSelectedTimeSpan = [defaultSelectedTimeForSection timeIntervalSinceDate:startTimeForSection];
    
            
            CGFloat defaultSelectedTimeMinX = calendarGridMinX;
            CGFloat defaultSelectedTimeMinY = self.sectionMargin.top + self.cachedSelectedTimeNumber * self.hourHeight;
            
            CGFloat defaultSelectedTimeWidth = self.calendarGridWidth;
            CGFloat defaultSelectedTimeHeight = self.cachedSelectedTimeSpan * self.hourHeight;

            itemAttributes.frame = CGRectMake(defaultSelectedTimeMinX, defaultSelectedTimeMinY, defaultSelectedTimeWidth, defaultSelectedTimeHeight);

            itemAttributes.zIndex = [self zIndexForElementKind:nil];

            
//            [self adjustItemsForOverlap:sectionItemAttributes inSection:section sectionMinX:sectionMinX];
        }
    }];
    
    // Horizontal Gridlines
    for (NSInteger item = 0; item <= numberOfItemsInSection; item++) {

        NSIndexPath *horizontalGridlineIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:horizontalGridlineIndexPath ofKind:USCollectionElementKindHorizontalGridline withItemCache:self.horizontalGridlineAttributes];
        
        CGFloat horizontalGridlineMinX = calendarGridMinX;
        CGFloat horizontalGridlineMinY = nearbyintf(calendarGridMinY + self.hourHeight * item - self.horizontalGridlineHeight / 2.0);
        CGFloat horizontalGridlineWidth = 6.0f;
        if(item % 2 == 0){
            horizontalGridlineWidth = self.calendarGridWidth;
        }
        horizontalGridlineAttributes.frame = CGRectMake(horizontalGridlineMinX, horizontalGridlineMinY, horizontalGridlineWidth, self.horizontalGridlineHeight);
//        horizontalGridlineAttributes.hidden = (item % 2 != 0);
    }
}

- (CGSize)collectionViewContentSize
{
//    NSLog(@"-------------------------collectionViewContentSize");
    CGFloat width;
    CGFloat height;
    switch (self.sectionLayoutType) {
        case USSectionLayoutTypeHorizontalTile:
            height = [self maxSectionHeight];
            width = self.collectionView.frame.size.width;
            break;
        case USSectionLayoutTypeVerticalTile:
//            height = [self stackedSectionHeight];
//            width = (self.timeRowHeaderWidth + self.contentMargin.left + self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right + self.contentMargin.right);
            break;
    }
    return CGSizeMake(width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableIndexSet *visibleSections = [NSMutableIndexSet indexSet];
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        CGRect sectionRect = [self rectForSection:section];
        if (CGRectIntersectsRect(sectionRect, rect)) {
            [visibleSections addIndex:section];
        }
    }];
    
    // Update layout for only the visible sections
    [self prepareSectionLayoutForSections:visibleSections];
    
    // Return the visible attributes (rect intersection)
    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    NSLog(@"-------------------------shouldInvalidateLayoutForBoundsChange(x,y,w,h):%f,%f,%f,%f", newBounds.origin.x,newBounds.origin.y,newBounds.size.width,newBounds.size.height);
    // Required for sticky headers
    CGRect oldBounds = self.collectionView.bounds;
    if(CGRectGetWidth(oldBounds) == CGRectGetWidth(newBounds)){
        return NO;
    }else{
        return YES;
    }
}


#pragma mark Section Sizing

- (CGRect)rectForSection:(NSInteger)section
{
//    NSLog(@"-------------------------rectForSection:%d", section);
    CGRect sectionRect;
    switch (self.sectionLayoutType) {
        case USSectionLayoutTypeHorizontalTile: {
            sectionRect = CGRectMake(0.0, 0.0, self.collectionViewContentSize.width, self.collectionViewContentSize.height);
            break;
        }
        case USSectionLayoutTypeVerticalTile: {
//            CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
//            CGFloat nextColumnMinY = (section == self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
//            sectionRect = CGRectMake(0.0, columnMinY, self.collectionViewContentSize.width, (nextColumnMinY - columnMinY));
            break;
        }
    }
    return sectionRect;
}

-(CGFloat)maxSectionHeight{
    if(self.cachedMaxSectionHeight != CGFLOAT_MIN){
        return self.cachedMaxSectionHeight;
    }
    
    CGFloat maxSectionHeight = 0.0;
    for(NSInteger section = 0 ; section < self.collectionView.numberOfSections;section++){
        CGFloat sectionHeight = 0.0;
        
        sectionHeight = [self.collectionView numberOfItemsInSection:section] * self.hourHeight;
        if(sectionHeight > maxSectionHeight){
            maxSectionHeight = sectionHeight;
        }
    }
    
    CGFloat headerAdjustedMaxSectionHeight = ( self.sectionMargin.top + maxSectionHeight + self.sectionMargin.bottom );
    if (maxSectionHeight != 0.0) {
        self.cachedMaxSectionHeight = headerAdjustedMaxSectionHeight;
        return headerAdjustedMaxSectionHeight;
    } else {
        return headerAdjustedMaxSectionHeight;
    }
}

// default Date
- (NSDate *)defaultSelectedTimeForSection:(NSInteger)section
{
    if ([self.cachedDefaultSelectedTimeDate objectForKey:@(section)]) {
        return [self.cachedDefaultSelectedTimeDate objectForKey:@(section)];
    }
    
    NSDate *date = [self.delegate collectionView:self.collectionView layout:self dayForSection:section];
    [self.cachedDefaultSelectedTimeDate setObject:date forKey:@(section)];
    return date;
}

// Start Date
- (NSDate *)startTimeForSection:(NSInteger)section
{
    if ([self.cachedStartTimeDate objectForKey:@(section)]) {
        return [self.cachedStartTimeDate objectForKey:@(section)];
    }
    
    NSDate *date = [self.delegate collectionView:self.collectionView layout:self startTimeForItemAtIndexPath:section];
    [self.cachedStartTimeDate setObject:date forKey:@(section)];
    return date;
}

// End Date
- (NSDate *)endTimeForSection:(NSInteger)section
{
    if ([self.cachedEndTimeDate objectForKey:@(section)]) {
        return [self.cachedEndTimeDate objectForKey:@(section)];
    }
    
    NSDate *date = [self.delegate collectionView:self.collectionView layout:self endTimeForItemAtIndexPath:section];
    [self.cachedEndTimeDate setObject:date forKey:@(section)];
    return date;
}

-(NSTimeInterval)timeIntervalForSection:(NSInteger)section{
    if(self.cachedTimeInterval != CGFLOAT_MIN){
        return self.cachedTimeInterval;
    }
    
    NSTimeInterval timeSpan = [self.delegate collectionView:self.collectionView layout:self];
    if(timeSpan != CGFLOAT_MIN){
        self.cachedTimeInterval= timeSpan;
    }else{
        timeSpan = 0;
        self.cachedTimeInterval= timeSpan;
    }
    return timeSpan;
}

- (void)invalidateLayoutCache
{
    self.needsToPopulateAttributesForAllSections = YES;
    
    // Invalidate cached Components
    
    // Invalidate cached interface sizing values
    self.cachedMaxSectionHeight = CGFLOAT_MIN;
    self.cachedTimeInterval = CGFLOAT_MIN;
    
    // Invalidate cached item attributes
    [self.itemAttributes removeAllObjects];
    [self.verticalGridlineAttributes removeAllObjects];
    [self.horizontalGridlineAttributes removeAllObjects];
    [self.timeRowHeaderAttributes removeAllObjects];
    [self.timeRowHeaderBackgroundAttributes removeAllObjects];
    [self.allAttributes removeAllObjects];
    
    // Added
    [self.timeRowBodyBackgroundAttributes removeAllObjects];
    [self.cachedStartTimeDate removeAllObjects];
    [self.cachedEndTimeDate removeAllObjects];
    [self.cachedDefaultSelectedTimeDate removeAllObjects];
}

#pragma mark Dates

- (NSDate *)dateForTimeRowHeaderAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"-------------------------dateForTimeRowHeaderAtIndexPath:%d",indexPath.item);
    
    NSDate *startDate = [self startTimeForSection:indexPath.section];
    NSTimeInterval timeSpan = [self timeIntervalForSection:indexPath.section];
    NSDate *date = [startDate dateByAddingTimeInterval:indexPath.item * timeSpan];
//    NSLog(@"date:%@, timeSpan:%f",startDate,timeSpan);
    return date;
}

#pragma mark - Layout

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (self.registeredDecorationClasses[kind] && !(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

#pragma mark - MSCollectionViewCalendarLayout

- (void)initialize
{
//    NSLog(@"-------------------------initialize");
    self.needsToPopulateAttributesForAllSections = YES;
    self.cachedMaxSectionHeight = CGFLOAT_MIN;
    
    // Added
    self.cachedTimeInterval = CGFLOAT_MIN;
    self.registeredDecorationClasses = [NSMutableDictionary new];
    
    self.allAttributes = [NSMutableArray new];
    self.itemAttributes = [NSMutableDictionary new];
    self.timeRowHeaderAttributes = [NSMutableDictionary new];
    self.timeRowHeaderBackgroundAttributes = [NSMutableDictionary new];
    self.verticalGridlineAttributes = [NSMutableDictionary new];
    self.horizontalGridlineAttributes = [NSMutableDictionary new];
    
    self.hourHeight = (([[UIScreen mainScreen] scale] == 2.0) ? 16.0 : 20.0);
//    self.sectionWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 194.0 : 254.0);
    
    // section margin
    self.sectionMargin = UIEdgeInsetsMake(self.hourHeight / 2.0, 0.0, 10.0, 0.0);
    
     self.timeRowHeaderWidth = (([[UIScreen mainScreen] scale] == 2.0) ? 50.0 : 56.0);
    self.sectionWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 194.0 : kScreenWidth - self.timeRowHeaderWidth);
    self.calendarGridWidth = kScreenWidth - self.sectionMargin.left - self.timeRowHeaderWidth - self.sectionMargin.right;
    
    self.verticalGridlineWidth = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : 1.0);
    self.horizontalGridlineHeight = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : 1.0);
    
    self.displayHeaderBackgroundAtOrigin = YES;
    self.sectionLayoutType = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? USSectionLayoutTypeHorizontalTile : USSectionLayoutTypeVerticalTile);
    self.headerLayoutType = USHeaderLayoutTypeDayColumnAboveTimeRow;
    
    // Invalidate layout on minute ticks (to update the position of the current time indicator)
    NSDate *oneMinuteInFuture = [[NSDate date] dateByAddingTimeInterval:60];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:oneMinuteInFuture];
    NSDate *nextMinuteBoundary = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    // This needs to be a weak reference, otherwise we get a retain cycle
    MSTimerWeakTarget *timerWeakTarget = [[MSTimerWeakTarget alloc] initWithTarget:self selector:@selector(minuteTick:)];
    self.minuteTimer = [[NSTimer alloc] initWithFireDate:nextMinuteBoundary interval:5 target:timerWeakTarget selector:timerWeakTarget.fireSelector userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.minuteTimer forMode:NSDefaultRunLoopMode];
    
    // Added
    self.timeRowBodyBackgroundAttributes = [NSMutableDictionary new];
    self.cachedStartTimeDate = [NSMutableDictionary new];
    self.cachedEndTimeDate = [NSMutableDictionary new];
    self.cachedDefaultSelectedTimeDate = [NSMutableDictionary new];
    
    self.cachedSelectedTimeNumber = 2;
    self.cachedSelectedTimeSpan = 4;
}

#pragma mark Minute Updates

- (void)minuteTick:(id)sender
{
    NSLog(@"-------------------------minuteTick");
    // Invalidate cached current date componets (since the minute's changed!)
//    [self.cachedCurrentDateComponents removeAllObjects];
//    [self invalidateLayout];
}

#pragma mark Z Index

- (CGFloat)zIndexForElementKind:(NSString *)elementKind
{
    return [self zIndexForElementKind:elementKind floating:NO];
}

- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating
{
    //    NSLog(@"-------------------------zIndexForElementKind:%@",elementKind);
    switch (self.sectionLayoutType) {
        case USSectionLayoutTypeHorizontalTile: {
            // Current Time Indicator
            if (elementKind == USCollectionElementKindCurrentTimeIndicator) {
                return (USCollectionMinOverlayZ + ((self.headerLayoutType == USHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 9.0 : 4.0) : (floating ? 7.0 : 2.0)));
            }
            // Time Row Header
            else if (elementKind == USCollectionElementKindTimeRowHeader) {
                return (USCollectionMinOverlayZ + ((self.headerLayoutType == USHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 8.0 : 3.0) : (floating ? 6.0 : 1.0)));
            }
            // Time Row Header Background
            else if (elementKind == USCollectionElementKindTimeRowHeaderBackground) {
                return (USCollectionMinOverlayZ + ((self.headerLayoutType == USHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 7.0 : 2.0) : (floating ? 5.0 : 0.0)));
            }
            // Time Row Body Background
            else if (elementKind == USCollectionElementKindTimeRowBodyBackground) {
                return USCollectionMinBackgroundZ;
            }
            // Day Column Header
            else if (elementKind == USCollectionElementKindDayColumnHeader) {
                return (USCollectionMinOverlayZ + ((self.headerLayoutType == USHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 6.0 : 1.0) : (floating ? 9.0 : 4.0)));
            }
            // Day Column Header Background
            else if (elementKind == USCollectionElementKindDayColumnHeaderBackground) {
                return (USCollectionMinOverlayZ + ((self.headerLayoutType == USHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 5.0 : 0.0) : (floating ? 8.0 : 3.0)));
            }
            // Cell
            else if (elementKind == nil) {
//                return USCollectionMinCellZ;
                return USCollectionMinCellZ;
            }
            // Current Time Horizontal Gridline
            else if (elementKind == USCollectionElementKindCurrentTimeHorizontalGridline) {
                return (USCollectionMinBackgroundZ + 3.0);
            }
            // Vertical Gridline
            else if (elementKind == USCollectionElementKindVerticalGridline) {
                return (USCollectionMinBackgroundZ + 2.0);
            }
            // Horizontal Gridline
            else if (elementKind == USCollectionElementKindHorizontalGridline) {
                return USCollectionMinBackgroundZ + 1.0;
            }
        }
        case USSectionLayoutTypeVerticalTile: {
            // Day Column Header
            if (elementKind == USCollectionElementKindDayColumnHeader) {
                return (USCollectionMinOverlayZ + (floating ? 6.0 : 4.0));
            }
            // Day Column Header Background
            else if (elementKind == USCollectionElementKindDayColumnHeaderBackground) {
                return (USCollectionMinOverlayZ + (floating ? 5.0 : 3.0));
            }
            // Current Time Indicator
            else if (elementKind == USCollectionElementKindCurrentTimeIndicator) {
                return (USCollectionMinOverlayZ + 2.0);
            }
            // Time Row Header
            if (elementKind == USCollectionElementKindTimeRowHeader) {
                return (USCollectionMinOverlayZ + 1.0);
            }
            // Time Row Header Background
            else if (elementKind == USCollectionElementKindTimeRowHeaderBackground) {
                return USCollectionMinOverlayZ;
            }
            // Cell
            else if (elementKind == nil) {
                return USCollectionMinCellZ;
            }
            // Current Time Horizontal Gridline
            else if (elementKind == USCollectionElementKindCurrentTimeHorizontalGridline) {
                return (USCollectionMinBackgroundZ + 1.0);
            }
            // Horizontal Gridline
            else if (elementKind == USCollectionElementKindHorizontalGridline) {
                return USCollectionMinBackgroundZ;
            }
        }
    }
    return CGFLOAT_MIN;
}

-(CGFloat)topGuideline{
    _topGuideline = self.sectionMargin.top;
    NSLog(@"%f",_topGuideline);
    return _topGuideline;
}

-(CGFloat)bottomGuideline{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    _bottomGuideline = self.hourHeight * numberOfItems + self.sectionMargin.top;
    NSLog(@"%f",_bottomGuideline);
    return _bottomGuideline;
}


@end
