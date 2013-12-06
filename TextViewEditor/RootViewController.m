//
//  RootViewController.m
//  TextViewEditor
//
//  Created by wangsh on 13-11-26.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import "RootViewController.h"
#import "FastTextView.h"
#import "TextConfig.h"
#import "SlideAttachmentCell.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreText/CoreText.h>
#import "UIImage-Extensions.h"
#import "NSAttributedString+TextUtil.h"
#import "FacialView.h"
#import "CreateUI.h"
#import "EmotionAttachmentCell.h"
#import "BackgroundImgViewController.h"
#import "RichTextEditorFontPickerViewController.h"
#import "RichTextEditorFontSizePickerViewController.h"
#import "EditorModel.h"
#import "RichTextEditorColorPickerViewController.h"

@interface RootViewController ()<facialViewDelegate>{

}

@end
#define NAVBAR_HEIGHT 44.0f
#define TABBAR_HEIGHT 49.0f
#define STATUS_HEIGHT 20.0f

#define TOP_VIEW_HEIGHT 33.0f

#define ARRSIZE(a)      (sizeof(a) / sizeof(a[0]))

@implementation RootViewController
@synthesize fastTextView = _fastTextView,textView,topview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL) animated{
    EditorModel * model = [EditorModel sharedObject];
    UIImage *image = [model getImage];
    if (_fastTextView) {
        if (image) {
            [_fastTextView setBackgroundColor:[UIColor colorWithPatternImage:image]];
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
        }
        // font & fontsize
        NSString * fontName = [model getFontname];
        NSNumber *fontSize = [model getFontsize];
        
        if (fontSize && fontName) {
           
            CTFontRef font = CTFontCreateWithName((CFStringRef)fontName, [fontSize floatValue], NULL);
            [_fastTextView.attributedString beginStorageEditing];
            [_fastTextView.attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:_fastTextView.selectedRange];
            [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
            [_fastTextView.attributedString endStorageEditing];
            [_fastTextView refreshAllView];
            return;

        }else{
            if (fontName){
                CTFontRef font = CTFontCreateWithName((CFStringRef)fontName, 17, NULL);
                [_fastTextView.attributedString beginStorageEditing];
                [_fastTextView.attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:_fastTextView.selectedRange];
                [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
                [_fastTextView.attributedString endStorageEditing];
                [_fastTextView refreshAllView];
                
            }
            if (fontSize) {
                CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:[fontSize floatValue]].fontName, [fontSize floatValue], NULL);
                [_fastTextView.attributedString beginStorageEditing];
                [_fastTextView.attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:_fastTextView.selectedRange];
                [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
                [_fastTextView.attributedString endStorageEditing];
                [_fastTextView refreshAllView];

            }
        }
        UIColor * fontcolor = [model getFontColor];
        if (fontcolor) {
            
            [_fastTextView.attributedString beginStorageEditing];
            [_fastTextView.attributedString addAttribute:(id)kCTForegroundColorAttributeName
                                                   value:(id)fontcolor.CGColor range:_fastTextView.selectedRange];
            [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
            [_fastTextView.attributedString endStorageEditing];
            [_fastTextView refreshAllView];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"b3.png"]]];
    origin_y= NAVBAR_HEIGHT+STATUS_HEIGHT;

    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    self.navigationItem.rightBarButtonItem = right;
    
    if (_fastTextView == nil) {
        FastTextView *view = [[FastTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.delegate = (id<FastTextViewDelegate>)self;
        view.attributeConfig=[TextConfig editorAttributeConfig];
        view.placeHolder=@"内容";
        [view setFont:[UIFont systemFontOfSize:17]];
        view.pragraghSpaceHeight=15;
        view.backgroundColor=[UIColor clearColor];
        [self.view addSubview:view];
        self.fastTextView = view;
        [_fastTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"b3.png"]]];
    }
    
    NSString *default_txt = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"b.txt"];
     
     NSError *error;
     NSString *base_content=[NSString stringWithContentsOfFile:default_txt encoding:NSUTF8StringEncoding error:&error];
     
     NSMutableAttributedString *parseStr=[[NSMutableAttributedString alloc]initWithString:base_content];
     [parseStr addAttributes:[self defaultAttributes] range:NSMakeRange(0, [parseStr length])];
     self.fastTextView.attributedString=parseStr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    topview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, TOP_VIEW_HEIGHT)];
    [[topview layer] setCornerRadius:3];
    [[topview layer] setBorderWidth:1];
    [[topview layer] setBorderColor:[UIColor grayColor].CGColor];
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_VIEW_HEIGHT)];
    CreateUI *creat = [[CreateUI alloc]init];
    
    // cancel keyboard
    UIButton *cancelBtn = [creat setButtonFrame:CGRectMake(0, 0, TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"keyboard.png"]];
    [cancelBtn addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    //add image button
    UIButton *imgBtn = [creat setButtonFrame:CGRectMake(TOP_VIEW_HEIGHT+10, 0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"camera_button_take.png"]];
    [imgBtn addTarget:self action:@selector(attachSlide:) forControlEvents:UIControlEventTouchUpInside];
    
    // add face  button
    UIButton *faceBtn= [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*2,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"face.png"]];
    [faceBtn addTarget:self action:@selector(showFace:) forControlEvents:UIControlEventTouchUpInside];
    
    // chang background image
    UIButton *backgroundBtn = [creat setButtonFrame:CGRectMake((10+TOP_VIEW_HEIGHT)*3, 0, TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"photoMark.png"]];
     [backgroundBtn addTarget:self action:@selector(changeBackImg:) forControlEvents:UIControlEventTouchUpInside];
    
    // change font button
    UIButton *fontBtn= [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*4,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"fontNameMark.png"]];
    [fontBtn addTarget:self action:@selector(showFont:) forControlEvents:UIControlEventTouchUpInside];
    
    // change fontsize  button
    UIButton *fontSizeBtn= [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*5,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"fontSizeMark.png"]];
    [fontSizeBtn addTarget:self action:@selector(showFontSize:) forControlEvents:UIControlEventTouchUpInside];
    
    // blod button
    UIButton *btnBold = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*6,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"boldMark.png"]];
    [btnBold addTarget:self action:@selector(bold:) forControlEvents:UIControlEventTouchUpInside];
    
    // italic button
    UIButton *italic = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*7,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"italicMark.png"]];
    [italic addTarget:self action:@selector(italic:) forControlEvents:UIControlEventTouchUpInside];
    
    //underline button
    UIButton *underlineBtn = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*8,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"underlineMark.png"]];
    [underlineBtn addTarget:self action:@selector(underlineBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // fontColor button
    UIButton *fontColorBtn = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*9,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"forecolor.png"]];
    [fontColorBtn addTarget:self action:@selector(fontColorBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //left button
    UIButton *justifyleftBtn = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*10,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"justifyleft.png"]];
    [justifyleftBtn addTarget:self action:@selector(justifyleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    //justifycenter button
    UIButton *justifycenterBtn = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*11,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"justifycenter.png"]];
    [justifycenterBtn addTarget:self action:@selector(justifycenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    //justifyright button
    UIButton *justifyrightBtn = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*12,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"justifyright.png"]];
    [justifyrightBtn addTarget:self action:@selector(justifyrightBtn:) forControlEvents:UIControlEventTouchUpInside];
    //justifyfull button
    UIButton *justifyfullBtn = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*13,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"justifyfull.png"]];
    [justifyfullBtn addTarget:self action:@selector(justifyfullBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //firstLineIndent button
    UIButton *firstLineIndentBtn = [creat setButtonFrame:CGRectMake( (10+TOP_VIEW_HEIGHT)*14,0,TOP_VIEW_HEIGHT, TOP_VIEW_HEIGHT) withImage:[UIImage imageNamed:@"firstLineIndent.png"]];
    [firstLineIndentBtn addTarget:self action:@selector(firstLineIndentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [sv addSubview:cancelBtn];
    [sv addSubview:imgBtn];
    [sv addSubview:btnBold];
    [sv addSubview:faceBtn];
    [sv addSubview:fontBtn];
    [sv addSubview:fontSizeBtn];
    [sv addSubview:backgroundBtn];
    [sv addSubview:italic];
    [sv addSubview:underlineBtn];
    [sv addSubview:fontColorBtn];
    [sv addSubview:justifyleftBtn];
    [sv addSubview:justifycenterBtn];
    [sv addSubview:justifyrightBtn];
    [sv addSubview:justifyfullBtn];

    [sv addSubview:firstLineIndentBtn];
    
    sv.showsVerticalScrollIndicator = NO;
    sv.contentSize = CGSizeMake((10+TOP_VIEW_HEIGHT)*15,0);
    [topview addSubview:sv];
}

-(void)doneClicked {
    
    [_fastTextView resignFirstResponder];
    
    CGPoint savedContentOffset = _fastTextView.contentOffset;
    CGRect savedFrame = _fastTextView.frame;
    _fastTextView.contentOffset= CGPointZero;
    
    UIGraphicsBeginImageContext(_fastTextView.contentSize);
    _fastTextView.frame= CGRectMake(0, 0, _fastTextView.contentSize.width, _fastTextView.contentSize.height);
    CGSize size = CGSizeMake(_fastTextView.frame.size.width*2, _fastTextView.frame.size.height*2);
    [_fastTextView setContentSize:size];
    [_fastTextView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _fastTextView.contentOffset= savedContentOffset;
    _fastTextView.frame= savedFrame;
    
    [self saveImageToPhotos:image];
    
}
- (void)saveImageToPhotos:(UIImage*)savedImage

{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

-(NSDictionary *)defaultAttributes{
    
    NSString *fontName = @"Helvetica";
    CGFloat fontSize= 17.0f;
    UIColor *color = [UIColor blackColor];
    CGFloat paragraphSpacing = 0.0;
    CGFloat lineSpacing = 0.0;
    
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName,
                                             fontSize, NULL);
    
    CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing },
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing },
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, ARRSIZE(settings));
    
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)color.CGColor, kCTForegroundColorAttributeName,
                           (__bridge id)fontRef, kCTFontAttributeName,
                          
                           nil];
    CFRelease(fontRef);
    return attrs;
}


