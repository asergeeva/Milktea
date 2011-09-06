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
#import "Constants.h"
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
	[sessionKey release];
	[orLabel release];
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
//	[self finishedSignIn];
		[self.navigationController pushViewController:mainVC animated:YES];
	
		[mainVC release];
		[[SettingsManager sharedSettingsManager].settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"Preloaded"];
		[[SettingsManager sharedSettingsManager] save];
//		[timer invalidate];
}
//- (void)offlineMode
//{
//	if(![[NetworkManager sharedNetworkManager] isOnline] && [[NetworkManager sharedNetworkManager] checkFilled])
//	{
////		[NetworkManager sharedNetworkManager].delegate = nil;
////		[[SettingsManager sharedSettingsManager].settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"Preloaded"];
////		[[SettingsManager sharedSettingsManager] save];
////		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
////		[self.navigationController pushViewController:mainVC animated:YES];
////		[mainVC release];
//		//		[timer invalidate];
////		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline" message:@"No internet connection detected. Going offline. Some features are disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////		[alert show];
////		[alert release];
//	}
//}	
#pragma mark - View lifecycle
- (void)resignKeyboard
{
	if([txtUsername isFirstResponder])
	{
		[txtUsername resignFirstResponder];
	}
	else if([txtPassword isFirstResponder])
	{
		[txtPassword resignFirstResponder];
	}
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
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
	[self finishedSignIn];
	[NetworkManager sharedNetworkManager].delegate = self;
	[[NetworkManager sharedNetworkManager] refreshAllWithDelegate:nil completion:nil];
}
- (BOOL)requiresAuth:(NSURL*)url
{
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	[request setValidatesSecureCertificate:SHOULD_VALIDATE_SECURE_CERTIFICATE];
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
	[self finishedSignIn];
	NSLog(@"Not Logged In");
}
- (void)goOffline
{
	[self finishedSignIn];
	NSNumber *checkOfflineData = [[SettingsManager sharedSettingsManager] checkOfflineData];
	if([checkOfflineData isEqual:[NSNumber numberWithBool:YES]])
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
- (void)login
{
	[txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
	if([[txtPassword text] isEqualToString:@""] || [[txtUsername text] isEqualToString:@""])
	{
		[self finishedSignIn];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank" 
														message:@"Username/password may not be left blank."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	[[SettingsManager sharedSettingsManager].username setString:txtUsername.text];
	[[SettingsManager sharedSettingsManager] load];

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"APILocation"], @"login"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setValidatesSecureCertificate:SHOULD_VALIDATE_SECURE_CERTIFICATE];
	[request setPostValue:[txtUsername text] forKey:@"email"];
	request.useSessionPersistence = YES;
	[request setPostValue:txtPassword.text forKey:@"pass"];	
//	[request setValidatesSecureCertificate:NO];
	[request startSynchronous];
	NSString *status = [request responseString];
	NSLog(@"%@", status);
	if (![status isEqual:[NSNull null]])
	{
		if ([status isEqualToString:@"status_loginFailed"])
		{
			[self finishedSignIn];
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
			[FlurryAnalytics setUserID:txtUsername.text];
			[self showProgress];
		}
		else
		{
			[self goOffline];
		}
	}
	else
	{
		[self goOffline];
	}
}
- (IBAction)loginPressed:(UIButton*)sender
{
	self.view.userInteractionEnabled = NO;
	self.navigationController.navigationBar.userInteractionEnabled = NO;
	[[NSUserDefaults standardUserDefaults] setObject:txtUsername.text forKey:@"lastUsername"];
	[UIView animateWithDuration:0.3 animations:^(void) 
	{
		for(UIView *fadeView in self.view.subviews)
		{
			if(fadeView.tag != SIGNIN_TAG)
			{
				fadeView.alpha = 0.25;
			}
		}
	} completion:^(BOOL finished) 
	{
		[FlurryAnalytics logEvent:@"SIGNIN_REGULAR_LOGIN"];
		[self login];
	}];

}
- (IBAction)facebookLogin:(id)sender
{
	self.view.userInteractionEnabled = NO;
	self.navigationController.navigationBar.userInteractionEnabled = NO;
	[UIView animateWithDuration:0.3 animations:^(void) 
	 {
		 for(UIView *fadeView in self.view.subviews)
		 {
			 if(fadeView.tag != SIGNIN_TAG)
			 {
				 fadeView.alpha = 0.25;
			 }
		 }
	 } completion:^(BOOL finished) 
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
	 }];
}
- (void)finishedSignIn
{
	self.navigationController.navigationBar.userInteractionEnabled = YES;
	self.view.userInteractionEnabled = YES;
	[UIView animateWithDuration:0.3 animations:^(void) {
		for(UIView *fadeView in self.view.subviews)
		{
			if(fadeView.tag != SIGNIN_TAG)
			{
				fadeView.alpha = 1.0;
			}
		}
	}];
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
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[self resignKeyboard];
	[super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
//	[self showDebugView:nil];
	sessionKey = [[NSMutableString alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignKeyboard) name:UIApplicationDidEnterBackgroundNotification object:nil];
//	txtUsername.text = @"movingincircles@gmail.com";
//	txtPassword.text = @"supfoo";
//	TrueRSVPAppDelegate *app = ((TrueRSVPAppDelegate*)[[UIApplication sharedApplication] delegate]);
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"lastUsername"] != [NSNull null])
	{
		txtUsername.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUsername"];
	}
