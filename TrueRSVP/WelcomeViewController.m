//
//  WelcomeViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/22/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "WelcomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlurryAnalytics.h"
@implementation WelcomeViewController
@synthesize welcomeBar;
@synthesize fullName;
BOOL welcomeShown = NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString*)name mainVC:(MainViewController*)mainVC
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		fullName = [[NSMutableString alloc] init];
		[fullName setString:name];
		main = mainVC;
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)hostPressed
{
	[FlurryAnalytics logEvent:@"WELCOME_I_AM_HOST"];
	[main hostingTabSelected:nil];
	[main dismissModalViewControllerAnimated:YES];
}
- (void)attendeePressed
{
	[FlurryAnalytics logEvent:@"WELCOME_I_AM_ATTENDEE"];
	[main attendingTabSelected:nil];
	[main dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	if(!welcomeShown && self.view.frame.size.width < 400 && UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
	{
		welcomeBar = [[UINavigationBar alloc] initWithFrame:self.view.frame];
		CGRect rect = welcomeBar.frame;
		rect.size.height = 44;
		rect.origin.y = 0;
		welcomeBar.frame = rect;
		welcomeBar.tintColor = [UIColor colorWithRed:0.286 green:0.761 blue:0.878 alpha:1.000];
		
		UILabel *label = [[UILabel alloc] initWithFrame:welcomeBar.bounds];
		label.textAlignment = UITextAlignmentCenter;
		label.text = [NSString stringWithFormat:@"Welcome %@!", fullName];
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		label.backgroundColor = [UIColor clearColor];
		label.layer.shadowOpacity = 0.2;
		label.layer.shadowOffset = CGSizeMake(0.0, 2.0);
		label.layer.rasterizationScale = [[UIScreen mainScreen] scale];
		label.layer.shouldRasterize = YES;
		[welcomeBar addSubview:label];
		
		UIButton *xButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 10, 16, 24)];
		[xButton setImage:[UIImage imageNamed:@"Profile_X.png"] forState:UIControlStateNormal];
		[xButton addTarget:self action:@selector(dismissWelcome:) forControlEvents:UIControlEventTouchUpInside];
		[welcomeBar addSubview:xButton];
		
		[self.view addSubview:welcomeBar];
		[xButton release];
		[label release];
		
		//Scroll down animation
		[UIView animateWithDuration:0.3 animations:^{
			CGRect rect = welcomeBar.frame;
			rect = self.welcomeBar.frame;
			rect.origin.y += self.navigationController.navigationBar.frame.size.height;
			self.welcomeBar.frame = rect; 
		}];
		welcomeShown = YES;
	}
	else
	{
		CGRect frame = self.view.bounds;
		frame.origin.y = 44;
		self.view.bounds = frame;
	}
	[super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	hostButton.layer.cornerRadius = 5;
	hostButton.clipsToBounds = YES;
	hostButton.layer.shouldRasterize = YES;
	attendeeButton.layer.cornerRadius = 5;
	attendeeButton.clipsToBounds = YES;
	attendeeButton.layer.shouldRasterize = YES;
	welcomeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Do any additional setup after loading the view from its nib.
	[hostButton addTarget:self action:@selector(hostPressed) forControlEvents:UIControlEventTouchUpInside];
	[attendeeButton addTarget:self action:@selector(attendeePressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
	[hostButton release];
	hostButton = nil;
	[attendeeButton release];
	attendeeButton = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self dismissWelcome:nil];
	return YES;
//	return NO;
}
- (void)dealloc
{
	[welcomeBar release];
	[fullName release];
	[hostButton release];
	[attendeeButton release];
	[super dealloc];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		CGRect rect = self.view.frame;
		rect.origin.x = 0;
		rect.size.width = 344;
		rect.size.height = 480;
		self.view.frame = rect;
//		self.view.frame = CGRectMake(-204.0, 0.0, 480.0, 320.0);
	}
	else
	{
//		CGRect rect = self.view.frame;
//		rect.origin.y += 44;
//		rect.size.height += 44;
//		self.view.frame = rect;
//		self.view.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
#pragma mark - Other
- (void)dismissWelcome:(id)sender
{
	[UIView animateWithDuration:0.3 animations:^{
		CGRect rect = self.welcomeBar.frame;
		rect.origin.y -= 44;
		self.welcomeBar.frame = rect; 
		welcomeBar.layer.opacity = 0.0;
	}];
}
@end
