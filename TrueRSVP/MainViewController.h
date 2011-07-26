//
//  MainViewController.h
//  TrueRSVP
//
//  Created by movingincircles on 7/18/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ProfileViewController.h"
#import "AttendingViewController.h"
#import "HostingViewController.h"
@interface MainViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, AttendingDelegate, HostingDelegate, UINavigationControllerDelegate> {
//	IBOutlet UINavigationBar *navBar;
	ProfileViewController *profileVC;
	AttendingViewController *attendingVC;
	HostingViewController *hostingVC;
//	UIView *attendingView;
//	UIView *hostingView;
//	UIViewController *currentVC;
	UIView *segmentButtons;
	UIButton *profileButton;
	UIButton *attendingButton;
	UIButton *hostingButton;
	CGFloat animatedDistance;
	IBOutlet UIScrollView *scrollView;
//	IBOutlet UIPageControl *pageControl;
}
- (void)setTextFieldDelegates:(UIView*)mainView;
- (void)profileTabSelected:(id)sender;
- (void)attendingTabSelected:(id)sender;
- (void)hostingTabSelected:(id)sender;
- (void)setupScrolling;
- (void)resetRotation:(UIViewController*)viewController duration:(NSTimeInterval)duration;
- (void)resetScrollViewContentSize:(UIInterfaceOrientation)toInterfaceOrientation;
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) ProfileViewController *profileVC;
@property (nonatomic, retain) AttendingViewController *attendingVC;
@property (nonatomic, retain) HostingViewController *hostingVC;
//@property (nonatomic, retain) UIView *attendingView;
//@property (nonatomic, retain) UIView *hostingView;
//@property (nonatomic, retain) UIViewController *currentVC;
@property (nonatomic, retain) UIView *segmentButtons;
@property (nonatomic, retain) UIButton *profileButton;
@property (nonatomic, retain) UIButton *attendingButton;
@property (nonatomic, retain) UIButton *hostingButton;
@property (nonatomic) CGFloat animatedDistance;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@end