//show font
-(void) showFont :(id)sender {
    RichTextEditorFontPickerViewController  *fontVC = [[RichTextEditorFontPickerViewController alloc]init];
    fontVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:fontVC animated:YES completion:nil];
}
// show font size
-(void)showFontSize:(id)sender {
    RichTextEditorFontSizePickerViewController  *fontSizeVC = [[RichTextEditorFontSizePickerViewController alloc]init];
    fontSizeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:fontSizeVC animated:YES completion:nil];
}
//font color
-(void) fontColorBtn:(id)sender {
    RichTextEditorColorPickerViewController  *fontColorVC = [[RichTextEditorColorPickerViewController alloc]init];
    fontColorVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    fontColorVC.textColor = @"fontcolor";
    [self presentViewController:fontColorVC animated:YES completion:nil];
}

//blod
-(void) bold:(id)sender {
    if (_fastTextView.selectedRange.length>0) {
        CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:17].fontName, 17, NULL);
        [_fastTextView.attributedString beginStorageEditing];
        [_fastTextView.attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:_fastTextView.selectedRange];
        [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
        [_fastTextView.attributedString endStorageEditing];
        [_fastTextView refreshAllView];
    }
}
//italic
-(void) italic:(id) sender {
    if (_fastTextView.selectedRange.length>0) {
        CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:17].fontName, 17, NULL);
        
        [_fastTextView.attributedString beginStorageEditing];
        [_fastTextView.attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:_fastTextView.selectedRange];
        [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
        [_fastTextView.attributedString endStorageEditing];
        [_fastTextView refreshAllView];
    }
}

