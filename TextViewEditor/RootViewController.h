//
//  RootViewController.h
//  TextViewEditor
//
//  Created by wangsh on 13-11-26.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FastTextView;

@interface RootViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    FastTextView *_fastTextView;
    BOOL isAddSlide;
    UIPageControl *pageControl;
    UIScrollView *scrollView;
    CGFloat origin_y;
}

@property(nonatomic,strong) FastTextView *fastTextView;

@property(nonatomic,strong) UITextView *textView;

@property(strong,nonatomic) UIView *topview;


@end
