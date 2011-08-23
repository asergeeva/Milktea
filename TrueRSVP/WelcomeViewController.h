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
	IBOutlet UIButton *hostButton;
	IBOutlet UIButton *attendeeButton;
	MainViewController *main;
}
- (void)hostPressed;
- (void)attendeePressed;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString*)name mainVC:(MainViewController*)mainVC;
- (void)dismissWelcome:(id)sender;
@property (nonatomic, retain) NSMutableString *fullName;
@property (nonatomic, retain) UINavigationBar *welcomeBar;
@end