//underline
-(void)underlineBtn:(id)sender {
    if (_fastTextView.selectedRange.length>0) {
        CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:17].fontName, 17, NULL);
        [_fastTextView.attributedString beginStorageEditing];
        [_fastTextView.attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:_fastTextView.selectedRange];
        
        //下划线
        [_fastTextView.attributedString addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleThick] range:_fastTextView.selectedRange];
        //下划线颜色
        [_fastTextView.attributedString addAttribute:(id)kCTUnderlineColorAttributeName value:(id)[UIColor blueColor].CGColor range:_fastTextView.selectedRange];
        
        [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
        [_fastTextView.attributedString endStorageEditing];
        [_fastTextView refreshAllView];
    }
}
-(void) setCTTextAlignment:(CTTextAlignment) alignment {
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    //创建样式数组
    CTParagraphStyleSetting settings[]={
        alignmentStyle
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    
    [_fastTextView.attributedString beginStorageEditing];
    [_fastTextView.attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:CFBridgingRelease(paragraphStyle) range:_fastTextView.selectedRange];
    [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
    [_fastTextView.attributedString endStorageEditing];
    [_fastTextView refreshAllView];
}

//justifyleftBtn:
-(void) justifyleftBtn:(id)sender {
    if (_fastTextView.selectedRange.length>0) {
        CTTextAlignment alignment = kCTLeftTextAlignment;
        [self setCTTextAlignment:alignment];
    }

}
//justifycenterBtn:
-(void) justifycenterBtn:(id)sender {
    if (_fastTextView.selectedRange.length>0) {
        CTTextAlignment alignment = kCTCenterTextAlignment;
        [self setCTTextAlignment:alignment];
    }
    
}
//justifyrightBtn:
-(void) justifyrightBtn:(id)sender {
    if (_fastTextView.selectedRange.length>0) {
        CTTextAlignment alignment = kCTRightTextAlignment;
        [self setCTTextAlignment:alignment];
    }
    
}
//justifyfullBtn:
-(void) justifyfullBtn:(id)sender {
    if (_fastTextView.selectedRange.length>0) {
        CTTextAlignment alignment = kCTJustifiedTextAlignment;
        [self setCTTextAlignment:alignment];
    }
}
//firstLineIndentBtn
-(void) firstLineIndentBtn:(id) sender{
    if (_fastTextView.selectedRange.length>0) {
        CGFloat fristlineindent = 24.0f;
        CTParagraphStyleSetting fristline;
        fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
        fristline.value = &fristlineindent;
        fristline.valueSize = sizeof(float);
        //创建样式数组
        CTParagraphStyleSetting settings[]={
            fristline
        };

        //设置样式
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    
        [_fastTextView.attributedString beginStorageEditing];
        [_fastTextView.attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:CFBridgingRelease(paragraphStyle) range:_fastTextView.selectedRange];
        [_fastTextView.attributedString refreshParagraghInRange:_fastTextView.selectedRange];
        [_fastTextView.attributedString endStorageEditing];
        [_fastTextView refreshAllView];

    }
}

//show face

-(void)showFace:(UIButton*)sender
{
	sender.tag=!sender.tag;
	if (sender.tag) {
		[_fastTextView resignFirstResponder];
        UIView *inputView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        [inputView setBackgroundColor:[UIColor grayColor]];
        
		scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        [scrollView setBackgroundColor:[UIColor grayColor]];
		for (int i=0; i<3; i++) {
			FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 180)];
			[fview loadFacialView:i size:CGSizeMake(45, 45)];
			fview.delegate=self;
			[scrollView addSubview:fview];
			
		}
		scrollView.contentSize=CGSizeMake(320*3, 180);
        scrollView.showsVerticalScrollIndicator  = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled=YES;
        scrollView.delegate = self;
        
        //定义PageControll
        pageControl = [[UIPageControl alloc] init];
        [pageControl setBackgroundColor:[UIColor grayColor]];
        pageControl.frame = CGRectMake(130, 180, 60, 20);//指定位置大小
        pageControl.numberOfPages = 3;//指定页面个数
        pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        //添加委托方法，当点击小白点就执行此方法
        [inputView addSubview:scrollView];
        [inputView addSubview:pageControl];
        
        _fastTextView.inputView=inputView;
		[_fastTextView becomeFirstResponder];
        }else {
		_fastTextView.inputView=nil;
        
		[_fastTextView reloadInputViews];
		[_fastTextView becomeFirstResponder];
	}
    
}

//scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

//pagecontroll的委托方法
- (void)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}
-(void)selectedFacialView:(NSString*)str
{
    [self _addEmotion:str];
}

- (void)_addEmotion:(NSString *)emotionImgName;
{
    UITextRange *selectedTextRange = [_fastTextView selectedTextRange];
    if (!selectedTextRange) {
        UITextPosition *endOfDocument = [_fastTextView endOfDocument];
        selectedTextRange = [_fastTextView textRangeFromPosition:endOfDocument toPosition:endOfDocument];
    }
    UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
    
    unichar attachmentCharacter = FastTextAttachmentCharacter;
    [_fastTextView replaceRange:selectedTextRange withText:[NSString stringWithFormat:@"%@",[NSString stringWithCharacters:&attachmentCharacter length:1]]];
    
//    startPosition=[fastTextView positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
    UITextPosition *endPosition = [_fastTextView positionFromPosition:startPosition offset:1];
    selectedTextRange = [_fastTextView textRangeFromPosition:startPosition toPosition:endPosition];
    
    
    NSMutableAttributedString *mutableAttributedString=[_fastTextView.attributedString mutableCopy];
    
    NSUInteger st = ((FastIndexedPosition *)(selectedTextRange.start)).index;
    NSUInteger en = ((FastIndexedPosition *)(selectedTextRange.end)).index;
    
    if (en < st) {
        return;
    }
    NSUInteger contentLength = [[_fastTextView.attributedString string] length];
    if (en > contentLength) {
        en = contentLength; // but let's not crash
    }
    if (st > en)
        st = en;
    NSRange cr = [[_fastTextView.attributedString string] rangeOfComposedCharacterSequencesForRange:(NSRange){ st, en - st }];
    if (cr.location + cr.length > contentLength) {
        cr.length = ( contentLength - cr.location ); // but let's not crash
    }
    
    FileWrapperObject *fileWp = [[FileWrapperObject alloc] init];
    [fileWp setFileName:emotionImgName];
    [fileWp setFilePath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:emotionImgName]];
    EmotionAttachmentCell *cell = [[EmotionAttachmentCell alloc] initWithFileWrapperObject:fileWp] ;
    [mutableAttributedString addAttribute: FastTextAttachmentAttributeName value:cell  range:cr];
    
    if (mutableAttributedString) {
        _fastTextView.attributedString = mutableAttributedString;
    }
}

