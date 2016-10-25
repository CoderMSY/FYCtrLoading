//
//  CCLoadingView.m
//  Coco
//
//  Created by gaofeng on 12/6/14.
//  Copyright (c) 2014 Instanza Inc. All rights reserved.
//

#import "CCLoadingView.h"
//#import "AppImgConst.h"

@interface CCLoadingView(){
    BOOL _isLoading;
    BOOL _ignoreEvents;
}
@end

@implementation CCLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self];
        self.HUD.animationType = MBProgressHUDAnimationFade;
        self.HUD.delegate = self;
        self.HUD.mode = MBProgressHUDModeText;
        [self addSubview:self.HUD];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutElements
{
    CGRect hud_rect = self.bounds;
    hud_rect.origin.y -= 20;
    hud_rect.size.height += 20;
    self.HUD.frame = hud_rect;
}

- (void)dealloc{
    self.HUD.delegate = nil;
    self.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overTimerCallback) object:nil];
}

- (void)postMessage:(NSString *)message{
    [self postMessage:message overTime:TipNormalOverTime];
}

- (void)postMessage:(NSString *)message overTime:(NSTimeInterval)second
{
    UIImage *msgImg = [UIImage imageNamed:@"kTipSuccess"];
    [self postMessage:message overTime:second image:msgImg];
}

- (void)postMessageWithoutImage:(NSString *)message overTime:(NSTimeInterval)second
{
    [self postMessage:message overTime:second image:nil];
}

- (void)postMessage:(NSString *)message overTime:(NSTimeInterval)second image:(UIImage *)msgImg
{
    if (_mute)
    {
        return;
    }
    
    if([message length] == 0){//不提示空内容
        [self hide:YES];
        return;
    }
    
    //有图片
    if (msgImg)
    {
        UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
        _HUD.customView = msgImageview;
        _HUD.mode = MBProgressHUDModeCustomView;
    }
    //没有图片，显示纯文字
    else
    {
        _HUD.customView = nil;
        _HUD.mode = MBProgressHUDModeText;
    }

    _HUD.detailsLabelText = message;
    _HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [_HUD show:YES];
    
    [self layoutElements];
    
    [self performSelector:@selector(overTimerCallback) withObject:nil afterDelay:second];
}

- (void)postLoading:(NSString *)message{
    [self postLoading:message overTime:TipLoadingOverTime];
}

- (void)postLoading:(NSString *)message overTime:(NSTimeInterval)second {
    if (_mute)
    {
        return;
    }
    
    if (_isLoading&&[self.HUD.labelText isEqual:message]){
        return;
    }
    
    
    _isLoading = YES;
    
	self.HUD.customView = nil;
	self.HUD.mode = MBProgressHUDModeIndeterminate;
//    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCCImageLoadingImage]];
//    _HUD.customView = msgImageview;
//    _HUD.mode = MBProgressHUDModeCustomView;
	self.HUD.detailsLabelText = message;
    self.HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    
	[self.HUD show:YES];
    
    [self performSelector:@selector(overTimerCallback) withObject:nil afterDelay:second];
}

- (void)postLoading:(NSString *)title message:(NSString *)message {
    [self postLoading:title message:message overTime:TipLoadingOverTime];
}

- (void)postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second
{
    if (_mute)
    {
        return;
    }
    
    if (_isLoading&&[self.HUD.labelText isEqual:message]){
        return;
    }
    
    
    _isLoading = YES;
    
	self.HUD.customView = nil;
	self.HUD.mode = MBProgressHUDModeText;
	self.HUD.labelText = title;
    self.HUD.detailsLabelText = message;
    
	[self.HUD show:YES];
    
    [self performSelector:@selector(overTimerCallback) withObject:nil afterDelay:second];
}

- (void)postError:(NSString *)message duration:(CGFloat)duration{
    [self postError:message detailMessage:nil duration:duration];
}

- (void)postError:(NSString *)message
{
    [self postError:message detailMessage:nil];
}

- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage;
{
    [self postError:message detailMessage:detailMessage duration:TipNormalOverTime];
}

- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration{
    if (_mute)
    {
        return;
    }
    
    _isLoading = NO;
    
    if([message length] == 0 && [detailMessage length] == 0){//不提示空内容
        [self hide:YES];
        return;
    }
    
    UIImage * msgImg = [UIImage imageNamed:@"kTipError"];
    UIImageView * msgImageview = [[UIImageView alloc] initWithImage:msgImg];
    _HUD.customView = msgImageview;
    _HUD.mode = MBProgressHUDModeCustomView;
    if (detailMessage.length == 0) {
        detailMessage = message;
    }
    //	_HUD.labelText = message;
    _HUD.detailsLabelText = detailMessage;
    self.HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [_HUD show:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overTimerCallback) object:nil];
    [self performSelector:@selector(overTimerCallback) withObject:nil afterDelay:duration];
}

- (void)hide:(BOOL)animated{
    _isLoading = NO;
    [self.HUD hide:animated];
    if (_ignoreEvents) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    _ignoreEvents = NO;
    self.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overTimerCallback) object:nil];
}

- (void)overTimerCallback{
    [self hide:NO];
}


- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hudWasHidden)]) {
        [self.delegate hudWasHidden];
    }
}


@end
