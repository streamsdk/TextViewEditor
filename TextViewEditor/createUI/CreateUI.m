//
//  CreateUI.m
//  talk
//
//  Created by wangsh on 13-11-7.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "CreateUI.h"
#import <QuartzCore/QuartzCore.h>

@implementation CreateUI

-(UIButton *)setButtonFrame:(CGRect)frame withImage:(UIImage *)image{
     
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    button.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
   
    return button;
}

@end
