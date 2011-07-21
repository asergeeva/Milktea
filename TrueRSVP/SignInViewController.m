//
//  TrueRSVPViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "Constants.h"
#import <CommonCrypto/CommonDigest.h>
#import "SignInViewController.h"
//#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
//#import "CJSONDeserializer.h"
#import "MainViewController.h"
#import "SettingsManager.h"
@implementation SignInViewController
@synthesize txtUsername;
@synthesize txtPassword;
//@synthesize navBar;
@synthesize facebook;
//@synthesize portraitView;
//@synthesize landscapeView;
//@synthesize loginButton;
- (void)dealloc
{
	[txtUsername release];
	[txtPassword release];
//	[navBar release];
	[loginButton release];
	[facebook release];
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
#pragma mark - View lifecycle
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == txtUsername)
	{
		[txtUsername becomeFirstResponder];
	}
	else
	{
		[textField resignFirstResponder];
		[self login:nil];
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
	
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
    [UIView commitAnimations];
}
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];	
	}	
}
+ (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
	
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (IBAction)login:(id)sender
{
	txtUsername.text = @"movingincircles@gmail.com";
	txtPassword.text = @"supfoo";
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
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APILocation, @"login/"]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:[txtUsername text] forKey:@"email"];
	
	//MD5 encryption code
	NSString *str = [txtPassword text];
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	str = [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			]; 
	
	[request setPostValue:str forKey:@"password"];	
	[request startSynchronous];
	NSString *status = [request responseString];
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
		UINavigationController *navController = self.navigationController;
		NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
		[controllers removeLastObject];
		navController.viewControllers = controllers;
		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
//		[self.navigationController pushViewController:mainVC animated:YES];
		[navController pushViewController:mainVC animated:YES];
		[mainVC release];
		[SettingsManager sharedSettingsManager].welcomeDismissed = NO;
	}
	
}
- (IBAction)facebookLogin:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
		&& [defaults objectForKey:@"FBExpirationDateKey"]) {
		facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
		facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
	if (![facebook isSessionValid]) {
		[facebook authorize:nil delegate:self];
	}
}

- (void)viewDidLoad
{
	facebook = ((TrueRSVPAppDelegate*)[[UIApplication sharedApplication] delegate]).facebook;
	CGRect rect = self.view.bounds;
	rect.origin.y += 44.0;
	self.view.bounds = rect;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.235 green:0.600 blue:0.792 alpha:1.000];
	self.navigationController.navigationBar.topItem.title = @"Sign In";
	self.navigationItem.hidesBackButton = YES;
	[txtUsername setDelegate:self];
	[txtPassword setDelegate:self];
	
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
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
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
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
@end
