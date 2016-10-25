//
//  UIViewController+Loading.h
//  NCDoctor
//
//  Created by SimonMiao on 16/7/3.
//  Copyright © 2016年 SimonMiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Loading)

- (void)setPostYOffset:(int)offset;
- (void)postSuccess:(NSString *)message;
- (void)postSuccess:(NSString *)message overTime:(NSTimeInterval)second;
- (void)postMessage:(NSString *)message;
- (void)postLoadingWithMessage:(NSString *)message;
- (void)postLoadingWithMessage:(NSString *)message overTime:(NSTimeInterval)second;
- (void)postLoadingWithTitle:(NSString *)title message:(NSString*)message;
- (void)postLoadingWithTitle:(NSString *)title message:(NSString*)message overTime:(NSTimeInterval)second;
- (void)postError:(NSString *)message;
- (void)postError:(NSString *)message duration:(CGFloat)duration;
- (void)postNetworkError;
- (void)postWaiting;
- (void)hideLoading;

- (void)showNoContentWarningView;   //显示无内容
- (void)hideNoContentWarningView;   //隐藏无内容
- (void)showNetworkErrorWarningView; //显示网络出错
- (void)hideNetworkErrorWarningView;    //隐藏网络出错

@end
