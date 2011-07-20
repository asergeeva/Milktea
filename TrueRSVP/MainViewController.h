//
//  MainViewController.h
//  TrueRSVP
//
//  Created by movingincircles on 7/18/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MainViewController : UIViewController <UserDelegate> {
//	IBOutlet UINavigationBar *navBar;
	UIView *profileView;
	UIView *attendingView;
	UIView *hostingView;
	UIView *segmentButtons;
	UIButton *profileButton;
	UIButton *attendingButton;
	UIButton *hostingButton;
	
	//Profile
	IBOutlet UILabel *nameLabel;
	IBOutlet UITextField *emailTextField;
	IBOutlet UITextField *cellTextField;
	IBOutlet UITextField *zipTextField;
	IBOutlet UITextField *twitterTextField;
	IBOutlet UITextView *aboutTextView;
	IBOutlet UIButton *updateButton;
}
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) UIView *profileView;
@property (nonatomic, retain) UIView *attendingView;
@property (nonatomic, retain) UIView *hostingView;
@property (nonatomic, retain) UIView *segmentButtons;
@property (nonatomic, retain) UIButton *profileButton;
@property (nonatomic, retain) UIButton *attendingButton;
@property (nonatomic, retain) UIButton *hostingButton;

//Profile
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *cellTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *twitterTextField;
@property (nonatomic, retain) IBOutlet UITextView *aboutTextView;
@property (nonatomic, retain) UIButton *updateButton;
@end
