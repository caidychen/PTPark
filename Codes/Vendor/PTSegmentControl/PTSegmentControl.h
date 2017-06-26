//
//  PTSegmentControl.h
//  SOKit
//
//  Created by soso on 13-2-21.
//  Copyright (c) 2013-2015 soso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSegmentButton.h"

/**
 *  @brief  默认标题个数
 */
#define DEFAULT_TITLE_COUNT 5

/**
 *  @brief  分段选项动画周期
 */
extern NSTimeInterval const SOSegmentAnimationDuration;

@class PTSegmentControl;
/**
 *  @brief  回调协议
 */
@protocol SOSegmentControlDelegate <NSObject>

/**
 *  @brief  回调选中的button和对应的索引
 */
- (void)segmentControl:(PTSegmentControl *)segmentControl didSelectButton:(PTSegmentButton *)button atIndex:(NSInteger)index;
@end

/**
 *  @brief  分段选项视图
 */
@interface PTSegmentControl : UIScrollView
/**
 *  @brief  选中的索引
 */
@property (nonatomic, readonly) NSInteger selectedIndex;

/**
 *  @brief  能展示的item个数，items超过这个数字就会解锁自动滚动，contentCount大于items个数时会自动修正为[items count]
 */
@property (nonatomic, assign) CGFloat contentCount;

/**
 *  @brief  响应回调的对象
 */
@property (nonatomic, weak) id<SOSegmentControlDelegate> segmentDelegate;

/**
 *  @brief  返回当前item数组
 */
- (NSArray *)items;

/**
 *  @brief  返回索引为index的button
 */
- (PTSegmentButton *)buttonAtIndex:(NSInteger)index;

/**
 *  @brief  set方法，设置当前item数组
 */
- (void)setItems:(NSArray *)items;

/**
 *  @brief  set方法，设置当前选中的索引
 */
- (void)setSelectedItemIndex:(NSInteger)index animated:(BOOL)animated;

@end
