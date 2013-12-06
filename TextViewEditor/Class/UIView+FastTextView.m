//
//  UIView+FastTextView.m
//  TextViewEditor
//
//  Created by wangsh on 13-12-4.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import "UIView+FastTextView.h"

@implementation UIView (FastTextView)
- (UIColor *)colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
	
    CGContextTranslateCTM(context, -point.x, -point.y);
	
    [self.layer renderInContext:context];
	
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
	
    return color;
}

- (UIViewController *)firstAvailableViewController
{
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController
{
    id nextResponder = [self nextResponder];
	
    if ([nextResponder isKindOfClass:[UIViewController class]])
	{
        return nextResponder;
    }
	else if ([nextResponder isKindOfClass:[UIView class]])
	{
        return [nextResponder traverseResponderChainForUIViewController];
    }
	else
	{
        return nil;
    }
}

@end
