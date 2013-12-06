//
//  EditorModel.m
//  TextEditorDemo
//
//  Created by wangsh on 13-11-27.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import "EditorModel.h"

static UIImage *image;
static NSString *_fontname;
static NSNumber *_fontSize;
static UIColor * _color;
@implementation EditorModel

+ (EditorModel *)sharedObject{
    
    static EditorModel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[EditorModel alloc] init];
        
            });
    
    return sharedInstance;
}

-(void) setImage:(UIImage *)img{
    image = img;
}
-(UIImage *)getImage {
    return image;
}

-(void) setFont:(NSString *)fontname {
    _fontname = fontname;
}

-(NSString *) getFontname {
    return _fontname;
}

-(void) setFontSize:(NSNumber *)fontsize {
    _fontSize = fontsize;
}
-(NSNumber *)getFontsize {
    return  _fontSize;
}

-(void) setFontColor :(UIColor *)color{
    
    _color = color;
}

-(UIColor *)getFontColor {
    return _color;
}


@end
