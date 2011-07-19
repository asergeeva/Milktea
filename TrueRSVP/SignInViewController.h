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
}
- (IBAction)login:(id)sender;
- (IBAction)facebookLogin:(id)sender;
- (void)setViewMoveUp:(BOOL)moveUp;
@property (nonatomic, retain) IBOutlet UITextField *txtUsername;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
//@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) Facebook *facebook;
@end
