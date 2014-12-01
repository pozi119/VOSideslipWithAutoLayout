//
//  VOSideslipController.m
//  VOSideslipWithAutoLayout
//
//  Created by Valo Lee on 14-12-1.
//  Copyright (c) 2014年 valo. All rights reserved.
//

#import "VOSideslipController.h"
#import "AppDelegate.h"
#import "UIImage+ImageEffects.h"

#define kSideslipDuration 0.5

typedef NS_ENUM(NSUInteger, VOSideslipMoveDirection) {
	VOSideslipNoMoving,
	VOSideslipMoveToLeft,
	VOSideslipMoveToRight,
};

@interface VOSideslipController ()

@property (nonatomic, weak) AppDelegate *app;

@property (weak, nonatomic) IBOutlet UIView      *centerContainer;
@property (weak, nonatomic) IBOutlet UIView      *leftContainer;
@property (weak, nonatomic) IBOutlet UIView      *rightContainer;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewPositionConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewPostionConstaint;

@property (nonatomic, strong) NSLayoutConstraint *leftViewMoveConstaint;
@property (nonatomic, strong) NSLayoutConstraint *rightViewMoveConstaint;

@end

@implementation VOSideslipController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.app = [UIApplication sharedApplication].delegate;
	self.app.sideslip = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	self.leftViewMoveConstaint = self.leftViewPositionConstaint;
	self.rightViewMoveConstaint = self.rightViewPostionConstaint;
}

- (void)setState:(VOSideslipState)state{
	CGFloat blurImageAlpha = 1.0;
	switch (state) {
		case VOSideslipStateShowCenter:
			self.leftViewMoveConstaint.constant = 0;
			self.rightViewMoveConstaint.constant = 0;
			blurImageAlpha = 0.0;
			break;
		case VOSideslipStateShowLeft:
			self.leftViewMoveConstaint.constant = -self.leftContainer.bounds.size.width;
			break;
		case VOSideslipStateShowRight:
			self.rightViewMoveConstaint.constant = -self.rightContainer.bounds.size.width;
			break;
			
		default:
			break;
	}
	[UIView animateWithDuration:kSideslipDuration animations:^{
		[self.view layoutIfNeeded];
		self.blurImageView.alpha = blurImageAlpha;
	} completion:^(BOOL finished) {
		_state = state;
	}];
}

- (void)showLeftView{
	if (self.state != VOSideslipStateShowLeft) {
		if (self.state != VOSideslipStateShowCenter) {
			self.state = VOSideslipStateShowCenter;
		}
		[self updateBlurImageView];
		self.state = VOSideslipStateShowLeft;
	}
}

- (void)showRightView{
	if (self.state != VOSideslipStateShowRight) {
		if (self.state != VOSideslipStateShowCenter) {
			self.state = VOSideslipStateShowCenter;
		}
		[self updateBlurImageView];
		self.state = VOSideslipStateShowRight;
	}
}

- (void)showCenterView{
	if (self.state != VOSideslipStateShowCenter) {
		self.state = VOSideslipStateShowCenter;
	}
}

#pragma mark 屏幕截图
- (void)updateBlurImageView {
	UIGraphicsBeginImageContext(self.centerContainer.bounds.size);
	[self.centerContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.blurImageView.image = [image applyBlurWithRadius: 20
										   tintColor: nil
							   saturationDeltaFactor: 1.5
										   maskImage: nil];
	self.blurImageView.alpha = 0.0;
}

- (void)moveLeftViewToPos: (CGFloat)pos{
	self.leftViewMoveConstaint.constant = MAX(MIN(0, pos), -self.leftContainer.bounds.size.width);
	self.blurImageView.alpha = ABS(pos)/ self.leftContainer.bounds.size.width;
	[self.view layoutIfNeeded];
}

- (void)moveRightViewToPos: (CGFloat)pos{
	self.rightViewMoveConstaint.constant = MAX(MIN(0, pos), -self.rightContainer.bounds.size.width);
	self.blurImageView.alpha = ABS(pos)/ self.rightContainer.bounds.size.width;
	[self.view layoutIfNeeded];
}

- (void)edgePanAction:(UIPanGestureRecognizer *)sender {
	CGPoint trans = [sender translationInView:[UIApplication sharedApplication].keyWindow];
	static CGPoint startTrans;
	static CGFloat startPos;
	static VOSideslipMoveDirection moveDirection; // 0,不移动; 1,向左; 2,向右;
	switch (sender.state) {
		case UIGestureRecognizerStateBegan:
			startTrans = trans;
			break;
		case UIGestureRecognizerStateChanged:
			if (trans.x - startTrans.x > 5) {
				moveDirection = VOSideslipMoveToRight;
			}
			else if(startTrans.x - trans.x > 5){
				moveDirection = VOSideslipMoveToLeft;
			}
			else{
				moveDirection = VOSideslipNoMoving;
			}
			switch (self.state) {
				case VOSideslipStateShowCenter:
					if (moveDirection == VOSideslipMoveToRight) {
						[self updateBlurImageView];
						self.state = VOSideslipStateMovingLeft;
					}
					else if(moveDirection == VOSideslipMoveToLeft){
						[self updateBlurImageView];
						self.state = VOSideslipStateMovingRight;
					}
					startPos = 0;
					break;
				case VOSideslipStateShowLeft:
					if (moveDirection == VOSideslipMoveToLeft) {
						self.state = VOSideslipStateMovingLeft;
						startPos = -self.leftContainer.bounds.size.width;
					}
					break;
				case VOSideslipStateShowRight:
					if (moveDirection == VOSideslipMoveToRight) {
						self.state = VOSideslipStateMovingRight;
						startPos = -self.rightContainer.bounds.size.width;
					}
					break;
				case VOSideslipStateMovingLeft:
					[self moveLeftViewToPos:startPos - trans.x];
					break;
				case VOSideslipStateMovingRight:
					[self moveRightViewToPos:startPos + trans.x];
					break;
					
				default:
					break;
			}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			switch (self.state) {
				case VOSideslipStateMovingLeft:
					if ((moveDirection == VOSideslipMoveToLeft && startPos - trans.x > -self.leftContainer.bounds.size.width * 0.7)  ||
						(moveDirection == VOSideslipMoveToRight && startPos - trans.x > -self.leftContainer.bounds.size.width * 0.3)){
						self.state = VOSideslipStateShowCenter;
					}
					else{
						self.state = VOSideslipStateShowLeft;
					}
					break;
				case VOSideslipStateMovingRight:
					if ((moveDirection == VOSideslipMoveToLeft && startPos + trans.x > -self.rightContainer.bounds.size.width * 0.3) ||
						(moveDirection == VOSideslipMoveToRight && startPos + trans.x > -self.rightContainer.bounds.size.width * 0.7)){
						self.state = VOSideslipStateShowCenter;
					}
					else{
						self.state = VOSideslipStateShowRight;
					}
					break;
					
				default:
					break;
			}
			break;
			
		default:
			break;
	}
}
@end
