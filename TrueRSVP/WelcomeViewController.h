//
//  WelcomeViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface WelcomeViewController : UIViewController
{
	NSMutableString *fullName;
	MainViewController *main;
	IBOutlet UIButton *hostButton;
	IBOutlet UIButton *guestButton;
	IBOutlet UIImageView *logo;
}
- (void)hostPressed;
- (void)guestPressed;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString*)name mainVC:(MainViewController*)mainVC;
- (void)dismissWelcome:(id)sender;
@property (nonatomic, retain) NSMutableString *fullName;
@property (nonatomic, retain) UINavigationBar *welcomeBar;
@end
