// Copyright 2011 The Omni Group.  All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import "EmotionAttachmentCell.h"

#import <ImageIO/CGImageSource.h>
#import <CoreText/CoreText.h>

@interface EmotionAttachmentCell ()
- (void)_cacheImage;
@end

@implementation EmotionAttachmentCell
@synthesize range;
@synthesize cellRect;
@synthesize fileWrapperObject = _fileWrapperObject;


- (void)dealloc;
{
    _fileWrapperObject = nil;
    CGImageRelease(drawImageRef);
    _image = nil;
}

-(id)init{
    self = [super init];
    if(self){
        NSLog(@"EmotionAttachmentCell init");
    }
    return self;
}

#pragma mark -
#pragma mark OATextAttachmentCell subclass
- (void)encodeWithCoder:(NSCoder *)coder {
    
    
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if (self != nil) {
  	}
	return self;
}

- (id)initWithFileWrapperObject:(FileWrapperObject *)_fileWpObj{
    if (!(self = [super init]))
        return nil;
    self.fileWrapperObject = _fileWpObj;
    return self;
}



-(CGRect)cellRect{
    return cellRect;
}

- (UIView *)attachmentView{
    return nil;
}

- (CGSize) attachmentSize{
    [self _cacheImage];
    return _image ? fullcellsize : CGSizeZero;
}

- (void) attachmentDrawInRect: (CGRect)cellFrame{
    self.cellRect = cellFrame;
    [self _cacheImage];
    if (!_image)
        return;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, cellFrame, _image.CGImage);
    
}



#pragma mark -
#pragma mark Private

- (void)_cacheImage;
{
    
    if (_image)
        return;
    
    if(self.fileWrapperObject != nil){
        //图片本地存在
        _image = [UIImage imageWithContentsOfFile:self.fileWrapperObject.filePath];
    }
    
    if (_image) {
        drawImageRef=CGImageRetain(_image.CGImage);
    }
    
    CGSize imgsize=CGSizeMake(_image.size.width, _image.size.height);
    fullcellsize=imgsize;
    leftmargin=CGPointZero;
    
}

- (CGPoint)cellBaselineOffset
{
    [self _cacheImage];
    return _image ? leftmargin : CGPointZero;
    
}



@end
