//
//  TextConfig.m
//  TextViewEditor
//
//  Created by wangsh on 13-11-26.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import "TextConfig.h"
#import <CoreText/CoreText.h>

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

static AttributeConfig *editorAttributeConfig = nil;
static AttributeConfig *readerAttributeConfig = nil;
static AttributeConfig *readerTitleAttributeConfig = nil;

@implementation TextConfig


+(AttributeConfig *)editorAttributeConfig{
    
    @synchronized (self)
    {
        if (editorAttributeConfig == nil)
        {
            editorAttributeConfig= [[AttributeConfig alloc] init];
            //TODO load from config
            
            editorAttributeConfig.attributes=[self defaultAttributes];
            
            
        }
    }
    return editorAttributeConfig;
    
}

+(AttributeConfig *)readerAttributeConfig{
    
    @synchronized (self)
    {
        if (readerAttributeConfig == nil)
        {
            readerAttributeConfig= [[AttributeConfig alloc] init];
            readerAttributeConfig.attributes=[self defaultReaderAttributes];
            //TODO load from config
        }
        
    }
    return readerAttributeConfig;
}






+(AttributeConfig *)readerTitleAttributeConfig{
    
    @synchronized (self)
    {
        if (readerTitleAttributeConfig == nil)
        {
            readerTitleAttributeConfig= [[AttributeConfig alloc] init];
            readerTitleAttributeConfig.attributes=[self defaultReaderTitleAttributes];
            //TODO load from config
        }
        
    }
    return readerTitleAttributeConfig;
}



+(NSDictionary *)defaultAttributes{
    
    NSString *fontName =[[UIFont systemFontOfSize:17]fontName];//@"Hiragino Sans GB";
    CGFloat fontSize= 17.0f;
    UIColor *color = [UIColor blackColor];
    UIColor *strokeColor = [UIColor whiteColor];
    CGFloat strokeWidth = 0.0;
    CGFloat paragraphSpacing = 20.0;
    CGFloat paragraphSpacingBefore = 20.0;
    CGFloat lineSpacing = 5.0;
    CGFloat minimumLineHeight=0.0f;
    
    //CGFloat headIndent= 20.0;
    
    
    
    
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName,
                                             fontSize, NULL);
    
    CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore },
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing },
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight },
        
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, ARRSIZE(settings));
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)color.CGColor, kCTForegroundColorAttributeName,
                           (id)color, NSBackgroundColorAttributeName,
                           (__bridge id)fontRef, kCTFontAttributeName,
                           (id)strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                           (id)[NSNumber numberWithFloat: strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           (__bridge id) paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                           nil];
    
    CFRelease(fontRef);
    return attrs;
}


//modify by yangzongming
+(NSDictionary *)defaultReaderAttributes{
    return  [self defaultAttributes];
    
}

+(NSDictionary *)defaultReaderTitleAttributes{
    return  [self defaultAttributes];
}


@end
