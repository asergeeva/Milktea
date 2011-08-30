//
//  TrueRSVPViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "SignInViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIAuthenticationDialog.h"
#import "MainViewController.h"
#import "SettingsManager.h"
#import "DebugViewController.h"
#import "SFHFKeychainUtils.h"
#import "MiscHelper.h"
#import "ProgressView.h"
#import "LocationManager.h"
#import "FlurryAnalytics.h"
//#import "TrueRSVPAppDelegate.h"
@implementation SignInViewController
@synthesize facebook;
//@synthesize timer;
- (void)dealloc
{
	[txtUsername release];
	[txtPassword release];
//	[navBar release];
	[loginButton release];
	[facebook release];
	[fbButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
//- (id)init
//{
//	if((self = [super init]))
//	{
//	}
//	return self;
//}
- (void)progressFinished
{
		[NetworkManager sharedNetworkManager].delegate = nil;
		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:mainVC animated:YES];
		[mainVC release];
		[[SettingsManager sharedSettingsManager].settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"Preloaded"];
		[[SettingsManager sharedSettingsManager] save];
//		[timer invalidate];
}
- (void)offlineMode
{
	if(![[NetworkManager sharedNetworkManager] isOnline] && [[NetworkManager sharedNetworkManager] checkFilled])
	{
//		[NetworkManager sharedNetworkManager].delegate = nil;
//		[[SettingsManager sharedSettingsManager].settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"Preloaded"];
//		[[SettingsManager sharedSettingsManager] save];
//		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
//		[self.navigationController pushViewController:mainVC animated:YES];
//		[mainVC release];
		//		[timer invalidate];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline" message:@"No internet connection detected. Going offline. Some features are disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
	}
}	
#pragma mark - View lifecycle
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == txtUsername)
	{
		[textField resignFirstResponder];
		[txtPassword becomeFirstResponder];
		NSString *pass = [SFHFKeychainUtils getPasswordForUsername:txtUsername.text andServiceName:@"TrueRSVP" error:nil];
		if(pass)
		{
			txtPassword.text = [SFHFKeychainUtils getPasswordForUsername:txtUsername.text andServiceName:@"TrueRSVP" error:nil];
		}
	}
	else
	{
		[txtPassword resignFirstResponder];
		[self loginPressed:nil];
	}
	return NO;
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [self setViewMoveUp:NO];
}

- (void)keyboardWillShow:(NSNotification *)notif{
    [self setViewMoveUp:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setViewMoveUp:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setViewMoveUp:NO];
}

