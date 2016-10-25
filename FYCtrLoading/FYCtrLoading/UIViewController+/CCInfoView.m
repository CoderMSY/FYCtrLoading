//
//  CCInfoView.m
//  NCHospital
//
//  Created by JoeShao on 15/7/17.
//  Copyright (c) 2015年 com.mintcode. All rights reserved.
//

#import "CCInfoView.h"
#import "UIColor+Hex.h"

@implementation CCInfoView

-(instancetype)initWithImage:(UIImage *)image andMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        self.infoLabel = [[UILabel alloc]init];
        self.imageView.image = image;
        self.infoLabel.text = message;
        self.infoLabel.font = [UIFont systemFontOfSize:15.0];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor colorWithHex:0x999999];
        self.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
        [self addSubview:self.imageView];
        [self addSubview:self.infoLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize image_size = self.imageView.image.size;
    CGSize label_size = [self.infoLabel.text sizeWithAttributes:@{NSFontAttributeName:self.infoLabel.font}];
    CGFloat off_x = (self.frame.size.width - image_size.width)/2;
    CGFloat off_y  =(self.frame.size.height - 64 - image_size.height - label_size.height)/2;
    self.imageView.frame = CGRectMake(off_x, off_y, image_size.width, image_size.height);
    off_x = (self.frame.size.width - label_size.width)/2;
    off_y +=image_size.height+15;
    self.infoLabel.frame = CGRectMake(off_x, off_y, label_size.width, label_size.height);
}



@end
