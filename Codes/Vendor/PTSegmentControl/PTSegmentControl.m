//
//  PTSegmentControl.m
//  SOKit
//
//  Created by soso on 13-2-21.
//  Copyright (c) 2013-2015 soso. All rights reserved.
//

#import "PTSegmentControl.h"


@interface NSArray(ZallSafeObject)
@end
@implementation NSArray(PTSafeObject)
- (id)safeObjectAtIndex:(NSInteger)index {
    if(index < 0) {
        return (nil);
    }
    if(self.count == 0) {
        return (nil);
    }
    if(index > MAX(self.count - 1, 0)) {
        return (nil);
    }
    return ([self objectAtIndex:index]);
}
@end

NSTimeInterval const SOSegmentAnimationDuration     = 0.25f;

@interface PTSegmentControl () {
    UIView *_bottomLineView;
}

@property (strong, nonatomic) NSArray *items;

@property (strong, nonatomic) NSMutableArray *segments;

@end


@implementation PTSegmentControl
@synthesize segmentDelegate;
@synthesize selectedIndex = _selectedIndex;
@synthesize contentCount = _contentCount;
@synthesize items = _items;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        _selectedIndex = 0;
        _contentCount = DEFAULT_TITLE_COUNT;
        _items = nil;
        _segments = [[NSMutableArray alloc] init];
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorFromHexRGB(0xcccccc);
        [self addSubview:_bottomLineView];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    NSInteger itemsCount = [_items count];
    _contentCount = (self.contentCount <= itemsCount) ? self.contentCount : itemsCount;
    CGSize buttonSize = CGSizeMake(size.width / self.contentCount, size.height);
    
    self.contentSize = CGSizeMake(buttonSize.width * itemsCount, buttonSize.height);
    
    for(NSInteger ix = 0; ix < [[self segments] count]; ix ++) {
        PTSegmentButton *button = [[self segments] safeObjectAtIndex:ix];
        if(button && [button isKindOfClass:[PTSegmentButton class]]) {
            button.frame = CGRectMake(buttonSize.width * ix, 0, buttonSize.width, buttonSize.height);
        }
    }
    CGRect bottomLineFrame = _bottomLineView.frame;
    bottomLineFrame.size = CGSizeMake(self.contentSize.width, 1.0f / UIScreen.mainScreen.scale);
    bottomLineFrame.origin.y = self.bounds.size.height - bottomLineFrame.size.height;
    _bottomLineView.frame = bottomLineFrame;
}

#pragma mark - setter
- (void)setContentSize:(CGSize)contentSize {
    CGSize oldSize = self.contentSize;
    [super setContentSize:contentSize];
    if (CGSizeEqualToSize(oldSize, CGSizeZero) && !CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        [self setSelectedItemIndex:_selectedIndex animated:NO];
    }
}

- (void)setContentCount:(CGFloat)contentCount {
    [self willChangeValueForKey:@"contentCount"];
    _contentCount = contentCount;
    [self didChangeValueForKey:@"contentCount"];
    [self setNeedsLayout];
}

- (void)setItems:(NSArray *)items {
    [self willChangeValueForKey:@"items"];
    _items = [items copy];
    [self didChangeValueForKey:@"items"];
    if(self.segments) {
        [self.segments makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.segments removeAllObjects];
    }
    for (PTSegmentControlItem *item in items) {
        PTSegmentButton *button = [[PTSegmentButton alloc] initWithFrame:CGRectZero];
        button.backgroundColor = [UIColor clearColor];
        button.item = item;
        [button addTarget:self action:@selector(segmentButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.segments addObject:button];
    }
    [self setNeedsLayout];
}

- (void)setSelectedItemIndex:(NSInteger)index animated:(BOOL)animated {
    [self willChangeValueForKey:@"selectedIndex"];
    _selectedIndex = index;
    [self didChangeValueForKey:@"selectedIndex"];
    CGSize size = self.bounds.size;
    CGFloat ct_x = MIN(self.contentSize.width - size.width, MAX(0, (_selectedIndex + 0.5f) * size.width / self.contentCount - size.width / 2.0f));
    [self setContentOffset:CGPointMake(ct_x, self.contentOffset.y) animated:animated];
    
    for(NSInteger ix = 0; ix < [[self segments] count]; ix ++) {
        PTSegmentButton *button = (PTSegmentButton *)[[self segments] safeObjectAtIndex:ix];
        [button setDidHighlighted:(index == ix)];
    }
}
#pragma mark -

#pragma mark - getter
- (CGFloat)contentCount {
    return (MAX(1, _contentCount));
}

- (NSArray *)items {
    return ([NSArray arrayWithArray:_items]);
}

- (NSInteger)indexOfObject:(PTSegmentButton *)object {
    return ([[self segments] indexOfObject:object]);
}

- (PTSegmentButton *)buttonAtIndex:(NSInteger)index {
    return ([[self segments] safeObjectAtIndex:index]);
}
#pragma mark -

#pragma mark - actions
- (void)segmentButtonDidTouched:(PTSegmentButton *)button {
    if (self.segmentDelegate && [self.segmentDelegate respondsToSelector:@selector(segmentControl:didSelectButton:atIndex:)]) {
        NSInteger index = [self indexOfObject:button];
        [self.segmentDelegate segmentControl:self didSelectButton:button atIndex:index];
    }
}
#pragma mark -

@end
