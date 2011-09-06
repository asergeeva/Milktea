//
//  ProfileViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CJSONDeserializer.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "NetworkManager.h"
#import "TrueRSVPAppDelegate.h"
#import "LocationManager.h"
@implementation ProfileViewController
@synthesize welcomeBar;
@synthesize welcomeShown;
@synthesize profilePic;
@synthesize aboutButton;
- (void)dealloc
{
	[nameLabel release];
	[emailLabel release];
	[cellLabel release];
	[zipLabel release];
	[twitterLabel release];
	[aboutLabel release];
	[emailTextField release];
	[cellTextField release];
	[zipTextField release];
	[twitterTextField release];
	[aboutTextView release];
	[whiteBackground release];;
	[updateButton release];
	[profilePic release];
    [signOut release];
	[NetworkManager sharedNetworkManager].profileDelegate = nil;
	[aboutButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)resignKeyboard
{
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UIPlaceHolderTextView class]])
			[view resignFirstResponder];	
	}	
}
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event 
{
	[self resignKeyboard];
}
- (IBAction)popAll:(id)sender
{
	[FlurryAnalytics logEvent:@"PROFILE_SIGNED_OUT"];
	[[LocationManager sharedLocationManager] removeAllEvents];
	[((TrueRSVPAppDelegate*)[UIApplication sharedApplication].delegate).navController popToRootViewControllerAnimated:YES];
}

- (void)refreshProfile
{
	[User sharedUser].delegate = self;
	[[User sharedUser] updateUser:[NetworkManager sharedNetworkManager].profile];
	[self updatedImages];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[NetworkManager sharedNetworkManager].profileDelegate = self;
	[User sharedUser].delegate = self;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignKeyboard) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // Do any additional setup after loading the view from its nib.
	[self refreshProfile];
	if([UIDevice currentDevice].multitaskingSupported)
	{
		whiteBackground.layer.cornerRadius = 5;
		whiteBackground.layer.shadowOffset = CGSizeMake(0.0, 0.2);
		whiteBackground.layer.shadowOpacity = 0.25;
		whiteBackground.layer.shouldRasterize = YES;
	}
	updateButton.layer.cornerRadius = 5;
	updateButton.clipsToBounds = YES;
	updateButton.layer.shouldRasterize = YES;
	aboutButton.layer.cornerRadius = 5;
	aboutButton.clipsToBounds = YES;
	aboutButton.layer.shouldRasterize = YES;
	aboutButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	signOut.layer.cornerRadius = 5;
	signOut.clipsToBounds = YES;
	signOut.layer.shouldRasterize = YES;
	signOut.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	aboutTextView.layer.cornerRadius = 5;
	aboutTextView.layer.borderWidth = 2.0;
	aboutTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	[aboutTextView setPlaceholder:@"About me..."];
	profilePic.contentMode = UIViewContentModeScaleAspectFit;
