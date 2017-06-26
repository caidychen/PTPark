//
//  PTShareViewPopover.m
//  PTPark
//
//  Created by CHEN KAIDI on 12/5/2017.
//
//

#import "PTShareViewPopover.h"
#import "UIColor+Help.h"
#import "UIView+PPTAdditions.h"
#import "PTShareManager.h"

#define kShareTotalHeight 280
#define kShareTotalHeightSmall 200
#define kSplitterHeight 10
#define kCancelButtonHeight 44
#define kPageSize 8

@interface PTShareViewPopover ()

@property (nonatomic, strong) NSMutableArray *shareIconArray;
@property (nonatomic, strong) NSMutableArray *shareTitleArray;
@property (nonatomic, strong) NSArray *options;


@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *thumb;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *subtitle;


@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *dismissBackdrop;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *dashboard;
@property (nonatomic, strong) UIView *splitterView;
@property (nonatomic, strong) UIButton *cancelButton;
@end



@implementation PTShareViewPopover

+(void)showOptionsWithTitle:(NSString *)title subtitle:(NSString *)subtitle thumbImage:(UIImage *)thumb webURL:(NSString *)webURL{
    PTShareViewPopover *shareView = [[PTShareViewPopover alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shareView.options = @[PTShareOptionWechatFriends, PTShareOptionWechatNewsFeed, PTShareOptionQQFriends, PTShareOptionQQZone, PTShareOptionSinaWeibo];
    shareView.title = title;
    shareView.thumb = thumb;
    shareView.webURL = webURL;
    shareView.subtitle = subtitle;
    [shareView showView];
}

-(void)addAPIWithShareOption:(NSString *)shareOption{
    if ([shareOption isEqualToString:PTShareOptionWechatFriends]) {
        [self.shareTitleArray addObject:@"微信好友"];
        [self.shareIconArray addObject:@"icon_40_01"];
    }else if ([shareOption isEqualToString:PTShareOptionWechatNewsFeed]) {
        [self.shareTitleArray addObject:@"微信朋友圈"];
        [self.shareIconArray addObject:@"icon_40_02"];
    }else if ([shareOption isEqualToString:PTShareOptionQQFriends]) {
        [self.shareTitleArray addObject:@"QQ好友"];
        [self.shareIconArray addObject:@"icon_40_03"];
    }else if ([shareOption isEqualToString:PTShareOptionQQZone]) {
        [self.shareTitleArray addObject:@"QQ空间"];
        [self.shareIconArray addObject:@"icon_40_04"];
    }else if ([shareOption isEqualToString:PTShareOptionSinaWeibo]) {
        [self.shareTitleArray addObject:@"新浪微博"];
        [self.shareIconArray addObject:@"icon_40_05"];
    }else if ([shareOption isEqualToString:PTShareOptionWebLink]) {
        [self.shareTitleArray addObject:@"复制链接"];
        [self.shareIconArray addObject:@"icon_40_06"];
    }
    
}

-(void)showView{
    
    for(NSString *option in self.options){
        [self addAPIWithShareOption:option];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.dismissBackdrop];
    if (self.options.count<=4) {
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kShareTotalHeightSmall+50)];
    }else{
        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kShareTotalHeight+50)];
    }
    
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:self.dashboard];
    [self.dashboard addSubview:self.scrollView];
    [self.baseView addSubview:self.splitterView];
    [self.baseView addSubview:self.cancelButton];
    [self.dashboard addSubview:self.titleLabel];
    [self addSubview:self.baseView];
    self.titleLabel.text = [NSString stringWithFormat:@"分享%@到",self.title];
    self.baseView.center = CGPointMake(self.baseView.center.x, [UIScreen mainScreen].bounds.size.height+self.baseView.bounds.size.height/2);
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            weak_self.baseView.center = CGPointMake(weak_self.baseView.center.x, [UIScreen mainScreen].bounds.size.height-weak_self.baseView.bounds.size.height/2+50);
                        } completion:^(BOOL finished) {}];
    [weak_self setNeedsLayout];
}

-(void)hide:(UIButton *)sender{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            weakSelf.baseView.center = CGPointMake(weakSelf.baseView.center.x, [UIScreen mainScreen].bounds.size.height+weakSelf.baseView.bounds.size.height/2);
                            weakSelf.dismissBackdrop.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [weakSelf removeFromSuperview];
                        }];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.dashboard.frame = CGRectMake(0, 0, self.dashboard.bounds.size.width, self.dashboard.bounds.size.height);
    self.splitterView.frame = CGRectMake(0, self.dashboard.bottom, self.splitterView.bounds.size.width, self.splitterView.bounds.size.height);
    self.cancelButton.frame = CGRectMake(0, self.splitterView.bottom, self.cancelButton.bounds.size.width, self.cancelButton.bounds.size.height);
    self.titleLabel.frame = CGRectMake(0, 20, self.bounds.size.width, self.titleLabel.font.lineHeight);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.frame = CGRectMake(0, self.titleLabel.bottom, self.bounds.size.width, self.dashboard.bounds.size.height-self.titleLabel.bottom-20);
    
    NSInteger totalIconNumber = self.shareIconArray.count;
    NSInteger numberOfPage = ceilf((float)totalIconNumber/kPageSize);
    NSInteger offset = 0;
    for (NSInteger i=0; i<numberOfPage; i++) {
        UIView *dashboardPage = [self dashboardPageWithFrame:self.scrollView.frame atOffset:offset];
        offset += kPageSize;
        dashboardPage.frame = CGRectMake(dashboardPage.width*i, 0, dashboardPage.width, dashboardPage.height);
        [self.scrollView addSubview:dashboardPage];
        [self.scrollView setContentSize:CGSizeMake(dashboardPage.right, self.scrollView.height)];
    }
}

