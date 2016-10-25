//
//  UIViewController+Loading.m
//  NCDoctor
//
//  Created by SimonMiao on 16/7/3.
//  Copyright © 2016年 SimonMiao. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "CCLoadingView.h"
#import "CCInfoView.h"

#import <objc/runtime.h>

@interface UIViewController (loadingView)  <CCLoadingDelegate>

@property (nonatomic, strong) CCLoadingView *loadingView;
@property (nonatomic, strong) CCInfoView *noContentWarningView;
@property (nonatomic, strong) CCInfoView *netErrorWarningView;

@property (nonatomic, assign)   CGFloat         yOffset;

@end

@implementation UIViewController (loadingView)

- (CCLoadingView *)loadingView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLoadingView:(CCLoadingView *)loadingView {
        objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CCInfoView *)noContentWarningView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNoContentWarningView:(CCInfoView *)noContentWarningView {
    objc_setAssociatedObject(self, @selector(noContentWarningView), noContentWarningView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CCInfoView *)netErrorWarningView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNetErrorWarningView:(CCInfoView *)netErrorWarningView {
    objc_setAssociatedObject(self, @selector(netErrorWarningView), netErrorWarningView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)yOffset {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setYOffset:(CGFloat)yOffset {
    objc_setAssociatedObject(self, @selector(yOffset), @(yOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - CCLoadingDelegate
- (void)hudWasHidden {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView.delegate = nil;
        self.loadingView = nil;
    }
}

@end

@implementation UIViewController (Loading)

#pragma mark - loading method
- (void)setPostYOffset:(int)offset
{
    self.yOffset = offset;
    
}


- (void)postSuccess:(NSString *)message{
    [self postMessage:message];
}
- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second{
    [self checkCreateLoading];
    [self.loadingView postMessage:message overTime:second];
}

- (void)postMessage:(NSString *)message{
    [self checkCreateLoading];
    
    self.loadingView.HUD.yOffset = self.yOffset;
    [self.loadingView postMessage:message];
}

- (void)postError:(NSString *)message duration:(CGFloat)duration{
    
    
    [self checkCreateLoading];
    [self.loadingView postError:message duration:duration];
}

- (void)postError:(NSString *)message{
    
    [self postError:message duration:TipNormalOverTime];
    
}

- (void)postNetworkError
{
    [self postError:@"网络错误"];//CCLocalizedString(@"common.networkerror")
}
- (void)postLoadingWithMessage:(NSString *)message{
        [self checkCreateLoading];
        [self.loadingView postLoading:message];
//    [self gifLoadingView];
    //    [self.gifLoadingView startGIF];
//    CCLog(@"******message********:%@",message);
}

- (void)postLoadingWithMessage:(NSString *)message overTime:(NSTimeInterval)second{
    [self checkCreateLoading];
    [self.loadingView postLoading:message overTime:second];
}

- (void)postLoadingWithTitle:(NSString *)title message:(NSString*)message {
    [self checkCreateLoading];
    [self.loadingView postLoading:title message:message];
}

- (void)postLoadingWithTitle:(NSString *)title message:(NSString*)message overTime:(NSTimeInterval)second {
    [self checkCreateLoading];
    [self.loadingView postLoading:title message:message overTime:second];
}

- (void)postWaiting {
    [self postLoadingWithMessage:NSLocalizedString(@"common.pleasewait", @"Please Wait...")];
}


- (void)checkCreateLoading
{
    if (!self.loadingView) {
        self.loadingView = [[CCLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.loadingView];
        [self.view bringSubviewToFront:self.loadingView];
        self.loadingView.delegate = self;
    }
}

- (void)hideLoading{
    if (self.loadingView) {
        [self.loadingView hide:NO];
        [self.loadingView removeFromSuperview];
        self.loadingView.delegate = nil;
        self.loadingView = nil;
    }
//    [self hideGifLoadingView];
}

- (void)showNoContentWarningView{
    if (!self.noContentWarningView) {
        self.noContentWarningView = [[CCInfoView alloc] initWithImage:[UIImage imageNamed:@"img_common_warning_noContent"] andMessage:@"没有内容"];
        self.noContentWarningView.frame = self.view.bounds;
        [self.view addSubview:self.noContentWarningView];
        [self.view bringSubviewToFront:self.noContentWarningView];
    }
}

- (void)hideNoContentWarningView{
    if (self.noContentWarningView) {
        [self.noContentWarningView removeFromSuperview];
        self.noContentWarningView = nil;
    }
}

- (void)showNetworkErrorWarningView{
    if (!self.netErrorWarningView) {
        self.netErrorWarningView = [[CCInfoView alloc] initWithImage:[UIImage imageNamed:@"img_common_warning_noNetwork"] andMessage:@"断线了"];
        self.netErrorWarningView.frame = self.view.bounds;
        [self.view addSubview:self.netErrorWarningView];
        [self.view bringSubviewToFront:self.netErrorWarningView];
    }
}

- (void)hideNetworkErrorWarningView{
    if (self.netErrorWarningView) {
        [self.netErrorWarningView removeFromSuperview];
        self.netErrorWarningView = nil;
    }
}


@end
