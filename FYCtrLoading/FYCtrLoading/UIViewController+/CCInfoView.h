//
//  CCInfoView.h
//  NCHospital
//
//  Created by JoeShao on 15/7/17.
//  Copyright (c) 2015年 com.mintcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCInfoView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *infoLabel;

-(instancetype)initWithImage:(UIImage *)image andMessage:(NSString *)message;

@end
