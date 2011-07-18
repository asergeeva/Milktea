//
//  TrueRSVPViewController.m
//  TrueRSVP
//
//  Created by movingincircles on 7/16/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "SignInViewController.h"
//#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
@implementation SignInViewController
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize navBar;
@synthesize facebook;
//@synthesize loginButton;
- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
		rect.origin.y -= 150.0;
    }
    else
    {
		rect.origin.y += 150.0;
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
	NSURL *url = [NSURL URLWithString:@"http://localhost/Eventfii/api/login"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:[txtUsername text] forKey:@"email"];
//	[request setPostValue:@"movingincircles@gmail.com" forKey:@"email"];
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
		[self.navigationController popToRootViewControllerAnimated:NO];
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
	self.navigationController.navigationBarHidden = YES;
	navBar.topItem.title = @"Sign In";
//	self.navigationItem.hidesBackButton = YES;
//	self.navigationItem.title = @"Sign In";
//	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.0];
	[txtUsername setDelegate:self];
	[txtPassword setDelegate:self];
	
    [super viewDidLoad];
//	NSLog(@"HI");
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	return [facebook handleOpenURL:url]; 
}
- (void)fbDidLogin {
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
