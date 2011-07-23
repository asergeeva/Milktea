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
@implementation ProfileViewController
@synthesize nameLabel;
@synthesize emailLabel;
@synthesize cellLabel;
@synthesize zipLabel;
@synthesize twitterLabel;
@synthesize aboutLabel;
@synthesize emailTextField;
@synthesize cellTextField;
@synthesize zipTextField;
@synthesize twitterTextField;
@synthesize aboutTextView;
@synthesize aboutImageView;
@synthesize whiteBackground;
@synthesize updateButton;
@synthesize profilePic;
@synthesize welcomeBar;
@synthesize welcomeShown;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

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
	[aboutImageView release];
	[whiteBackground release];
	[updateButton release];
	[profilePic release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
			[view resignFirstResponder];	
	}	
}

- (void)refreshProfile
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APILocation, @"getUserInfo/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	NSDictionary *userInfo = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	[User sharedUser].delegate = self;
	[[User sharedUser] updateUser:userInfo];
	[self updatedImages];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self refreshProfile];
	whiteBackground.layer.cornerRadius = 5;
	whiteBackground.clipsToBounds = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
- (void)dismissWelcome:(id)sender
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect rect = self.welcomeBar.frame;
	rect.origin.y -= 44;
    self.welcomeBar.frame = rect; 
	welcomeBar.layer.opacity = 0.0;
    [UIView commitAnimations];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	if([request.responseString isEqualToString:@"status_updateCompleted"])
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
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" 
													message:@"Update failed, please try again later."
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
- (IBAction)updateProfile:(id)sender
{	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", APILocation, @"setProfile"]]];
	[request addPostValue:emailTextField.text forKey:@"email"];
	[request addPostValue:aboutTextView.text forKey:@"about"];
	[request addPostValue:cellTextField.text forKey:@"cell"];
	[request addPostValue:zipTextField.text forKey:@"zip"];
	[request addPostValue:twitterTextField.text forKey:@"twitter"];
	request.delegate = self;
	[request startAsynchronous];
}
- (void)updatedStrings
{
	User *user = [User sharedUser];
	nameLabel.text = user.fullName;
	emailTextField.text = user.email;
	cellTextField.text = user.cell;
	zipTextField.text = user.zip;
	twitterTextField.text = user.twitter;
	aboutTextView.text = user.about;
	if(!welcomeShown && self.view.frame.size.width < 400)
	{
		welcomeBar = [[UINavigationBar alloc] initWithFrame:self.view.frame];
		CGRect rect = welcomeBar.frame;
		rect.size.height = 44;
		rect.origin.y = 00;
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
		[welcomeBar addSubview:label];
		
		UIButton *xButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 10, 16, 24)];
		[xButton setImage:[UIImage imageNamed:@"Profile_X.png"] forState:UIControlStateNormal];
		[xButton addTarget:self action:@selector(dismissWelcome:) forControlEvents:UIControlEventTouchUpInside];
		[welcomeBar addSubview:xButton];
		
		[self.view addSubview:welcomeBar];
		[xButton release];
		[label release];
		
		//Scroll down animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationBeginsFromCurrentState:YES];
		rect = self.welcomeBar.frame;
		rect.origin.y += 44;
		self.welcomeBar.frame = rect; 
		[UIView commitAnimations];
		welcomeShown = YES;
	}
}
- (void)updatedImages
{
	profilePic.image = [User sharedUser].profilePic;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		[self dismissWelcome:nil];
		whiteBackground.frame = CGRectMake(4, 76, 210, 210);
		aboutImageView.frame = CGRectMake(323, 120, 149, 79);
		profilePic.frame = CGRectMake(16, 87, 188, 188);
		emailTextField.frame = CGRectMake(222, 74, 250, 31);
		cellTextField.frame = CGRectMake(222, 120, 93, 31);
		zipTextField.frame = CGRectMake(222, 168, 93, 31);
		twitterTextField.frame = CGRectMake(222, 214, 250, 31);
		aboutTextView.frame = CGRectMake(328, 120, 145, 79);
		nameLabel.frame = CGRectMake(4, 53, 210, 21);
		emailLabel.frame = CGRectMake(222, 53, 42, 21);
		cellLabel.frame = CGRectMake(222, 100, 42, 21);
		aboutLabel.frame = CGRectMake(323, 100, 42, 21);
		zipLabel.frame = CGRectMake(222, 148, 42, 21);
		twitterLabel.frame = CGRectMake(222, 196, 105, 21);
		updateButton.frame = CGRectMake(253, 253, 183, 27);
		self.view.frame = CGRectMake(-2.0, 10.0, 480.0, 320.0);
	}
	else
	{
		whiteBackground.frame = CGRectMake(14, 120, 135, 135);
		aboutImageView.frame = CGRectMake(13, 264, 136, 81);
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
		updateButton.frame = CGRectMake(69, 374, 183, 27);
		aboutLabel.frame = CGRectMake(400, 0, 0, 0);
		self.view.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
@end
