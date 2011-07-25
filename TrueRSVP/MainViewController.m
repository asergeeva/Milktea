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
@synthesize profileVC;
@synthesize attendingVC;
@synthesize hostingView;
//@synthesize currentVC;
@synthesize segmentButtons;
@synthesize profileButton;
@synthesize hostingButton;
@synthesize attendingButton;
@synthesize animatedDistance;
@synthesize scrollView;
//@synthesize pageControl;
BOOL keyboardUp = NO;
int pageNumber = 0;
#pragma mark - Loading
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		profileButton = [[UIButton alloc] init];
		hostingButton = [[UIButton alloc] init];
		attendingButton = [[UIButton alloc] init];
		profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:[NSBundle mainBundle]];
		attendingVC = [[AttendingViewController alloc] initWithNibName:@"AttendingViewController" bundle:[NSBundle mainBundle]];
		attendingVC.delegate = self;
        // Custom initialization
    }
    return self;
}
- (void)setupScrolling
{
	scrollView.delegate = self;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	//	currentVC = profileVC;	
	[self setTextFieldDelegates:profileVC.view];
	//	[self.view addSubview:currentVC.view];
	CGRect rect = profileVC.view.bounds;
	rect.origin.y = self.navigationController.navigationBar.frame.size.height;
	profileVC.view.bounds = rect;
	attendingVC.view.bounds = rect;
	profileButton.selected = YES;
	[scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*2, 1)];
	
	rect = scrollView.frame;
	rect.origin.x += profileVC.view.frame.size.width*2;
	attendingVC.view.frame = rect;
	[scrollView addSubview:profileVC.view];
	[scrollView addSubview:attendingVC.view];
	scrollView.delaysContentTouches = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    pageNumber = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	switch (pageNumber) {
		case 0:
			[self profileTabSelected:nil];
			break;
		case 1:
			[self attendingTabSelected:nil];
			break;
		case 2:
			[self hostingTabSelected:nil];
			break;
		default:
			break;
	}
//    pageControl.currentPage = page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	//A fix for possible iOS bug. Frame continues to reset to (320, 0, 480, 320) for some reason.
	if(profileVC.view.frame.origin.x > 0)
	{
		profileVC.view.frame = CGRectMake(0, 0, 480, 320);
	}	
}
- (void)resetScrollViewContentSize:(UIInterfaceOrientation)toInterfaceOrientation
{
	scrollView.contentSize = CGSizeMake(0, 0);
	scrollView.contentOffset = CGPointMake(0.0, 0.0);
	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
	{
		[scrollView setContentSize:CGSizeMake(1440, 1)];
		[scrollView setContentOffset:CGPointMake(480*pageNumber, 0)];
		CGRect frame = CGRectMake(0, 0, 480, 320);
		frame.origin.x = 480*pageNumber;
		[scrollView scrollRectToVisible:frame animated:YES];
		profileVC.view.frame = CGRectMake(0, 0, 480, 320);
		attendingVC.view.frame = CGRectMake(480, 0, 480, 320);
	}
	else
	{
		[scrollView setContentSize:CGSizeMake(960, 1)];
		[scrollView setContentOffset:CGPointMake(320*pageNumber, 0)];
		CGRect frame = CGRectMake(0, 0, 320, 480);
		frame.origin.x = 320*pageNumber;
		[scrollView scrollRectToVisible:frame animated:YES];
		profileVC.view.frame = CGRectMake(0, 0, 320, 480);
		attendingVC.view.frame = CGRectMake(320, 0, 320, 480);
	}	
	[self willRotateToInterfaceOrientation:toInterfaceOrientation duration:0];
}
- (void)viewWillAppear:(BOOL)animated
{
	[self resetRotation:profileVC duration:0];
	[self resetRotation:attendingVC duration:0];
	[self resetScrollViewContentSize:[[UIApplication sharedApplication] statusBarOrientation]];
	[super viewWillAppear:animated];
}
//- (void)viewDidAppear:(BOOL)animated
//{
////	[profileVC willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication]statusBarOrientation]duration:0];
////	[self resetRotation:profileVC duration:0];
////	[self resetRotation:attendingVC duration:0];
//	[super viewDidAppear:animated];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupScrolling];
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
}
#pragma mark - Unloading
- (void)dealloc
{
	[profileVC release];
	[attendingVC release];
	[hostingView release];
	[segmentButtons release];
	[profileButton release];
	[hostingButton release];
	[attendingButton release];
//	[currentVC release];
	[scrollView release];
//	[pageControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in scrollView.subviews) {
		if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
		{
			[view resignFirstResponder];	
		}
	}	
}
#pragma mark - Attending Delegate Method
- (void)selectedEvent:(UIViewController *)viewController
{
	[self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - Navigation Bar
- (void)profileTabSelected:(id)sender
{
	[self scrollViewWillBeginDragging:nil];
	profileButton.selected = YES;
	attendingButton.selected = NO;
	hostingButton.selected = NO;
//	[currentVC.view removeFromSuperview];
//	currentVC = profileVC;
//	[self.view addSubview:currentVC.view];
//	[currentVC willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	if(sender)
	{
		CGRect frame = scrollView.frame;
		frame.origin.x = 0;
		[scrollView scrollRectToVisible:frame animated:YES];
	}
	pageNumber = 0;
}
- (void)attendingTabSelected:(id)sender
{
	profileButton.selected = NO;
	attendingButton.selected = YES;
	hostingButton.selected = NO;
//	[currentVC.view removeFromSuperview];
//	currentVC = attendingVC;
//	[self.view addSubview:currentVC.view];
//	[currentVC willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	if(sender)
	{
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width;
		[scrollView scrollRectToVisible:frame animated:YES];
	}
	pageNumber = 1;
}
- (void)hostingTabSelected:(id)sender
{	profileButton.selected = NO;
	attendingButton.selected = NO;
	hostingButton.selected = YES;
//	[currentVC.view removeFromSuperview];
//	currentVC = hostingView;
//	[self.view addSubview:currentVC.view];
	pageNumber = 2;
}
#pragma mark - Textfield Delegate Methods
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
#pragma mark - Rotation
- (void)resetRotation:(UIViewController*)viewController duration:(NSTimeInterval)duration
{
	[viewController willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:duration];
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
	[self resetRotation:profileVC duration:duration];
	[self resetRotation:attendingVC duration:duration];
	[self resetScrollViewContentSize:toInterfaceOrientation];
//	CGRect frame = scrollView.frame;
//	frame.origin.x = scrollView.frame.size.width * pageNumber;
//	[scrollView scrollRectToVisible:frame animated:YES];
}
@end
