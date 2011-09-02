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
#import "WelcomeViewController.h"
#import "AboutViewController.h"
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
@synthesize pageNumber;
BOOL keyboardUp = NO;
BOOL offlineWarning = NO;
#pragma mark - Loading
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		profileButton = [[UIButton alloc] init];
		hostingButton = [[UIButton alloc] init];
		attendingButton = [[UIButton alloc] init];
		profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:[NSBundle mainBundle]];
		attendingVC = [[AttendingListViewController alloc] initWithNibName:@"AttendingListViewController" bundle:[NSBundle mainBundle]];
		hostingVC = [[HostingViewController alloc] initWithNibName:@"HostingViewController" bundle:[NSBundle mainBundle]];
		attendingVC.delegate = self;
		hostingVC.delegate = self;
		
		segmentButtons = [[UIView alloc] init];
	
		pageNumber = 0;
		profileButton.selected = YES;

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
- (void)presentAbout
{
	AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:aboutVC animated:YES];
	[aboutVC release]; 
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
	if(scrollView.alpha == 0)
	{
		scrollView.hidden = NO;
		[UIView animateWithDuration:0.35 animations:^(void) {
			scrollView.alpha = 1;
		}];
	}
	if(![[NetworkManager sharedNetworkManager] isOnline] && !offlineWarning)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline" message:@"No internet connection detected. Going offline. Some features are disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		offlineWarning = YES;
	}
	if(![[SettingsManager sharedSettingsManager].settings objectForKey:@"didShowWelcome"])
	{
		WelcomeViewController *welcome = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:[NSBundle mainBundle] name:[User sharedUser].fullName  mainVC:self];
		[self presentModalViewController:welcome animated:YES];
		[welcome release];
		[[SettingsManager sharedSettingsManager].settings setObject:@"1" forKey:@"didShowWelcome"];
		[[SettingsManager sharedSettingsManager] save];
	}
	[self resetRotation:profileVC duration:0.3];
	[self resetRotation:attendingVC duration:0.3];
	[self resetRotation:hostingVC duration:0.3];
	[self resetScrollViewContentSize:[[UIApplication sharedApplication] statusBarOrientation]];
	[super viewDidAppear:animated];
	
}
- (void)viewDidDisappear:(BOOL)animated
{
	scrollView.alpha = 0;
	scrollView.hidden = 1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupScrolling];
	scrollView.alpha = 0;
	scrollView.hidden = YES;
//	CGRect frame = scrollView.frame;
//	frame.origin.x = 0;

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
	UIBarButtonItem *about = [[[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(presentAbout)] autorelease];
	self.navigationItem.leftBarButtonItem = about;
	
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
- (void)finishedUploadingPic
{
	[UIView animateWithDuration:0.3 animations:^(void) {
		[self.view viewWithTag:BLACKVIEW_TAG].alpha = 0.0;
	} completion:^(BOOL finished) {
		[[self.view viewWithTag:BLACKVIEW_TAG] removeFromSuperview];
	}];
	
	[[self.view viewWithTag:UPLOADMESSAGE_TAG] removeFromSuperview];
	self.view.userInteractionEnabled = YES;
	self.navigationController.navigationBar.userInteractionEnabled = YES;
	[profileVC updateProfile:nil];
	//[profileVC updatedImages];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *pic = ((UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"]);
	UIImage *uploadPic;
	if(pic.size.width > 800)
	{
		CGSize newSize = CGSizeMake(pic.size.width/2, pic.size.height/2);
		UIGraphicsBeginImageContext( newSize );
		[pic drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
		uploadPic = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	else
	{
		uploadPic = pic;
	}
	[[NetworkManager sharedNetworkManager] uploadProfilePicWithImage: uploadPic filename:[User sharedUser].uid delegate:self finishedSelector:@selector(finishedUploadingPic)] ;
	[picker dismissModalViewControllerAnimated:YES];
	
	UIView *blackView = [[[UIView alloc] initWithFrame:self.view.frame]autorelease];
	CGRect rect = blackView.frame;
	rect.origin.y = 0;
	blackView.frame = rect;
	blackView.backgroundColor = [UIColor blackColor];
	blackView.tag = BLACKVIEW_TAG;
	blackView.alpha = 0;
	[self.view addSubview:blackView];
	[UIView animateWithDuration:1.0 animations:^(void) {
		blackView.alpha = 0.5;
	}];
	UIImageView *uploadingMessage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification.png"]];
	
	CGRect original = uploadingMessage.frame;
	original.origin.x = rect.size.width/2 - original.size.width/2;
	original.origin.y = rect.size.height/2 - original.size.height/2 + 44;
	
	uploadingMessage.frame = original;
	uploadingMessage.tag = UPLOADMESSAGE_TAG;
	
	original.origin.x = 0;
	original.origin.y = 0;
	
	UILabel *uploadingMessageLabel = [[[UILabel alloc] initWithFrame:original] autorelease];
	uploadingMessageLabel.text = @"Uploading...";	
	uploadingMessageLabel.backgroundColor = [UIColor clearColor];
	uploadingMessageLabel.tag = UPLOADMESSAGE_TAG;
	uploadingMessageLabel.textAlignment = UITextAlignmentCenter;
	uploadingMessageLabel.textColor = [UIColor whiteColor];
	uploadingMessageLabel.font = [UIFont systemFontOfSize:15];
	[uploadingMessage addSubview:uploadingMessageLabel];
	
	[self.view addSubview:uploadingMessage];
	self.view.userInteractionEnabled = NO;
	self.navigationController.navigationBar.userInteractionEnabled = NO;
	[uploadingMessage release];
	
}
- (void)launchCamera
{
	[profileVC dismissWelcome:nil];
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:imagePickerController animated:YES];   
		[imagePickerController release];
		//[imagePickerController release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No camera detected"
														message:@"There's no camera detected."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];	
	}
}
@end
