//
//  UIViewController+FYLoading.h
//  FYCtrLoading
//
//  Created by SimonMiao on 2016/10/24.
//  Copyright © 2016年 yongrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FYLoading)

/** 自动隐藏message 默认时间为2秒 */
- (void)fy_postMessage:(NSString *)message;
- (void)fy_postMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)fy_postMessage:(NSString *)message customViewImageName:(NSString *)imageName;
- (void)fy_postMessage:(NSString *)message customViewImageName:(NSString *)imageName isAutoHide:(BOOL)isAutoHide;

- (void)fy_postLoadingWithTitle:(NSString *)title;
- (void)fy_postLoadingWithTitle:(NSString *)title contentColor:(UIColor *)contentColor;
- (void)fy_postLoadingWithTitle:(NSString *)title detail:(NSString *)detail;

/** post the indeterminate mode to show task progress. */
- (void)fy_postLoadingIndeterminateWithTitle:(NSString *)title;
/** post the determinate mode to show task progress. */
- (void)fy_postLoadingDeterminateWithTitle:(NSString *)title;
- (void)fy_postLoadingDeterminateWithTitle:(NSString *)title cancelButtonAction:(SEL)method;
- (void)fy_postLoadingDeterminateWithTitle:(NSString *)title progressObject:(NSProgress *)progressObject cancelButtonAction:(SEL)method;

/** post the annular determinate mode to show task progress. */
- (void)fy_postLoadingAnnularDeterminateWithTitle:(NSString *)title;
/** post the bar determinate mode to show task progress. */
- (void)fy_postLoadingBarDeterminateWithTitle:(NSString *)title;
/** Set the determinate mode to show task progress. */
- (void)fy_setDeterminateProgress:(CGFloat)progress;

- (void)fy_hideLoading;
- (void)fy_hideLoadingWithAfterDelay:(CGFloat)afterDelay;

@end
