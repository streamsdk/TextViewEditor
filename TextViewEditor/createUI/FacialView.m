//
//  FacialView.m
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacialView.h"


@implementation FacialView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		//[self addSubview:loadFacial];
        [self setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}
-(void)loadFacialView:(int)page size:(CGSize)size
{
	//row number
	for (int i=0; i<4; i++) {
		//column numer
		for (int y=0; y<7; y++) {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *curImage= [UIImage imageNamed:[NSString stringWithFormat:@"emotion%d",i*7+y+(page*28)+1]];
            if (curImage!=nil) {
                [button setBackgroundColor:[UIColor grayColor]];
                [button setImage:curImage forState:UIControlStateNormal];
                [button setFrame:CGRectMake(0+y*size.width, 0+i*size.height, size.width, size.height)];
                button.tag=i*7+y+(page*28)+1;
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
		}
	}
}


-(void)selected:(UIButton*)bt
{
	NSString *str=[NSString stringWithFormat:@"emotion%d.png",bt.tag];
	[delegate selectedFacialView:str];
}


@end
