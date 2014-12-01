//
//  VOCenterViewController.m
//  VOSideslipWithAutoLayout
//
//  Created by Valo Lee on 14-12-1.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOCenterViewController.h"
#import "AppDelegate.h"

@interface VOCenterViewController ()
@property (nonatomic, weak) AppDelegate *app;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation VOCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self redrawSubviews];
	self.app = [UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)redrawSubviews{
	self.leftButton.layer.masksToBounds = YES;
	self.leftButton.layer.cornerRadius = self.leftButton.bounds.size.width / 2;
	
	self.rightButton.layer.masksToBounds = YES;
	self.rightButton.layer.cornerRadius = self.rightButton.bounds.size.width / 2;
	
}

- (IBAction)showLeftView:(UIButton *)sender {
	if (self.app.sideslip.state != VOSideslipStateShowLeft) {
		[self.app.sideslip showLeftView];
	}
	else{
		[self.app.sideslip showCenterView];
	}
}

- (IBAction)showRightView:(UIButton *)sender {
	if (self.app.sideslip.state != VOSideslipStateShowRight) {
		[self.app.sideslip showRightView];
	}
	else{
		[self.app.sideslip showCenterView];
	}
}

- (IBAction)edgePanAction:(UIPanGestureRecognizer *)sender {
	[self.app.sideslip edgePanAction:sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
