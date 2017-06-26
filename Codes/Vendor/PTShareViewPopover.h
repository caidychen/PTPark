//
//  PTShareViewPopover.h
//  PTPark
//
//  Created by CHEN KAIDI on 12/5/2017.
//
//

#import <UIKit/UIKit.h>

NSString *PTShareOptionWechatFriends = @"PTShareOptionWechatFriend";
NSString *PTShareOptionWechatNewsFeed = @"PTShareOptionWechatNewsFeed";
NSString *PTShareOptionQQFriends = @"PTShareOptionQQFriends";
NSString *PTShareOptionQQZone = @"PTShareOptionQQZone";
NSString *PTShareOptionSinaWeibo = @"PTShareOptionSinaWeibo";
NSString *PTShareOptionWebLink = @"PTShareOptionWebLink";

@interface PTShareViewPopover : UIView
+(void)showOptionsWithTitle:(NSString *)title subtitle:(NSString *)subtitle thumbImage:(UIImage *)thumb webURL:(NSString *)webURL;
@end
