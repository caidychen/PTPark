//
//  PTSegmentButton.m
//  SOKit
//
//  Created by soso on 13-2-21.
//  Copyright (c) 2013-2015 soso. All rights reserved.
//

#import "PTSegmentButton.h"
#import "PTSegmentControlItem.h"

@interface PTSegmentButton ()
@property (assign, nonatomic) UIEdgeInsets titleEdgeInset;
@property (strong, nonatomic) UIView *markView;
@end

@implementation PTSegmentButton
@synthesize item = _item;
@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.titleEdgeInset = UIEdgeInsetsZero;
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.markView];
        [self bringSubviewToFront:self.markView];
        self.markView.transform = CGAffineTransformMakeRotation(M_PI_4);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.titleLabel.frame = UIEdgeInsetsInsetRect(self.bounds, self.titleEdgeInset);
    
    CGPoint tc = self.titleLabel.center;
    tc.y = self.frame.size.height/2;
    self.titleLabel.center = tc;
    
    self.markView.center = CGPointMake(self.titleLabel.center.x, self.bounds.size.height - 7);
}

#pragma mark - setter
- (void)setItem:(PTSegmentControlItem *)item {
    [self willChangeValueForKey:@"item"];
    _item = [item copy];
    [self didChangeValueForKey:@"item"];
    self.imageView.image = item.image;
    self.imageView.highlightedImage = item.highlightedImage;
    self.titleLabel.text = item.text;
    self.titleLabel.textColor = item.textColor;
    self.titleLabel.highlightedTextColor = item.highlightedTextColor;
    [self setNeedsLayout];
}

- (void)setDidHighlighted:(BOOL)didHighlighted {
    [self willChangeValueForKey:@"didHighlighted"];
    _didHighlighted = didHighlighted;
    [self didChangeValueForKey:@"didHighlighted"];
    self.titleLabel.highlighted = self.didHighlighted;
    self.imageView.highlighted = self.didHighlighted;
    self.markView.backgroundColor = self.didHighlighted ? UIColorFromHexRGB(0x8b49f6) : UIColor.clearColor;
}
#pragma mark -

#pragma mark - getter
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return (_titleLabel);
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return (_imageView);
}

- (UIView *)markView {
    if (!_markView) {
        _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _markView.backgroundColor = [UIColor clearColor];
    }
    return (_markView);
}
#pragma mark -

@end