-(UIView *)dashboardPageWithFrame:(CGRect)frame atOffset:(NSInteger)offset{
    UIView *page = [[UIView alloc] initWithFrame:frame];
    NSInteger x = 1;
    NSInteger y = 1;
    CGFloat width = self.scrollView.bounds.size.width/4;
    CGFloat height = self.scrollView.bounds.size.height/2;
    if (self.options.count<=4) {
        height = self.scrollView.bounds.size.height;
    }
    for (NSInteger i=0; i<kPageSize; i++) {
        if (i+offset==self.shareIconArray.count) {
            break;
        }
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(width*(x-1), height*(y-1), width, height)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((control.bounds.size.width-40)/2, 20, 40, 40)];
        icon.image = [UIImage imageNamed:[self.shareIconArray objectAtIndex:i+offset]];
        [control addSubview:icon];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.bottom+10, control.width, [UIFont systemFontOfSize:12].lineHeight)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"646464"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.shareTitleArray objectAtIndex:i+offset];
        [control addSubview:label];
        if ((i+1)%4 == 0) {
            x=1;
            y++;
        }else{
            x++;
        }
        [page addSubview:control];
        control.tag = i+offset;
        [control addTarget:self action:@selector(didTapShareControl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return page;
}


-(void)didTapShareControl:(UIControl *)control{
    [self hide:nil];
    [PTShareManager sharedManager].shareTitle = self.title;
    [PTShareManager sharedManager].shareSubtitle = self.subtitle;
    [PTShareManager sharedManager].webLink = self.webURL;
    [PTShareManager sharedManager].imgShare = self.thumb;
    NSString *shareOption = [self.options objectAtIndex:control.tag];
    if ([shareOption isEqualToString:PTShareOptionWechatFriends]) {
        [[PTShareManager sharedManager] shareWxSession];
    }else if ([shareOption isEqualToString:PTShareOptionWechatNewsFeed]) {
        [[PTShareManager sharedManager] shareWxTimeline];
    }else if ([shareOption isEqualToString:PTShareOptionQQFriends]) {
        [[PTShareManager sharedManager] shareQQ];
    }else if ([shareOption isEqualToString:PTShareOptionQQZone]) {
        [[PTShareManager sharedManager] shareQzone];
    }else if ([shareOption isEqualToString:PTShareOptionSinaWeibo]) {
        [[PTShareManager sharedManager] shareSina];
    }
}

-(NSMutableArray *)shareIconArray{
    if (!_shareIconArray) {
        _shareIconArray = [[NSMutableArray alloc] init];
    }
    return _shareIconArray;
}

-(NSMutableArray *)shareTitleArray{
    if (!_shareTitleArray) {
        _shareTitleArray = [[NSMutableArray alloc] init];
    }
    return _shareTitleArray;
}

-(UIButton *)dismissBackdrop{
    if (!_dismissBackdrop) {
        _dismissBackdrop = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _dismissBackdrop.backgroundColor = [[UIColor colorWithHexString:@"000000"] colorWithAlphaComponent:0.5];
        [_dismissBackdrop addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBackdrop;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIView *)dashboard{
    if (!_dashboard) {
        if (self.options.count<=4) {
            _dashboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kShareTotalHeightSmall-kCancelButtonHeight-kSplitterHeight)];
        }else{
            _dashboard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kShareTotalHeight-kCancelButtonHeight-kSplitterHeight)];
        }
        _dashboard.backgroundColor = [UIColor whiteColor];
        _dashboard.layer.borderColor = [UIColor colorWithHexString:@"e1e1e1"].CGColor;
        _dashboard.layer.borderWidth = 0.5;
    }
    return _dashboard;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"959595"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

-(UIView *)splitterView{
    if (!_splitterView) {
        _splitterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kSplitterHeight)];
        _splitterView.backgroundColor = [UIColor colorWithHexString:@"EBEBEB"];
    }
    return _splitterView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kCancelButtonHeight)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"ed5564"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.layer.borderColor = [UIColor colorWithHexString:@"e1e1e1"].CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        [_cancelButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
