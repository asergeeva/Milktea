//
//  ProfileViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "Constants.h"
#import "SettingsManager.h"
@implementation ProfileViewController
//Profile
@synthesize nameLabel;
@synthesize emailTextField;
@synthesize cellTextField;
@synthesize zipTextField;
@synthesize twitterTextField;
@synthesize aboutTextView;
@synthesize whiteBackground;
@synthesize updateButton;
@synthesize profilePic;
@synthesize welcomeBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//		[[textViewStatus layer] setBorderColor:[[UIColor whiteColor] CGColor]];
//		[[textViewStatus layer] setBorderWidth:2.3];
//		[[textViewStatus layer] setCornerRadius:15];
//		[textViewStatus setClipsToBounds: YES];
    }
    return self;
}

- (void)dealloc
{
	[nameLabel release];
	[emailTextField release];
	[cellTextField release];
	[zipTextField release];
	[twitterTextField release];
	[aboutTextView release];
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
- (void)viewDidLoad
{
//	self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APILocation, @"getUserInfo/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	NSDictionary *userInfo = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	[User sharedUser].delegate = self;
	[[User sharedUser] updateUser:userInfo];
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
    [UIView commitAnimations];
}
- (void)updatedStrings
{
	User *user = [User sharedUser];
	nameLabel.text = user.fullName;
	emailTextField.text = user.email;
	cellTextField.text = user.cell;
	zipTextField.text = user.zip;
	//	twitterTextField.text = user.twitter;
	aboutTextView.text = [NSString stringWithFormat:@"%@",user.about];
	
	if(![SettingsManager sharedSettingsManager].welcomeDismissed)
	{
		welcomeBar = [[UINavigationBar alloc] initWithFrame:self.view.frame];
		CGRect rect = welcomeBar.frame;
		rect.size.height = 44;
		rect.origin.y = 00;
		welcomeBar.frame = rect;
		welcomeBar.tintColor = [UIColor colorWithRed:0.992 green:0.800 blue:0.424 alpha:1.000];
//		welcomeBar.topItem.title = @"Welcome";
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
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationBeginsFromCurrentState:YES];
		rect = self.welcomeBar.frame;
		rect.origin.y += 44;
		self.welcomeBar.frame = rect; 
		[UIView commitAnimations];
		
	}
}
- (void)updatedImages
{
	profilePic.image = [User sharedUser].profilePic;
}
@end
