//
//  CCLoadingView.h
//  Coco
//
//  Created by gaofeng on 12/6/14.
//  Copyright (c) 2014 Instanza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD.h"

#define TipLoadingOverTime 60
#define TipNormalOverTime 2

@protocol CCLoadingDelegate;

@interface CCLoadingView : UIView<MBProgressHUDDelegate>

@property (assign,nonatomic) BOOL mute; // 是否不显示任何提示
@property (nonatomic,strong) MBProgressHUD * HUD;
@property (weak, nonatomic) id<CCLoadingDelegate> delegate;

- (void)postMessage:(NSString *)message;
- (void)postMessage:(NSString *)message overTime:(NSTimeInterval)second;
//纯文字的toast
- (void)postMessageWithoutImage:(NSString *)message overTime:(NSTimeInterval)second;
- (void)postLoading:(NSString *)message;
- (void)postError:(NSString *)message;
- (void)postError:(NSString *)message duration:(CGFloat)duration;
- (void)postError:(NSString *)message detailMessage:(NSString *)detailMessage duration:(CGFloat)duration;
- (void)postLoading:(NSString *)message overTime:(NSTimeInterval)second;
- (void)postLoading:(NSString *)title message:(NSString *)message;
- (void)postLoading:(NSString *)title message:(NSString *)message overTime:(NSTimeInterval)second;
- (void)hide:(BOOL)animated;

@end


@protocol CCLoadingDelegate <NSObject>

- (void)hudWasHidden;

@end
