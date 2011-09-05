//
//  ProfileViewController.h
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ASIFormDataRequest.h"
#import "UIPlaceHolderTextView.h"
#import "NetworkManager.h"
//#import "DebugView.h"
@interface ProfileViewController : UIViewController <UserDelegate, ASIHTTPRequestDelegate, NetworkManagerProfileDelegate> {
//    IBOutlet UINavigationBar *navBar;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *emailLabel;
	IBOutlet UILabel *cellLabel;
	IBOutlet UILabel *zipLabel;
	IBOutlet UILabel *twitterLabel;
	IBOutlet UILabel *aboutLabel;
	IBOutlet UITextField *emailTextField;
	IBOutlet UITextField *cellTextField;
	IBOutlet UITextField *zipTextField;
	IBOutlet UITextField *twitterTextField;
	IBOutlet UIPlaceHolderTextView *aboutTextView;
//	IBOutlet UIImageView *aboutImageView;
	IBOutlet UIView *whiteBackground;
	IBOutlet UIButton *updateButton;
	IBOutlet UIButton *profilePic;
	IBOutlet UIView *portrait;
	BOOL welcomeShown;
	IBOutlet UIButton *aboutButton;
	IBOutlet UIButton *signOut;
//	IBOutlet DebugView *view;
}
- (void)resignKeyboard;
- (IBAction)popAll:(id)sender;
- (IBAction)updateProfile:(id)sender;
- (void)dismissWelcome:(id)sender;
@property (nonatomic, retain) UINavigationBar *welcomeBar;
@property (nonatomic) BOOL welcomeShown;
@property (nonatomic, retain) UIButton *profilePic;
@property (nonatomic, retain) UIButton *aboutButton;
//@property (nonatomic, retain) IBOutlet DebugView *view;
@end
