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
#import "AttendingListViewController.h"
#import "HostingViewController.h"
@interface MainViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, AttendingDelegate, HostingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
//	IBOutlet UINavigationBar *navBar;
	ProfileViewController *profileVC;
	AttendingListViewController *attendingVC;
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
	int pageNumber;
//	IBOutlet UIPageControl *pageControl;
}
- (void)launchCamera;
//- (void)updatedImages;
- (void)setTextFieldDelegates:(UIView*)mainView;
- (void)profileTabSelected:(id)sender;
- (void)attendingTabSelected:(id)sender;
- (void)hostingTabSelected:(id)sender;
- (void)setupScrolling;
- (void)resetRotation:(UIViewController*)viewController duration:(NSTimeInterval)duration;
- (void)resetScrollViewContentSize:(UIInterfaceOrientation)toInterfaceOrientation;
@property (nonatomic, retain) ProfileViewController *profileVC;
@property (nonatomic, retain) AttendingListViewController *attendingVC;
@property (nonatomic, retain) HostingViewController *hostingVC;
@property (nonatomic, retain) UIView *segmentButtons;
@property (nonatomic, retain) UIButton *profileButton;
@property (nonatomic, retain) UIButton *attendingButton;
@property (nonatomic, retain) UIButton *hostingButton;
@property (nonatomic) CGFloat animatedDistance;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic) int pageNumber;
@end