//	profilePic.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewDidUnload
{
	[profilePic release];
	profilePic = nil;
	[whiteBackground release];
	whiteBackground = nil;
	[portrait release];
	portrait = nil;
    [signOut release];
    signOut = nil;
	[aboutButton release];
	aboutButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[self resignKeyboard];
	[super viewWillDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
- (void)dismissWelcome:(id)sender
{
	[UIView animateWithDuration:0.3 animations:^{
    CGRect rect = self.welcomeBar.frame;
	rect.origin.y -= 44;
    self.welcomeBar.frame = rect; 
	welcomeBar.layer.opacity = 0.0;
	}];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" 
													message:@"Profile has been updated."
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self refreshProfile];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" 
													message:@"Profile update failed, please try again later."
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
- (void)updateProfile
{
//	[[User sharedUser] updateUser:[NetworkManager sharedNetworkManager].profile];
	[self updatedStrings];
	[self updatedImages];
}
- (IBAction)updateProfile:(id)sender
{	
	[self resignKeyboard];
	NSString *test = [cellTextField.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
	test = [test stringByReplacingOccurrencesOfString:@")" withString:@""];
	test = [test stringByReplacingOccurrencesOfString:@" " withString:@""];
	test = [test stringByReplacingOccurrencesOfString:@"-" withString:@""];
	NSNumberFormatter *isNumber = [[NSNumberFormatter alloc] init];
	NSNumber *number = [isNumber numberFromString:test];
	[isNumber release];
	if(test.length != 10 || number == nil)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Cell"
														message:@"The cell phone number is invalid."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		cellTextField.text = [User sharedUser].cell;
		return;
	}
	[[User sharedUser].email setString:emailTextField.text];	
	[[User sharedUser].cell setString:cellTextField.text];	
	[[User sharedUser].zip setString:zipTextField.text];	
	if([twitterTextField.text hasPrefix:@"@"])
	{
		[[User sharedUser].twitter setString:[twitterTextField.text substringFromIndex:1]];
	}
	else
	{
		[[User sharedUser].twitter setString:twitterTextField.text];	
	}
	[[User sharedUser].about setString:aboutTextView.text];	
	[[NetworkManager sharedNetworkManager] updateProfileWithEmail:emailTextField.text about:aboutTextView.text cell:test zip:zipTextField.text twitter:twitterTextField.text delegate:self];
//	[[NetworkManager sharedNetworkManager] refreshAllWithDelegate:self completion:@selector(updateGUIProfile)];
}
- (void)updatedStrings
{
	User *user = [User sharedUser];
	nameLabel.text = user.fullName;
	emailTextField.text = user.email;
	cellTextField.text = user.cell;
	zipTextField.text = user.zip;
	if([user.twitter hasPrefix:@"@"])
	{
		twitterTextField.text = user.twitter;
	}
	else
	{
		twitterTextField.text = [NSString stringWithFormat:@"@%@", user.twitter];
	}
//	[user.about setString:@""];
	aboutTextView.text = user.about;
	if(!welcomeShown && self.view.frame.size.width < 400)
	{
		welcomeBar = [[UINavigationBar alloc] initWithFrame:self.view.frame];
		CGRect rect = welcomeBar.frame;
		rect.size.height = 44;
		rect.origin.y = 44;
		welcomeBar.frame = rect;
		welcomeBar.tintColor = [UIColor colorWithRed:0.992 green:0.800 blue:0.424 alpha:1.000];
		
		UILabel *label = [[UILabel alloc] initWithFrame:welcomeBar.bounds];
		label.textAlignment = UITextAlignmentCenter;
		label.text = [NSString stringWithFormat:@"Welcome %@!", user.fullName];
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
}
- (void)updatedImages
{
//	[profilePic.imageView setImage:[User sharedUser].profilePic];
	[profilePic setBackgroundImage:[User sharedUser].profilePic forState:UIControlStateNormal];
//	[profilePic setImage:[User sharedUser].profilePic forState:UIControlStateNormal];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		[self dismissWelcome:nil];
		CGFloat topMargin = 5.0;
		whiteBackground.frame = CGRectMake(10, 76 + topMargin, 168, 168);
		profilePic.frame = CGRectMake(22, 87 + topMargin, 145, 145);
//		[profilePic setImage:[User sharedUser].profilePic forState:UIControlStateNormal];
		emailTextField.frame = CGRectMake(191, 74 + topMargin, 279, 31);
		cellTextField.frame = CGRectMake(191, 120 + topMargin, 124, 31);
		zipTextField.frame = CGRectMake(191, 168 + topMargin, 124, 31);
		twitterTextField.frame = CGRectMake(191, 214 + topMargin, 279, 31);
		aboutTextView.frame = CGRectMake(323, 120 + topMargin, 149, 79);
		nameLabel.frame = CGRectMake(10, 53 + topMargin, 173, 21);
		emailLabel.frame = CGRectMake(191, 53 + topMargin, 42, 21);
		cellLabel.frame = CGRectMake(191, 100 + topMargin, 42, 21);
		aboutLabel.frame = CGRectMake(323, 100 + topMargin, 42, 21);
		zipLabel.frame = CGRectMake(191, 148 + topMargin, 42, 21);
		twitterLabel.frame = CGRectMake(191, 196 + topMargin, 105, 21);
		updateButton.frame = CGRectMake(180, 265, 120, 27);
		signOut.frame = CGRectMake(10, 265, 120, 27);
		aboutButton.frame = CGRectMake(350, 265, 120, 27);
		self.view.frame = CGRectMake(-2.0, 10.0, 480.0, 320.0);
	}
	else
	{
		whiteBackground.frame = CGRectMake(14, 120, 135, 135);
		profilePic.frame = CGRectMake(24, 131, 115, 115);
		emailTextField.frame = CGRectMake(157, 134, 149, 31);
		cellTextField.frame = CGRectMake(157, 193, 149, 31);
		zipTextField.frame = CGRectMake(157, 254, 149, 31);
		twitterTextField.frame = CGRectMake(157, 315, 149, 31);
		aboutTextView.frame = CGRectMake(14, 266, 135, 79);
		nameLabel.frame = CGRectMake(14, 98, 135, 21);
		emailLabel.frame = CGRectMake(157, 113, 42, 21);
		cellLabel.frame = CGRectMake(157, 173, 42, 21);
		zipLabel.frame = CGRectMake(157, 234, 42, 21);
		twitterLabel.frame = CGRectMake(157, 297, 105, 21);
		updateButton.frame = CGRectMake(69, 359, 183, 27);
		aboutLabel.frame = CGRectMake(400, 0, 0, 0);
		signOut.frame = CGRectMake(69, 394, 183, 27);
		aboutButton.frame = CGRectMake(69, 429, 183, 27);
		self.view.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
@end
