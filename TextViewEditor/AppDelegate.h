//
//  AppDelegate.h
//  TextViewEditor
//
//  Created by wangsh on 13-11-26.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) showNewView;

@end
