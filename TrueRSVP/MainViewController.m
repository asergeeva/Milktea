//
//  MainViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/18/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "Constants.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
@implementation MainViewController
//@synthesize navBar;
@synthesize profileView;
@synthesize attendingView;
@synthesize hostingView;
@synthesize segmentButtons;
@synthesize profileButton;
@synthesize hostingButton;
@synthesize attendingButton;

//Profile
@synthesize nameLabel;
@synthesize emailTextField;
@synthesize cellTextField;
@synthesize zipTextField;
@synthesize twitterTextField;
@synthesize aboutTextView;
@synthesize updateButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		profileButton = [[UIButton alloc] init];
		hostingButton = [[UIButton alloc] init];
		attendingButton = [[UIButton alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[profileView release];
	[attendingView release];
	[hostingView release];
	[segmentButtons release];
	[profileButton release];
	[hostingButton release];
	[attendingButton release];
//	[navBar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)updatedProfile
{
	
}
- (void)profileTabSelected:(id)sender
{
	if(attendingButton.selected)
	{
		attendingButton.selected = NO;
		[attendingView removeFromSuperview];
	}
	else if(hostingButton.selected)
	{
		hostingButton.selected = NO;
		[hostingView removeFromSuperview];
	}
	if(!profileButton.selected)
	{
		profileButton.selected = YES;
		profileView.hidden = NO;
		//[self.view addSubview:profileView];
		//self.view = profileView;
	}
}
- (void)attendingTabSelected:(id)sender
{
	if(profileButton.selected)
	{
		profileButton.selected = NO;		
//		[profileView removeFromSuperview];
		profileView.hidden = YES;
	}
	else if(hostingButton.selected)
	{
		hostingButton.selected = NO;
		[hostingView removeFromSuperview];
	}
	if(!attendingButton.selected)
	{
		attendingButton.selected = YES;
		//Do stuff here
	}
	
	
}
- (void)hostingTabSelected:(id)sender
{
	if(profileButton.selected)
	{
		profileButton.selected = NO;		
//		[profileView removeFromSuperview];
		profileView.hidden = YES;
	}
	else if(attendingButton.selected)
	{
		attendingButton.selected = NO;
		[attendingView removeFromSuperview];
	}
	if(!hostingButton.selected)
	{
		hostingButton.selected = YES;
		//Do stuff here
	}
}
- (void)viewDidLoad
{

	[profileButton setImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
//	[profileButton setImage:[UIImage imageNamed:@"profile_selected.png"] forState:UIControlStateHighlighted];
	[profileButton setImage:[UIImage imageNamed:@"profile_selected.png"] forState:UIControlStateSelected];
	profileButton.frame = CGRectMake(0, 0, 68, 29);
	[profileButton addTarget:self action:@selector(profileTabSelected:) forControlEvents:UIControlEventTouchUpInside];
	[attendingButton setImage:[UIImage imageNamed:@"attending.png"] forState:UIControlStateNormal];
//	[attendingButton setImage:[UIImage imageNamed:@"attending_selected.png"] forState:UIControlStateHighlighted];
	[attendingButton setImage:[UIImage imageNamed:@"attending_selected.png"] forState:UIControlStateSelected];
	attendingButton.frame = CGRectMake(66, 0, 68, 29); 
	[attendingButton addTarget:self action:@selector(attendingTabSelected:) forControlEvents:UIControlEventTouchUpInside];
	[hostingButton setImage:[UIImage imageNamed:@"hosting.png"] forState:UIControlStateNormal];
//	[hostingButton setImage:[UIImage imageNamed:@"hosting_selected.png"] forState:UIControlStateHighlighted];
	[hostingButton setImage:[UIImage imageNamed:@"hosting_selected.png"] forState:UIControlStateSelected];
	hostingButton.frame = CGRectMake(133, 0, 68, 29);
	[hostingButton addTarget:self action:@selector(hostingTabSelected:) forControlEvents:UIControlEventTouchUpInside];
	segmentButtons = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 86)];
	[segmentButtons addSubview:profileButton];
	[segmentButtons addSubview:hostingButton];
	[segmentButtons addSubview:attendingButton];
	segmentButtons.bounds = CGRectMake(0, -29, segmentButtons.frame.size.width, segmentButtons.frame.size.height);
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentButtons];
	self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
	
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APILocation, @"getUserInfo/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request startSynchronous];
	NSArray *userInfo = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:nil];
	
	profileView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileViewController" owner:self options:nil] objectAtIndex:0];
	CGRect rect = profileView.bounds;
	rect.origin.y += 44.0;
	profileView.bounds = rect;
	profileButton.selected = YES;
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

@end
