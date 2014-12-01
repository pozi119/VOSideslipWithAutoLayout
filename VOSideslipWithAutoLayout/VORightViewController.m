//
//  VORightViewController.m
//  VOSideslipWithAutoLayout
//
//  Created by Valo Lee on 14-12-1.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VORightViewController.h"
#import "AppDelegate.h"

@interface VORightViewController ()
@property (nonatomic, weak) AppDelegate *app;

@end

@implementation VORightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.app = [UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapToHide:(UITapGestureRecognizer *)sender {
	[self.app.sideslip showCenterView];
}

- (IBAction)edgePanAction:(UIPanGestureRecognizer *)sender {
	[self.app.sideslip edgePanAction:sender];
}

@end
