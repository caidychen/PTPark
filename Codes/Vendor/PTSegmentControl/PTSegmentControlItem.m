//
//  PTSegmentControlItem.m
//  SOKit
//
//  Created by soso on 13-2-21.
//  Copyright (c) 2013-2015 soso. All rights reserved.
//

#import "PTSegmentControlItem.h"

@implementation PTSegmentControlItem
@synthesize text = _text;
@synthesize image = _image, highlightedImage = _highlightedImage;
@synthesize textColor = _textColor, highlightedTextColor = _highlightedTextColor;
@synthesize titleEdgeInset = _titleEdgeInset;

+ (instancetype)itemWithText:(NSString *)text
                   textColor:(UIColor *)textColor
        highlightedTextColor:(UIColor *)highlightedTextColor
                        font:(UIFont *)font
                 titleInsets:(UIEdgeInsets)titleInsets{
    return ([self itemWithText:text
                     textColor:textColor
          highlightedTextColor:highlightedTextColor
                          font:font
                         image:nil
              highlightedImage:nil
                   titleInsets:titleInsets]);
}

+ (instancetype)itemWithText:(NSString *)text
                   textColor:(UIColor *)textColor
        highlightedTextColor:(UIColor *)highlightedTextColor
                        font:(UIFont *)font
                       image:(UIImage *)image
            highlightedImage:(UIImage *)highlightedImage
                 titleInsets:(UIEdgeInsets)titleInsets {
    PTSegmentControlItem *item = [[PTSegmentControlItem alloc] init];
    item.text = text;
    item.textColor = textColor;
    item.highlightedTextColor = highlightedTextColor;
    item.font = font;
    item.image = image;
    item.highlightedImage = highlightedImage;
    item.titleEdgeInset = titleInsets;
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.text = nil;
        self.font = [UIFont systemFontOfSize:14];
        self.image = self.highlightedImage = nil;
        self.textColor = [UIColor blackColor];
        self.highlightedTextColor = [UIColor lightGrayColor];
        self.titleEdgeInset = UIEdgeInsetsZero;
    }
    return (self);
}

- (id)copyWithZone:(NSZone *)zone {
    PTSegmentControlItem *item = [[PTSegmentControlItem alloc] init];
    item.text = self.text;
    item.font = self.font;
    item.image = self.image;
    item.highlightedImage = self.highlightedImage;
    item.textColor = self.textColor;
    item.highlightedTextColor = self.highlightedTextColor;
    item.titleEdgeInset = self.titleEdgeInset;
    return item;
}

@end
