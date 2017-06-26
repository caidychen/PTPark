//
//  PTSegmentButton.h
//  SOKit
//
//  Created by soso on 13-2-21.
//  Copyright (c) 2013-2015 soso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTSegmentControlItem.h"

#ifndef UIColorFromHexRGB
#define UIColorFromHexRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

/**
 *  @brief  分段选项按钮
 */
@interface PTSegmentButton : UIControl {
    CGSize _gap;
    UIEdgeInsets _contentInsets;
}

/**
 *  @brief  间距
 */
@property (assign, nonatomic) CGSize gap;

/**
 *  @brief  四周留的边框
 */
@property (assign, nonatomic) UIEdgeInsets contentInsets;

/**
 *  @brief  自定义高亮
 */
@property (assign, nonatomic, getter=isDidHighlighted) BOOL didHighlighted;

/**
 *  @brief  标题标签
 */
@property (strong, nonatomic, readonly) UILabel *titleLabel;

/**
 *  @brief  图片视图
 */
@property (strong, nonatomic, readonly) UIImageView *imageView;

/**
 *  @brief  按钮的item
 */
@property (nonatomic, copy) PTSegmentControlItem *item;

@end
