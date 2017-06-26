//
//  PTShareManager.m
//  PTPark
//
//  Created by CHEN KAIDI on 12/5/2017.
//
//

#import "PTShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"                                //新浪微博SDK头文件
#import "WXApi.h"                                   //微信SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>           //QQ互联 SDK
#import <TencentOpenAPI/TencentOAuth.h>
#import "SVProgressHUD.h"

#define UmengSina @"sina"
#define UmengQQ @"qq"
#define UmengWXTimeline @"wxtimeline"
#define UmengWXSession @"wxsession"
#define UmengQzone @"qzone"

static NSString *ShareSDKAppKey = @"1d890001a0515";
static NSString *SinaWeiboAppKey = @"2777913073";
static NSString *SinaWeiboAppSecret = @"884744e85e09663671911a14b291acda";
static NSString *WeChatAppID = @"wxe42eeee5cfdf4058";
static NSString *WeChatAppSecret = @"9d71bb816c76c74b0cdb8906fc7e4df7";
static NSString *QQAppID = @"1106121070";
static NSString *QQAppKey = @"RqarpUKfLeW55rBf";

@implementation PTShareManager

+ (instancetype)sharedManager {
    static PTShareManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(void)setupShareSDK{
    [ShareSDK registerApp:ShareSDKAppKey activePlatforms:@[
                                                           @(SSDKPlatformTypeSinaWeibo),
                                                           @(SSDKPlatformTypeCopy),
                                                           @(SSDKPlatformTypeWechat),
                                                           @(SSDKPlatformTypeQQ)
                                                           ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeSinaWeibo:
                             //                设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                             [appInfo SSDKSetupSinaWeiboByAppKey:SinaWeiboAppKey
                                                       appSecret:SinaWeiboAppSecret
                                                     redirectUri:@"http://www.putao.com"
                                                        authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:WeChatAppID
                                                   appSecret:WeChatAppSecret];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:QQAppID
                                                  appKey:QQAppKey
                                                authType:SSDKAuthTypeBoth];
                             break;
                         default:
                             break;
                     }
                 }];
    //注册微信
    [WXApi registerApp:WeChatAppID];
    
    
}

#pragma mark - 分享操作
-(void) shareWxSession{
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        [SVProgressHUD showErrorWithStatus:@"您还未安装手机微信" duration:1.0];
        return;
    }
    [self universalSharingActionWithPlatformSubType:SSDKPlatformSubTypeWechatSession appType:UmengWXSession];
}
-(void) shareWxTimeline{
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        [SVProgressHUD showErrorWithStatus:@"您还未安装手机微信" duration:1.0];
        return;
    }
    
    [self universalSharingActionWithPlatformSubType:SSDKPlatformSubTypeWechatTimeline appType:UmengWXTimeline];
}

-(void) shareQQ{
    
    [self universalSharingActionWithPlatformSubType:SSDKPlatformSubTypeQQFriend appType:UmengQQ];
}

-(void) shareQzone{
    
    [self universalSharingActionWithPlatformSubType:SSDKPlatformSubTypeQZone appType:UmengQzone];
}
-(void) shareSina{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        [SVProgressHUD showErrorWithStatus:@"您还未安装新浪微博" duration:2.0f];
        return;
    }
    [self universalSharingActionWithPlatformSubType:SSDKPlatformTypeSinaWeibo appType:UmengSina];
}

-(void)universalSharingActionWithPlatformSubType:(SSDKPlatformType)platform appType:(NSString *)appType{
    __weak typeof(self) weak_self = self;
    NSData *dataPhoto = UIImageJPEGRepresentation(self.imgShare, 0.4);
    UIImage *shareImage = [UIImage imageWithData:dataPhoto];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    SSDKContentType contentType = SSDKContentTypeWebPage;

    NSString *text = self.shareSubtitle;
    NSString *title = self.shareTitle;
    NSString *extInfo = @"";
    
    if (platform == SSDKPlatformSubTypeWechatTimeline || platform == SSDKPlatformSubTypeWechatSession) {
        [shareParams SSDKSetupWeChatParamsByText:text
                                           title:title
                                             url:[NSURL URLWithString:self.webLink]
                                      thumbImage:shareImage
                                           image:self.imgShare
                                    musicFileURL:nil
                                         extInfo:extInfo
                                        fileData:nil
                                    emoticonData:nil
                                            type:contentType
                              forPlatformSubType:platform];
    }else if (platform == SSDKPlatformSubTypeQQFriend || platform == SSDKPlatformSubTypeQZone){
        [shareParams SSDKSetupQQParamsByText:text
                                       title:title
                                         url:[NSURL URLWithString:self.webLink]
                                  thumbImage:shareImage
                                       image:shareImage
                                        type:contentType
                          forPlatformSubType:platform];
    }else if (platform == SSDKPlatformTypeSinaWeibo){
        [shareParams SSDKEnableUseClientShare];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:text
                                                   title:title
                                                   image:self.imgShare
                                                     url:[NSURL URLWithString:self.webLink]
                                                latitude:0.0
                                               longitude:0.0
                                                objectID:nil
                                                    type:contentType];
    }
    
    [ShareSDK share:platform parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [weak_self shareWhenCompleteWithState:state andError:error appType:appType];
        NSLog(@"%@", error);
        
    }];
    
}

-(NSString *)getAppNameFromType:(NSString *)appType{
    NSString *appName = @"";
    if ([appType isEqualToString:UmengWXSession] || [appType isEqualToString:UmengWXTimeline]) {
        appName = @"微信";
    }else if ([appType isEqualToString:UmengQQ] || [appType isEqualToString:UmengQzone]){
        appName = @"QQ";
    }else if ([appType isEqualToString:UmengSina]){
        appName = @"微博";
    }
    return appName;
}

-(void) shareWithType:(NSString *)type {
    
}

// 分享成功后
- (void)shareWhenCompleteWithState:(SSDKResponseState)state andError:(NSError *)error appType:(NSString *)appType{
    NSString *appName = [self getAppNameFromType:appType];
    
    switch (state) {
        case SSDKResponseStateBegin:
            
            break;
        case SSDKResponseStateSuccess:
            
            [SVProgressHUD showSuccessWithStatus:@"分享成功" duration:2.0];
            break;
        case SSDKResponseStateFail:
            if (error) {
                if ([error.userInfo objectForKey:@"error_message"]) {
                    NSLog(@"%@", error);
                    if (error.code == 208) {
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"您还未安装%@",appName] duration:2.0];
                    }else{
                        [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:@"error_message"] duration:2.0];
                    }
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"分享失败" duration:2.0];
            }
            break;
        case SSDKResponseStateCancel:
            
            break;
            
        default:
            break;
    }
}


@end
