//
//  BackgroundImgViewController.m
//  TextEditorDemo
//
//  Created by wangsh on 13-11-29.
//  Copyright (c) 2013年 wangsh. All rights reserved.
//

#import "BackgroundImgViewController.h"
#import "RootViewController.h"
#import "EditorModel.h"
#define SPACE_WIDTH 10
#define IMAGE_HEIGHT_WIDTH 52
#define COLUMN 5
@interface BackgroundImgViewController ()

@end

@implementation BackgroundImgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.img = [[NSArray alloc]initWithObjects:@"b1.png",@"b2.png",@"b3.png",@"b4.png",@"b5.png",@"b6.png",nil];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolbar];
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(closeSelected:)];
    
    [toolbar setItems:@[flexibleSpaceItem , closeItem]];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    int line = [self.img count]%COLUMN ? [self.img count]/COLUMN+1 :[self.img count]/COLUMN;
    int column;
    for (int i = 0; i < line; i++) {
        if (i == line-1) {
            column = [self.img count]%COLUMN ? [self.img count]%COLUMN :COLUMN ;
        }else{
            column = COLUMN;
        }
        for (int j = 0; j < column; j++) {
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(SPACE_WIDTH+(IMAGE_HEIGHT_WIDTH+10)*j, SPACE_WIDTH+(IMAGE_HEIGHT_WIDTH+10)*i, IMAGE_HEIGHT_WIDTH, IMAGE_HEIGHT_WIDTH)];
            [imageview setImage:[UIImage imageNamed:[self.img objectAtIndex:COLUMN*i+j]]];
            imageview.userInteractionEnabled = YES;
            UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageSeleted:)];
            [imageview addGestureRecognizer:sigleTap];
            imageview.tag = COLUMN*i+j+100;
            [self.scrollView addSubview:imageview];
        }
    }
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, self.view.frame.size.height - 64);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (IMAGE_HEIGHT_WIDTH+SPACE_WIDTH)*line);
    [self.view addSubview:self.scrollView];
    
    self.contentSizeForViewInPopover = CGSizeMake(250, 400);
    
}
-(void) imageSeleted:(UIGestureRecognizer *) gestureRecognizer {
    
    UIImageView * img = (UIImageView *)[gestureRecognizer view];
    UIImage *image = img.image;
    EditorModel * model =[EditorModel sharedObject];
    [model setImage:image];
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"back");
        
    }];

}

- (void)closeSelected:(id)sender 
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"back");
    
    }];
}

@end

