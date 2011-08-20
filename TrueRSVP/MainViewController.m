//
//  MainViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/18/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "Constants.h"
#import "MainViewController.h"
#import "HostingDetailViewController.h"
#import "ASIFormDataRequest.h"
@implementation MainViewController
@synthesize profileVC;
@synthesize attendingVC;
@synthesize hostingVC;
@synthesize segmentButtons;
@synthesize profileButton;
@synthesize hostingButton;
@synthesize attendingButton;
@synthesize animatedDistance;
@synthesize scrollView;
BOOL keyboardUp = NO;
int pageNumber = 1;
#pragma mark - Loading
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		profileButton = [[UIButton alloc] init];
		hostingButton = [[UIButton alloc] init];
		attendingButton = [[UIButton alloc] init];
		profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:[NSBundle mainBundle]];
		//profileButton.selected = YES;
		attendingButton.selected = YES;
		attendingVC = [[AttendingViewController alloc] initWithNibName:@"AttendingViewController" bundle:[NSBundle mainBundle]];
		hostingVC = [[HostingViewController alloc] initWithNibName:@"HostingViewController" bundle:[NSBundle mainBundle]];
		attendingVC.delegate = self;
		hostingVC.delegate = self;
		segmentButtons = [[UIView alloc] init];
        // Custom initialization
    }
    return self;
}
- (void)setupScrolling
{
	self.navigationController.delegate = self;
	scrollView.delegate = self;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	[self setTextFieldDelegates:profileVC.view];
	CGRect rect = profileVC.view.bounds;
	rect.origin.y = self.navigationController.navigationBar.frame.size.height;
	profileVC.view.bounds = rect;
	attendingVC.view.bounds = rect;
	hostingVC.view.bounds = rect;
	scrollView.contentSize = CGSizeMake(0, 0);
	scrollView.contentOffset = CGPointMake(0.0, 0.0);
	[scrollView addSubview:profileVC.view];
	[scrollView addSubview:attendingVC.view];
	[scrollView addSubview:hostingVC.view];

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
		hostingVC.view.frame = CGRectMake(960, 0, 480, 320);
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
		hostingVC.view.frame = CGRectMake(640, 0, 320, 480);
	}	
}
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
	[segmentButtons addSubview:profileButton];
	[segmentButtons addSubview:attendingButton];
	[segmentButtons addSubview:hostingButton];
	segmentButtons.frame = CGRectMake(0, 0, 201, 30);
//	segmentButtons.frame = CGRectMake(45, 44, segmentButtons.frame.size.width, segmentButtons.frame.size.height);
	self.navigationItem.titleView = segmentButtons;
//	[self.navigationController.navigationBar addSubview:segmentButtons];
	self.navigationItem.hidesBackButton = YES;
	[profileVC.profilePic addTarget:self action:@selector(launchCamera) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Navigation Controller Delegate methods
//Unfortunately there's an iOS bug where scrollview resets all subviews when popping viewcontroller
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if([viewController isKindOfClass:[AttendingDetailViewController class]] || [viewController isKindOfClass:[HostingDetailViewController class]])
	{
		profileVC.view.hidden = YES;
		attendingVC.view.hidden = YES;
		hostingVC.view.hidden = YES;
		switch (pageNumber) {
			case 0:
				profileVC.view.hidden = NO;
				break;
			case 1:
				attendingVC.view.hidden = NO;
				break;
			case 2:
				hostingVC.view.hidden = NO;
				break;
			default:
				break;
		}
	}
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if([viewController isKindOfClass:[self class]])
	{
		profileVC.view.hidden = NO;
		attendingVC.view.hidden = NO;
		hostingVC.view.hidden = NO;
		if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
		{
			profileVC.view.frame = CGRectMake(0, 0, 480, 320);
			attendingVC.view.frame = CGRectMake(480, 0, 480, 320);
			hostingVC.view.frame = CGRectMake(960, 0, 480, 320);
			[scrollView setContentOffset:CGPointMake(480*pageNumber, 0)];
		}
		else
		{
			profileVC.view.frame = CGRectMake(0, 0, 320, 480);
			attendingVC.view.frame = CGRectMake(320, 0, 320, 480);
			hostingVC.view.frame = CGRectMake(640, 0, 320, 480);
			[scrollView setContentOffset:CGPointMake(320*pageNumber, 0)];
		}
		[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	}
}
#pragma mark - Unloading
- (void)dealloc
{
	[profileVC release];
	[attendingVC release];
	[hostingVC release];
	[segmentButtons release];
	[profileButton release];
	[hostingButton release];
	[attendingButton release];
	[scrollView release];
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
#pragma mark - Attending/Hosting Delegate Method
- (void)selectedEvent:(UIViewController *)viewController
{	
	[self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - Navigation Bar
- (void)profileTabSelected:(id)sender
{
//	[self scrollViewWillBeginDragging:nil];
	profileButton.selected = YES;
	attendingButton.selected = NO;
	hostingButton.selected = NO;
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
	if(sender)
	{
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width*2;
		[scrollView scrollRectToVisible:frame animated:YES];
	}
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
    
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void) {
		[self.view setFrame:viewFrame];
	} completion:nil];
	
//	[UIView animateWithDuration:0.3 animations:^(void) {    
//		[self.view setFrame:viewFrame];
//	}];
	keyboardUp = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void) {
		[self.view setFrame:viewFrame];
	}completion:nil];
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
	[self resetRotation:hostingVC duration:duration];
	[self resetScrollViewContentSize:toInterfaceOrientation];
}
#pragma mark - Other
- (void)launchCamera
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//Send data
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[SettingsManager sharedSettingsManager].settings objectForKey:@"rootAddress"], @"event/image/upload"]];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	UIImage *small = [UIImage imageWithCGImage:((UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"]).CGImage scale:0.5 orientation:UIImageOrientationUp];
	[request setPostBody:[NSMutableData dataWithData:UIImageJPEGRepresentation(small, 0.2)]];
	[request startSynchronous];
	NSLog(@"%@", [request responseString]);
	[self dismissModalViewControllerAnimated:YES];
//	UIImageJPEGRepresentation(((UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"]), 0.8)	
}
@end
