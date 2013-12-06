//
//  TextConfig.h
//  TextViewEditor
//
//  Created by wangsh on 13-11-26.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "AttributeConfig.h"
@interface TextConfig : NSObject

+(AttributeConfig *)editorAttributeConfig;
+(AttributeConfig *)readerAttributeConfig;
+(AttributeConfig *)readerTitleAttributeConfig;

@end
