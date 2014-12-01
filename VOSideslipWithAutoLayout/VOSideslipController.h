//
//  VOSideslipController.h
//  VOSideslipWithAutoLayout
//
//  Created by Valo Lee on 14-12-1.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VOSideslipState) {
	VOSideslipStateShowCenter,
	VOSideslipStateShowLeft,
	VOSideslipStateShowRight,
	VOSideslipStateMovingLeft,
	VOSideslipStateMovingRight,
};

@interface VOSideslipController : UIViewController

@property (nonatomic, assign) VOSideslipState state;

- (void)showLeftView;
- (void)showRightView;
- (void)showCenterView;
- (void)edgePanAction:(UIPanGestureRecognizer *)sender;

@end