//add image
-(void)attachSlide:(id)sender;
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    isAddSlide=true;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)_addAttachmentFromAsset:(ALAsset *)asset;
{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    NSMutableData *data = [NSMutableData dataWithLength:(int)[rep size]];
    
    NSError *error = nil;
    if ([rep getBytes:[data mutableBytes] fromOffset:0 length:(int)[rep size] error:&error] == 0) {
        NSLog(@"error getting asset data %@", [error debugDescription]);
    } else {
        //        NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
        //        wrapper.filename = [[rep url] lastPathComponent];
        UIImage *img=[UIImage imageWithData:data];
        
        NSString *newfilename=[NSAttributedString scanAttachmentsForNewFileName:_fastTextView.attributedString];
        
        
        
        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * _documentDirectory = [[NSString alloc] initWithString:[_paths objectAtIndex:0]];
        
        
        UIImage *thumbimg=[img imageByScalingProportionallyToSize:CGSizeMake(1024,6000)];
        
        NSString *pngPath=[_documentDirectory stringByAppendingPathComponent:newfilename];
        
        [UIImageJPEGRepresentation(thumbimg,0.7)writeToFile:pngPath atomically:YES];
        
        UITextRange *selectedTextRange = [_fastTextView selectedTextRange];
        if (!selectedTextRange) {
            UITextPosition *endOfDocument = [_fastTextView endOfDocument];
            selectedTextRange = [_fastTextView textRangeFromPosition:endOfDocument toPosition:endOfDocument];
        }
        UITextPosition *startPosition = [selectedTextRange start] ; // hold onto this since the edit will drop
        
        unichar attachmentCharacter = FastTextAttachmentCharacter;
        [_fastTextView replaceRange:selectedTextRange withText:[NSString stringWithFormat:@"\n%@\n",[NSString stringWithCharacters:&attachmentCharacter length:1]]];
        
        startPosition=[_fastTextView positionFromPosition:startPosition inDirection:UITextLayoutDirectionRight offset:1];
        UITextPosition *endPosition = [_fastTextView positionFromPosition:startPosition offset:1];
        selectedTextRange = [_fastTextView textRangeFromPosition:startPosition toPosition:endPosition];
        
        
        NSMutableAttributedString *mutableAttributedString=[_fastTextView.attributedString mutableCopy];
        
        NSUInteger st = ((FastIndexedPosition *)(selectedTextRange.start)).index;
        NSUInteger en = ((FastIndexedPosition *)(selectedTextRange.end)).index;
        
        if (en < st) {
            return;
        }
        NSUInteger contentLength = [[_fastTextView.attributedString string] length];
        if (en > contentLength) {
            en = contentLength; // but let's not crash
        }
        if (st > en)
            st = en;
        NSRange cr = [[_fastTextView.attributedString string] rangeOfComposedCharacterSequencesForRange:(NSRange){ st, en - st }];
        if (cr.location + cr.length > contentLength) {
            cr.length = ( contentLength - cr.location ); // but let's not crash
        }
        
        if(isAddSlide){
            
            FileWrapperObject *fileWp = [[FileWrapperObject alloc] init];
            [fileWp setFileName:newfilename];
            [fileWp setFilePath:pngPath];
            
            SlideAttachmentCell *cell = [[SlideAttachmentCell alloc] initWithFileWrapperObject:fileWp] ;
            cell.isNeedThumb=TRUE;
            cell.thumbImageWidth=200.0f;
            cell.thumbImageHeight=200.0f;
            
            [mutableAttributedString addAttribute: FastTextAttachmentAttributeName value:cell  range:cr];
            
        }
        if (mutableAttributedString) {
            _fastTextView.attributedString = mutableAttributedString;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init] ;
    [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
             resultBlock:^(ALAsset *asset){
                 // This get called asynchronously (possibly after a permissions question to the user).
                 [self _addAttachmentFromAsset:asset];
             }
            failureBlock:^(NSError *error){
                NSLog(@"error finding asset %@", [error debugDescription]);
            }];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//change background image

-(void) changeBackImg:(UIButton *) button {
   
    BackgroundImgViewController * bgView = [[BackgroundImgViewController alloc]init];
    bgView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:bgView animated:YES completion:nil];
}

-(void)dismissKeyBoard:(id)sender {
    [_fastTextView resignFirstResponder];
}
#pragma mark Removing toolbar

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.fastTextView.frame = CGRectMake(self.fastTextView.frame.origin.x, 0, self.fastTextView.frame.size.width,self.view.bounds.size.height  - keyBoardSize.height-TOP_VIEW_HEIGHT );
    
    self.topview.frame = CGRectMake(0, self.fastTextView.frame.origin.y+ self.fastTextView.frame.size.height, self.fastTextView.frame.size.width, TOP_VIEW_HEIGHT);
    
    [self.view addSubview:self.topview];
    [self.view bringSubviewToFront:self.topview];
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    self.fastTextView.frame = CGRectMake(self.fastTextView.frame.origin.x, 0, self.fastTextView.frame.size.width, self.view.bounds.size.height);
    
    [self.topview removeFromSuperview];
}

#pragma mark -
#pragma mark fastTextViewDelegate

- (BOOL)fastTextViewShouldBeginEditing:(FastTextView *)textView {
    return YES;
}

- (BOOL)fastTextViewShouldEndEditing:(FastTextView *)textView {
    return YES;
}

- (void)fastTextViewDidBeginEditing:(FastTextView *)textView {
}

- (void)fastTextViewDidEndEditing:(FastTextView *)textView {

}

- (void)fastTextViewDidChange:(FastTextView *)textView {
    
}

- (void)fastTextView:(FastTextView*)textView didSelectURL:(NSURL *)URL {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
