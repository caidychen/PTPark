//
//  PTConfig.h
//  PTPark
//
//  Created by soso on 2017/5/18.
//
//

#import <Foundation/Foundation.h>
#import <GPushiOS/PTGPush.h>

#ifndef PTConfig_h
#define PTConfig_h

/*
 *** 开发环境 ***
 */
#ifdef PTDEV
//GPush类型配置
static GPushServiceType GPushType = GPushServiceTypeDevelop;

//友盟渠道配置
static NSString * const PTUMChannel = @"development";

//接口域名配置
static NSString * const PTBaseURL           = @"http://dev-api-assistant.ptdev.cn";
static NSString * const PTStoreBaseURL      = @"http://dev-api-store-park.ptdev.cn"; //电商-服务器地址
static NSString * const PTAccountBaseURL    = @"http://dev-api-park.ptdev.cn";
static NSString * const PTPointsH5BaseURL   = @"http://dev.fe.ptdev.cn/ptpark/v1.1.0/mark.html";
static NSString * const PTUploadImageURL    = @"http://upload.dev.putaocloud.com/upload";
static NSString * const PTDownloadImageURL  = @"http://library.file.dev.putaocloud.com/file/";
static NSString * const PTVersionCheckURL   = @"https://versions.putaocloud.com";
static NSString * const PTBookingBaseURL    = @"http://dev-api-booking.ptdev.cn";
static NSString * const PTGrowTreeBaseURL   = @"http://dev.fe.ptdev.cn/ptpark/v1.2.0/tree_animation.html?inapp=1";
#endif


/*
 *** 测试环境 ***
 */
#ifdef PTTEST
//GPush类型配置
static GPushServiceType GPushType = GPushServiceTypeTest;

//友盟渠道配置
static NSString * const PTUMChannel = @"test";

//接口域名配置
static NSString * const PTBaseURL           = @"http://test-api-assistant.ptdev.cn";
static NSString * const PTStoreBaseURL      = @"http://test-api-store-park.ptdev.cn"; //电商-服务器地址
static NSString * const PTAccountBaseURL    = @"http://test-api-park.ptdev.cn";
static NSString * const PTPointsH5BaseURL   = @"http://test.fe.ptdev.cn/ptpark/v1.1.0/mark.html";
static NSString * const PTUploadImageURL    = @"http://upload.dev.putaocloud.com/upload";
static NSString * const PTDownloadImageURL  = @"http://library.file.dev.putaocloud.com/file/";
static NSString * const PTVersionCheckURL   = @"https://versions.putaocloud.com";
static NSString * const PTBookingBaseURL    = @"http://test-api-booking.ptdev.cn";
static NSString * const PTGrowTreeBaseURL   = @"http://test.fe.ptdev.cn/ptpark/v1.2.0/tree_animation.html?inapp=1";
#endif


/*
 *** 生产环境 ***
 */
#ifdef PTPRO
//GPush类型配置
static GPushServiceType GPushType = GPushServiceTypeProduct;

//友盟渠道配置
static NSString * const PTUMChannel = @"AppStore";

//接口域名配置
static NSString * const PTBaseURL           = @"https://member.putao.com.cn";
static NSString * const PTStoreBaseURL      = @"https://api-store-park.putao.com";
static NSString * const PTAccountBaseURL    = @"https://api-park.putao.com";
static NSString * const PTPointsH5BaseURL   = @"https://h5.putao.com/ptpark/v1.1.0/mark.html";
static NSString * const PTUploadImageURL    = @"https://upload.putaocloud.com/upload";
static NSString * const PTDownloadImageURL  = @"https://mall-file.putaocdn.com/file/";
static NSString * const PTVersionCheckURL   = @"https://versions.putaocloud.com";
//static NSString * const PTBookingBaseURL       = @"https://test-api-booking.ptdev.cn";
//static NSString * const PTGrowTreeBaseURL   = @"http://dev.fe.ptdev.cn/ptpark/v1.2.0/tree_animation.html?inapp=1";
#endif

#endif /* PTConfig_h */
