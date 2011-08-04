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
	IBOutlet UIButton *loginButton;
	IBOutlet UIButton *fbButton;
	Facebook *facebook;
}
- (void)showDebugView:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)facebookLogin:(id)sender;
- (void)setViewMoveUp:(BOOL)moveUp;
@property (nonatomic, retain) Facebook *facebook;
@end
