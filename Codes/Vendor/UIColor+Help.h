
#import <UIKit/UIKit.h>

@interface UIColor (Help)
///**
// *  @brief  get方法
// *
// *  @return 返回red分量
// */
//- (CGFloat)red;
//
///**
// *  @brief  get方法
// *
// *  @return 返回green分量
// */
//- (CGFloat)green;
//
///**
// *  @brief  get方法
// *
// *  @return 返回blue分量
// */
//- (CGFloat)blue;
//
///**
// *  @brief  get方法
// *
// *  @return 返回alpha分量
// */
//- (CGFloat)alpha;
//- (CGColorSpaceModel)colorSpaceModel;
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
