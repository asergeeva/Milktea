//
//  ProfileViewController.h
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController <UserDelegate> {
//    IBOutlet UINavigationBar *navBar;
	IBOutlet UILabel *nameLabel;
	IBOutlet UITextField *emailTextField;
	IBOutlet UITextField *cellTextField;
	IBOutlet UITextField *zipTextField;
	IBOutlet UITextField *twitterTextField;
	IBOutlet UITextView *aboutTextView;
	IBOutlet UITextView *whiteBackground;
	IBOutlet UIButton *updateButton;
	IBOutlet UIImageView *profilePic;
	UINavigationBar *welcomeBar;
}
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *cellTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *twitterTextField;
@property (nonatomic, retain) IBOutlet UITextView *aboutTextView;
@property (nonatomic, retain) IBOutlet UITextView *whiteBackground;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet UIImageView *profilePic;
@property (nonatomic, retain) UINavigationBar *welcomeBar;
@end