//	if([[SettingsManager sharedSettingsManager].settings objectForKey:@"username"])
//	{
//		txtUsername.text = [[SettingsManager sharedSettingsManager].settings objectForKey:@"username"];
	if([SFHFKeychainUtils getPasswordForUsername:txtUsername.text andServiceName:@"TrueRSVP" error:nil])
	{
		txtPassword.text = [SFHFKeychainUtils getPasswordForUsername:txtUsername.text andServiceName:@"TrueRSVP" error:nil];
	}
//	}
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
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.286 green:0.761 blue:0.878 alpha:1.000];
	self.navigationController.navigationBar.topItem.title = @"Sign In";
	self.navigationItem.hidesBackButton = YES;
	[txtUsername setDelegate:self];
	[txtPassword setDelegate:self];
	
//	UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDebugView:)];
//	recognizer.direction = UISwipeGestureRecognizerDirectionUp;
//	recognizer.numberOfTouchesRequired = 3;
//	[self.view addGestureRecognizer:recognizer];
//	[recognizer release];
	
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
	NSMutableDictionary* params = [NSMutableDictionary 
								   dictionaryWithObjectsAndKeys: [facebook accessToken], @"access_token", nil];
	[facebook requestWithMethodName:@"auth.promoteSession" andParams:params andHttpMethod:@"GET" andDelegate:self];
}
- (void)request:(FBRequest *)request didLoad:(id)result
{
	NSString *stringData = [[NSString alloc] initWithData:[request responseText] encoding:NSASCIIStringEncoding];
	if([stringData hasPrefix:@"\""] && [stringData hasSuffix:@"\""])
	{
		NSRange range = {1, stringData.length-2};
		[sessionKey setString:[stringData substringWithRange:range]];
		[facebook requestWithGraphPath:@"me" andDelegate:self];		
	}
	else
	{
		[[SettingsManager sharedSettingsManager].username setString:[result objectForKey:@"email"]];
		[FlurryAnalytics setUserID:[result objectForKey:@"email"]];
		[[SettingsManager sharedSettingsManager] load];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@login", [[NSUserDefaults standardUserDefaults] objectForKey:@"APILocation"]]];
		ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
		[_request setValidatesSecureCertificate:SHOULD_VALIDATE_SECURE_CERTIFICATE];
		[_request addPostValue:[result objectForKey:@"first_name"] forKey:@"fname"];
		[_request addPostValue:[result objectForKey:@"last_name"] forKey:@"lname"];
		[_request addPostValue:[result objectForKey:@"id"] forKey:@"fbid"];
		[_request addPostValue:[result objectForKey:@"email"] forKey:@"email"];	
		[_request addPostValue:[facebook accessToken] forKey:@"access"];
		[_request addPostValue:sessionKey forKey:@"session"];
		[_request addPostValue:@"1" forKey:@"isFB"];
		[_request startSynchronous];
		NSLog(@"%@", [_request responseString]);
		if([[_request responseString ]isEqual:@"status_doesNotExist"])
		{
			[facebook logout:self];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account Not Found" 
															message:@"The given Facebook account entered does not match any accouts on trueRSVP. Please check your details on http://www.truersvp.com"
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			[self finishedSignIn];
		}
		else if([[_request responseString ] hasSuffix:@"status_loginSuccess"])
		{
			[self showProgress];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
															message:@"There seems to be a problem with the servers at the moment. Try again later."
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			[self finishedSignIn];
		}
	}
	[stringData release];
}
- (void)viewDidUnload
{
	[orLabel release];
	orLabel = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
		fbButton.frame = CGRectMake(41, 351, 237, 40);
		orLabel.frame = CGRectMake(139, 327, 42, 21);
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
		fbButton.frame = CGRectMake(41, 361, 237, 40);
		orLabel.frame = CGRectMake(139, 334, 42, 21);
	}
//	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
@end
