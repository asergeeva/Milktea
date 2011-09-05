//
//  TrueRSVPViewController.h
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "TrueRSVPAppDelegate.h"
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "NetworkManager.h"
@interface SignInViewController : UIViewController <UITextFieldDelegate, FBSessionDelegate, FBRequestDelegate, ASIHTTPRequestDelegate, NetworkManagerDelegate> {
	IBOutlet UITextField *txtUsername;
	IBOutlet UITextField *txtPassword;
	IBOutlet UIButton *loginButton;
	IBOutlet UIButton *fbButton;
	Facebook *facebook;
	NSMutableString *sessionKey;
	IBOutlet UILabel *orLabel;
//		NSTimer *timer;
}
- (void)showDebugView:(id)sender;
- (IBAction)loginPressed:(UIButton*)sender;
- (IBAction)facebookLogin:(id)sender;
- (void)setViewMoveUp:(BOOL)moveUp;
- (void)login;
- (void)progressFinished;
- (void)finishedSignIn;
@property (nonatomic, retain) Facebook *facebook;
//@property (nonatomic, assign) NSTimer *timer;
@end
