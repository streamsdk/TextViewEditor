//
//  EditorModel.h
//  TextEditorDemo
//
//  Created by wangsh on 13-11-27.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditorModel : NSObject{

}
+ (EditorModel *)sharedObject;

-(void) setImage:(UIImage *)img;

-(UIImage *) getImage;

-(void) setFont:(NSString *)fontname;

-(NSString *) getFontname;

-(void) setFontSize:(NSNumber *)fontsize;

-(NSNumber *) getFontsize;

-(void)setFontSize:(NSNumber *)fontsize;

-(NSNumber *) getFontsize;

-(void) setFontColor :(UIColor *)color;

-(UIColor *)getFontColor ;

@end
