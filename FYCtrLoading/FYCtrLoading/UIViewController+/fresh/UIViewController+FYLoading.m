//
//  UIViewController+FYLoading.m
//  FYCtrLoading
//
//  Created by SimonMiao on 2016/10/24.
//  Copyright © 2016年 yongrun. All rights reserved.
//

#import "UIViewController+FYLoading.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

//static const CGFloat KTipLoadingOverTime = 60;
static const CGFloat KTipNormalOverTime = 2;

@interface UIViewController (FYLoadingView) <MBProgressHUDDelegate>

@property (nonatomic,strong) MBProgressHUD * progressHud;

@end

@implementation UIViewController (FYLoadingView)

- (MBProgressHUD *)progressHud {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setProgressHud:(MBProgressHUD *)progressHud {
    return objc_setAssociatedObject(self, @selector(progressHud), progressHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (FYLoading)

#pragma mark - postLoading.

- (void)fy_postLoadingWithTitle:(NSString *)title {
    [self fy_postLoadingWithTitle:title detail:nil];
}

- (void)fy_postLoadingWithTitle:(NSString *)title contentColor:(UIColor *)contentColor {
    [self fy_postLoadingWithTitle:title];
    self.progressHud.contentColor = contentColor;
}

- (void)fy_postLoadingWithTitle:(NSString *)title detail:(NSString *)detail {
    [self fy_checkCreateHudLoading];
    
    if (title.length) {
        self.progressHud.label.text = title;
    }
    if (detail.length) {
        self.progressHud.detailsLabel.text = detail;
    }
}

- (void)fy_postLoadingDeterminateWithTitle:(NSString *)title {
    [self fy_checkCreateHudLoading];
    [self fy_setTitle:title];
    // Set the determinate mode to show task progress.
    self.progressHud.mode = MBProgressHUDModeDeterminate;
}

- (void)fy_postLoadingDeterminateWithTitle:(NSString *)title cancelButtonAction:(SEL)method {
    [self fy_postLoadingDeterminateWithTitle:title];
    
    // Configure the button.
    [self.progressHud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [self.progressHud.button addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
}

- (void)fy_postLoadingDeterminateWithTitle:(NSString *)title progressObject:(NSProgress *)progressObject cancelButtonAction:(SEL)method {
    [self fy_postLoadingDeterminateWithTitle:title cancelButtonAction:method];
    self.progressHud.progressObject = progressObject;
}

- (void)fy_postLoadingIndeterminateWithTitle:(NSString *)title {
    [self fy_checkCreateHudLoading];
    [self fy_setTitle:title];
    self.progressHud.mode = MBProgressHUDModeIndeterminate;
}

- (void)fy_postLoadingAnnularDeterminateWithTitle:(NSString *)title {
    [self fy_checkCreateHudLoading];
    [self fy_setTitle:title];
    self.progressHud.mode = MBProgressHUDModeAnnularDeterminate;
}

- (void)fy_postLoadingBarDeterminateWithTitle:(NSString *)title {
    [self fy_checkCreateHudLoading];
    [self fy_setTitle:title];
    self.progressHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
}

- (void)fy_setDeterminateProgress:(CGFloat)progress {
    self.progressHud.progress = progress;
//    [MBProgressHUD HUDForView:self.view].progress = progress;
}

- (void)fy_checkCreateHudLoading
{
    if (!self.progressHud) {
        self.progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.progressHud.delegate = self;
    }
}

- (void)fy_setTitle:(NSString *)title {
    if (title.length) {
        self.progressHud.label.text = title;
    }
}

- (void)fy_hideLoading {
    if (self.progressHud) {
        [self.progressHud hideAnimated:YES];
    }
}

- (void)fy_hideLoadingWithAfterDelay:(CGFloat)afterDelay {
    if (self.progressHud) {
        [self.progressHud hideAnimated:YES afterDelay:afterDelay];
    }
}

#pragma mark - postMessage

- (void)fy_postMessage:(NSString *)message {
    [self fy_postMessage:message duration:KTipNormalOverTime];
}

- (void)fy_postMessage:(NSString *)message duration:(NSTimeInterval)duration{
    [self fy_checkCreateHudLoading];
    [self fy_setTitle:message];
    // Set the text mode to show only text.
    self.progressHud.mode = MBProgressHUDModeText;
    // Move to bottm center.
//    self.progressHud.offset = CGPointMake(0.f, MBProgressMaxOffset);

    [self fy_hideLoadingWithAfterDelay:duration];
}

- (void)fy_postMessage:(NSString *)message customViewImageName:(NSString *)imageName {
    [self fy_postMessage:message customViewImageName:imageName isAutoHide:YES];
}

- (void)fy_postMessage:(NSString *)message customViewImageName:(NSString *)imageName isAutoHide:(BOOL)isAutoHide {
    [self fy_checkCreateHudLoading];
    [self fy_setTitle:message];
    // Set the custom view mode to show any view.
    self.progressHud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.progressHud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    self.progressHud.square = YES;
    
    if (isAutoHide) {
        [self fy_hideLoadingWithAfterDelay:KTipNormalOverTime];
    }
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (self.progressHud) {
        [self.progressHud removeFromSuperview];
        self.progressHud.delegate = nil;
        self.progressHud = nil;
    }
}

@end
