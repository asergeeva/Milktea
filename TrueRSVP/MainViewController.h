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

@interface MainViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
//	IBOutlet UINavigationBar *navBar;
	ProfileViewController *profileVC;
	AttendingViewController *attendingVC;
//	UIView *attendingView;
	UIView *hostingView;
	UIViewController *currentVC;
	UIView *segmentButtons;
	UIButton *profileButton;
	UIButton *attendingButton;
	UIButton *hostingButton;
	CGFloat animatedDistance;
}
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) ProfileViewController *profileVC;
@property (nonatomic, retain) AttendingViewController *attendingVC;
//@property (nonatomic, retain) UIView *attendingView;
@property (nonatomic, retain) UIView *hostingView;
@property (nonatomic, retain) UIViewController *currentVC;
@property (nonatomic, retain) UIView *segmentButtons;
@property (nonatomic, retain) UIButton *profileButton;
@property (nonatomic, retain) UIButton *attendingButton;
@property (nonatomic, retain) UIButton *hostingButton;
@property (nonatomic) CGFloat animatedDistance;
@end
