//
//  TrueRSVPViewController.h
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "TrueRSVPAppDelegate.h"
#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate, FBSessionDelegate> {
	IBOutlet UITextField *txtUsername;
	IBOutlet UITextField *txtPassword;
//	IBOutlet UINavigationBar *navBar;
	IBOutlet UIButton *loginButton;
	Facebook *facebook;
	IBOutlet UIButton *fbButton;
//	IBOutlet UIView *portraitView;
//	IBOutlet UIView *landscapeView;
}
- (void)showDebugView:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)facebookLogin:(id)sender;
- (void)setViewMoveUp:(BOOL)moveUp;
//- (void)orientationChanged:(id)sender;
@property (nonatomic, retain) IBOutlet UITextField *txtUsername;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIButton *fbButton;
//@property (nonatomic, retain) IBOutlet UIView *portraitView;
//@property (nonatomic, retain) IBOutlet UIView *landscapeView;
@end
