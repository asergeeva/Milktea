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
@interface ProfileViewController : UIViewController <UserDelegate, ASIHTTPRequestDelegate> {
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
	IBOutlet UITextView *aboutTextView;
	IBOutlet UIImageView *aboutImageView;
	IBOutlet UITextView *whiteBackground;
	IBOutlet UIButton *updateButton;
	IBOutlet UIImageView *profilePic;
	IBOutlet UIView *portrait;
//	IBOutlet UIView *landscape;
//	UINavigationBar *welcomeBar;
	BOOL welcomeShown;
}
- (IBAction)updateProfile:(id)sender;
- (void)dismissWelcome:(id)sender;
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *cellLabel;
@property (nonatomic, retain) IBOutlet UILabel *zipLabel;
@property (nonatomic, retain) IBOutlet UILabel *twitterLabel;
@property (nonatomic, retain) IBOutlet UILabel *aboutLabel;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *cellTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *twitterTextField;
@property (nonatomic, retain) IBOutlet UITextView *aboutTextView;
@property (nonatomic, retain) IBOutlet UIImageView *aboutImageView;
@property (nonatomic, retain) IBOutlet UITextView *whiteBackground;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet UIImageView *profilePic;
@property (nonatomic, retain) UINavigationBar *welcomeBar;
//@property (nonatomic, retain) IBOutlet UIView *portrait;
//@property (nonatomic, retain) IBOutlet UIView *landscape;
@property (nonatomic) BOOL welcomeShown;
@end
