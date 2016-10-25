//
//  UIColor+Hex.m
//  CocoVoice
//
//  Created by DevilWaiting on 13-10-19.
//
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b {
    return [UIColor colorWithR:r g:g b:b alpha:1.0];
}

+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithW:(NSInteger)w {
    return [UIColor colorWithW:w alpha:1.0];
}

+ (UIColor *)colorWithW:(NSInteger)w alpha:(CGFloat)alpha {
    return [UIColor colorWithWhite:w / 255.0 alpha:alpha];
}

@end

@implementation UIColor (LaunchrApp)
+ (UIColor *)themeBlue  { return [self colorWithHex:0x0099ff];}
+ (UIColor *)themeRed   { return [self colorWithHex:0xff3366];}
+ (UIColor *)themeGreen { return [self colorWithHex:0x22c064];}
+ (UIColor *)themeGray  { return [self colorWithW:143];}

+ (UIColor *)cellTitleGray  { return [self colorWithHex:0x707070];}
+ (UIColor *)grayBackground { return [self colorWithW:235];}

+ (UIColor *)mediumFontColor { return [self colorWithW:102];}
+ (UIColor *)minorFontColor  { return [self colorWithW:153];}

+ (UIColor *)borderColor { return [self colorWithW:204];}

+ (UIColor *)buttonHighlightColor { return [self colorWithW:235];}

+ (UIColor *)atUserOtherColor { return [self colorWithHex:0xfab56b];}
+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
