//
//  MainViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/18/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "Constants.h"
#import "MainViewController.h"


@implementation MainViewController
//@synthesize navBar;
@synthesize profileVC;
@synthesize profileVCLandscape;
@synthesize attendingVC;
//@synthesize attendingView;
@synthesize hostingView;
@synthesize currentVC;
//@synthesize currentVCLandscape;
@synthesize segmentButtons;
@synthesize profileButton;
@synthesize hostingButton;
@synthesize attendingButton;
@synthesize animatedDistance;
BOOL keyboardUp = NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		profileButton = [[UIButton alloc] init];
		hostingButton = [[UIButton alloc] init];
		attendingButton = [[UIButton alloc] init];
		profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:[NSBundle mainBundle]];
//		profileVCLandscape = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController_Landscape" bundle:[NSBundle mainBundle]];
		attendingVC = [[AttendingViewController alloc] initWithNibName:@"AttendingViewController" bundle:[NSBundle mainBundle]];
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[profileVC release];
//	[profileVCLandscape release];
	[attendingVC release];
//	[attendingView release];
	[hostingView release];
	[segmentButtons release];
	[profileButton release];
	[hostingButton release];
	[attendingButton release];
	[currentVC release];
//	[currentVCLandscape release];
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
	for (UIView* view in currentVC.view.subviews) {
		if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
		{
			[view resignFirstResponder];	
		}
	}	
}

- (void)profileTabSelected:(id)sender
{
//	if(attendingButton.selected)
//	{
//		attendingButton.selected = NO;
//		[attendingView removeFromSuperview];
//	}
//	else if(hostingButton.selected)
//	{
//		hostingButton.selected = NO;
//		[hostingView removeFromSuperview];
//	}
//	if(!profileButton.selected)
//	{
//		profileButton.selected = YES;
//		profileView.hidden = NO;
//	}
	profileButton.selected = YES;
	attendingButton.selected = NO;
	hostingButton.selected = NO;
	[currentVC.view removeFromSuperview];
//	if(UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//	{
//		currentVC = profileVCLandscape;
//	}
//	else
//	{
		currentVC = profileVC;
//	}
	[self.view addSubview:currentVC.view];
}
- (void)attendingTabSelected:(id)sender
{
//	if(profileButton.selected)
//	{
//		profileButton.selected = NO;		
//		profileView.hidden = YES;
//	}
//	else if(hostingButton.selected)
//	{
//		hostingButton.selected = NO;
//		[hostingView removeFromSuperview];
//	}
//	if(!attendingButton.selected)
//	{
//		attendingButton.selected = YES;
//		//Do stuff here
//	}
	profileButton.selected = NO;
	attendingButton.selected = YES;
	hostingButton.selected = NO;
	[currentVC.view removeFromSuperview];
	currentVC = attendingVC;
	[self.view addSubview:currentVC.view];
	
}
- (void)hostingTabSelected:(id)sender
{
//	if(profileButton.selected)
//	{
//		profileButton.selected = NO;		
//		profileView.hidden = YES;
//	}
//	else if(attendingButton.selected)
//	{
//		attendingButton.selected = NO;
//		[attendingView removeFromSuperview];
//	}
//	if(!hostingButton.selected)
//	{
//		hostingButton.selected = YES;
//		//Do stuff here
//	}
	profileButton.selected = NO;
	attendingButton.selected = NO;
	hostingButton.selected = YES;
	[currentVC.view removeFromSuperview];
//	currentVC = hostingView;
//	[self.view addSubview:currentVC.view];
}
- (void)setTextFieldDelegates:(UIView*)mainView
{
	for(UIView *view in mainView.subviews)
	{
		if([view isKindOfClass:[UITextField class]])
		{
			((UITextField*)view).delegate = self;
		}
		else if ([view isKindOfClass:[UITextView class]])
		{
			((UITextView*)view).delegate = self;
		}
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
	{
		int viewPoint = self.view.frame.size.height/2 - 340;
		animatedDistance = viewPoint + textField.frame.origin.y;
	}
	else
	{
		int viewPoint = self.view.frame.size.height/2 - 200;
		animatedDistance = viewPoint + textField.frame.origin.y;		
	}
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	keyboardUp = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	keyboardUp = NO;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	UITextField *temp = [[UITextField alloc] initWithFrame:textView.frame];
	[self textFieldDidBeginEditing:temp];
	[temp release];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
	UITextField *temp = [[UITextField alloc] initWithFrame:textView.frame];
	[self textFieldDidEndEditing:temp];
	[temp release];	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [textField resignFirstResponder];
	if([profileVC.view viewWithTag:textField.tag+1])
	{
		UIView *tempView = [profileVC.view viewWithTag:textField.tag+1];
		if([tempView isKindOfClass:[UITextField class]])
		{
			[((UITextField*)tempView) becomeFirstResponder];
		}
		else
		{
			[textField resignFirstResponder];
		}
//		else if ([tempView isKindOfClass:[UITextView class]])
//		{
//			[((UITextView*)tempView) becomeFirstResponder];			
//		}
	}
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[profileButton setImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
	[profileButton setImage:[UIImage imageNamed:@"profile_selected.png"] forState:UIControlStateSelected];
	profileButton.frame = CGRectMake(0, 0, 68, 29);
	[profileButton addTarget:self action:@selector(profileTabSelected:) forControlEvents:UIControlEventTouchUpInside];
	[attendingButton setImage:[UIImage imageNamed:@"attending.png"] forState:UIControlStateNormal];
	[attendingButton setImage:[UIImage imageNamed:@"attending_selected.png"] forState:UIControlStateSelected];
	attendingButton.frame = CGRectMake(66, 0, 68, 29); 
	[attendingButton addTarget:self action:@selector(attendingTabSelected:) forControlEvents:UIControlEventTouchUpInside];
	[hostingButton setImage:[UIImage imageNamed:@"hosting.png"] forState:UIControlStateNormal];
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
	currentVC = profileVC;	
//	currentVCLandscape = profileVCLandscape;
//	if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//	{
//		[self setTextFieldDelegates:profileVCLandscape.view];
//		[self.view addSubview:currentVCLandscape.view];
//	}
//	else
//	{
		[self setTextFieldDelegates:profileVC.view];
		[self.view addSubview:currentVC.view];
//	}
	CGRect rect = profileVC.view.bounds;
	rect.origin.y = 44.0;
	profileVC.view.bounds = rect;
	attendingVC.view.bounds = rect;
//	rect = profileVCLandscape.view.bounds;
//	rect.origin.y = 44.0;
//	profileVCLandscape.view.bounds = rect;
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
	if(!keyboardUp)
	{
		return YES;
	}
	return NO;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
		[currentVC willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
//	{
//		[currentVC.view removeFromSuperview];
//		currentVC = profileVCLandscape;
//		[self.view addSubview:profileVCLandscape.view];
//	}
//	else
//	{
//		[currentVC.view removeFromSuperview];
//		currentVC = profileVC;
//		[self.view addSubview:currentVC.view];
//		
//	}
//	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
@end