-(void)setViewMoveUp:(BOOL)moveUp
{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//	
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void) {
			CGRect rect = self.view.frame;
			if (moveUp)
			{
				if(UIDeviceOrientationIsPortrait(self.interfaceOrientation))
				{
					rect.origin.y -= 135.0;
				}
				else
				{
					rect.origin.y -= 95.0;
				}	
			}
			else
			{
				if(UIDeviceOrientationIsPortrait(self.interfaceOrientation))
				{
					rect.origin.y += 135.0;
				}
				else
				{
					rect.origin.y += 95.0;
				}	
			}
			self.view.frame = rect; 
	}completion:nil];
}
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];	
	}	
}
//+ (NSString*)md5HexDigest:(NSString*)input {
//    const char* str = [input UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(str, strlen(str), result);
//	
//    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
//    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
//        [ret appendFormat:@"%02x",result[i]];
//    }
//    return ret;
//}
//- (void)showMain
//{
////	UINavigationController *navController = self.navigationController;
////	NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
////	[controllers removeLastObject];
////	navController.viewControllers = controllers;
//	MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
//	//		[self.navigationController pushViewController:mainVC animated:YES];
////	[navController pushViewController:mainVC animated:YES];
//	[self.navigationController pushViewController:mainVC
//										 animated:YES];
//	[mainVC willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
//	[mainVC release];
//}
//- (void)showProgress
//{
//	ProgressView *progressView = [[ProgressView alloc] initWithNibName:@"ProgressView" bundle:[NSBundle mainBundle]];
//	[self.navigationController pushViewController:progressView animated:NO];
//	[progressView release];
//}
- (void)showProgress
{
	[NetworkManager sharedNetworkManager].delegate = self;
	[[NetworkManager sharedNetworkManager] refreshAllWithDelegate:nil completion:nil];
//	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressCheck) userInfo:nil repeats:YES];	
}
- (BOOL)requiresAuth:(NSURL*)url
{
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	if([request responseStatusCode] == 401)
	{
		return YES;
	}
	return NO;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	[self login];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"Not Logged In");
}
- (void)login
{
	[[SettingsManager sharedSettingsManager].username setString:txtUsername.text];
	[[SettingsManager sharedSettingsManager] load];
	[txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
	if([[txtPassword text] isEqualToString:@""] || [[txtUsername text] isEqualToString:@""])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank" 
														message:@"Username/password may not be left blank."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"APILocation"], @"login"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:[txtUsername text] forKey:@"email"];
	request.useSessionPersistence = YES;
	[request setPostValue:txtPassword.text forKey:@"pass"];	
	[request startSynchronous];
	
	NSString *status = [request responseString];
	//NSLog(@"%@", status);
	if ([status isEqualToString:@"status_loginFailed"])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" 
														message:@"Username/password is incorrect."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if ([status isEqualToString:@"status_loginSuccess"])
	{
		[[SettingsManager sharedSettingsManager].settings setObject:txtUsername.text forKey:@"username"];
		[[SettingsManager sharedSettingsManager] save];
		[SFHFKeychainUtils storeUsername:txtUsername.text andPassword:txtPassword.text forServiceName:@"TrueRSVP" updateExisting:NO error:nil];
//		UIProgressView *progress = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
//		[self.view addSubview:progress];
//		[[NetworkManager sharedNetworkManager] refreshAll:progress];
		[self showProgress];
//		[[NetworkManager sharedNetworkManager] refreshAll:nil];
//		[self showMain];
	}
	else
	{
		NSNumber *checkOffline = [[SettingsManager sharedSettingsManager].settings objectForKey:@"Preloaded"];
		if([checkOffline isEqual:[NSNumber numberWithBool:YES]])
		{
			[self showProgress];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline" 
															message:@"Cannot connect to TrueRSVP."
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}
- (IBAction)loginPressed:(UIButton*)sender
{
	[FlurryAnalytics logEvent:@"SIGNIN_REGULAR_LOGIN"];
	NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"rootAddress"]];
	if([self requiresAuth:url])
	{
		ASIHTTPRequest *loginRequest = [ASIHTTPRequest requestWithURL:url];
		loginRequest.delegate = self;
		loginRequest.shouldPresentAuthenticationDialog = YES;
		[loginRequest startAsynchronous];
	}
	else
	{
		[self login];
	}
}
- (IBAction)facebookLogin:(id)sender
{
	[FlurryAnalytics logEvent:@"SIGNIN_FB_LOGIN"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![facebook isSessionValid]) {
		NSArray *permissions = [NSArray arrayWithObject:@"email"];
		[facebook authorize:permissions];
	}
	else if ([defaults objectForKey:@"FBAccessTokenKey"] 
		&& [defaults objectForKey:@"FBExpirationDateKey"]) {
		facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
		facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
		[facebook requestWithGraphPath:@"me" andDelegate:self];
	}
}

