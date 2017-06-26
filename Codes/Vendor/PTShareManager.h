//
//  PTShareManager.h
//  PTPark
//
//  Created by CHEN KAIDI on 12/5/2017.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PTShareManager : NSObject

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareSubtitle;
@property (nonatomic, strong) UIImage* imgShare;
@property (nonatomic, strong) NSString* webLink;

+ (instancetype)sharedManager;
-(void)setupShareSDK;
-(void) shareWxSession;
-(void) shareWxTimeline;
-(void) shareQQ;
-(void) shareQzone;
-(void) shareSina;

@end