- (void)showDebugView:(id)sender
{
	DebugViewController *debugVC = [[DebugViewController alloc] initWithNibName:@"DebugViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:debugVC animated:YES];
	[debugVC release];
}
- (void)viewWillAppear:(BOOL)animated
{
	[ASIHTTPRequest clearSession];
	[super viewWillAppear:animated];
}
- (void)viewDidLoad
{
//	[self showDebugView:nil];
	txtUsername.text = @"movingincircles@gmail.com";
	txtPassword.text = @"supfoo";
//	TrueRSVPAppDelegate *app = ((TrueRSVPAppDelegate*)[[UIApplication sharedApplication] delegate]);
	if([[SettingsManager sharedSettingsManager].settings objectForKey:@"username"])
	{
		txtUsername.text = [[SettingsManager sharedSettingsManager].settings objectForKey:@"username"];
		if([SFHFKeychainUtils getPasswordForUsername:txtUsername.text andServiceName:@"TrueRSVP" error:nil])
		{
			txtPassword.text = [SFHFKeychainUtils getPasswordForUsername:txtUsername.text andServiceName:@"TrueRSVP" error:nil];
		}
	}
	self.navigationController.navigationBar.frame = CGRectMake(0, -44, 480, 44);
	self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.235 green:0.600 blue:0.792 alpha:1.000];
	txtUsername.alpha = 0;
	txtPassword.alpha = 0;
	loginButton.alpha = 0;
	fbButton.alpha = 0;
	[UIView animateWithDuration:0.5 animations:^{
			self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);		
	}];
	[UIView animateWithDuration:0.7 delay:0.15 options:UIViewAnimationCurveEaseIn animations:^(void) {
			txtUsername.alpha = 1;
			txtPassword.alpha = 1;
			loginButton.alpha = 1;
			fbButton.alpha = 1;
		} completion:nil];
	
	self.navigationController.navigationBar.autoresizesSubviews = NO;
	self.navigationController.navigationBar.autoresizingMask = UIViewAutoresizingNone;
	facebook = ((TrueRSVPAppDelegate*)[[UIApplication sharedApplication] delegate]).facebook;
	CGRect rect = self.view.bounds;
	rect.origin.y += self.navigationController.navigationBar.frame.size.height;
	self.view.bounds = rect;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.235 green:0.600 blue:0.792 alpha:1.000];
	self.navigationController.navigationBar.topItem.title = @"Sign In";
	self.navigationItem.hidesBackButton = YES;
	[txtUsername setDelegate:self];
	[txtPassword setDelegate:self];
	
	UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDebugView:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionUp;
	recognizer.numberOfTouchesRequired = 3;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
    [super viewDidLoad];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{	
	return [facebook handleOpenURL:url]; 
}
- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	[facebook requestWithGraphPath:@"me" andDelegate:self];
}
- (void)request:(FBRequest *)request didLoad:(id)result
{
	[[SettingsManager sharedSettingsManager].username setString:[result objectForKey:@"email"]];
	[[SettingsManager sharedSettingsManager] load];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@login", [[NSUserDefaults standardUserDefaults] objectForKey:@"APILocation"]]];
	ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
	[_request addPostValue:[result objectForKey:@"first_name"] forKey:@"fname"];
	[_request addPostValue:[result objectForKey:@"last_name"] forKey:@"lname"];
	[_request addPostValue:[result objectForKey:@"id"] forKey:@"fbid"];
	[_request addPostValue:[result objectForKey:@"email"] forKey:@"email"];	
	[_request addPostValue:@"1" forKey:@"isFB"];
	[_request startSynchronous];
	NSLog(@"%@", [_request responseString]);
	if([[_request responseString ]isEqual:@"status_doesNotExist"])
	{
		[facebook logout:self];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Found" 
														message:@"Unable to locate your account. Please goto http://www.truersvp.com to register."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		[self showProgress];
	}
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
//	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
	{
		self.navigationController.navigationBarHidden = YES;
		if([txtUsername isFirstResponder] || [txtPassword isFirstResponder])
		{
			self.view.bounds = CGRectMake(-80.0, 189.0, 480.0, 320.0);
		}
		else
		{
			self.view.bounds = CGRectMake(-80.0, 89.0, 480.0, 320.0);
		}
		self.navigationController.navigationBar.frame = CGRectMake(0, -440, 480, 44);
	}
	else
	{
		self.navigationController.navigationBarHidden = NO;
		if([txtUsername isFirstResponder] || [txtPassword isFirstResponder])
		{
			self.view.bounds = CGRectMake(0.0, 179.0, 320.0, 480.0);			
		}
		else
		{
			self.view.bounds = CGRectMake(0.0, 44.0, 320.0, 480.0);
		}
		self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
	}
//	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
@end
