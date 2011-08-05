//
//  LiveViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "JSON.h"



#import "LiveViewController.h"
#import "SettingsManager.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
@interface LiveViewController (PrivateMethods)

- (void)resetUi;
- (void)presentLoginWithFlowType:(TwitterLoginFlowType)flowType;

@end
@implementation LiveViewController
@synthesize liveEventBack;
@synthesize thisEvent;
@synthesize tweets;
@synthesize tweetTable;
@synthesize logoutButton;
BOOL twitterLoginShown = NO;
BOOL uploading = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		thisEvent = event;
		tweets = [[NSMutableArray alloc] init];
		logoutButton = [[UIBarButtonItem alloc] init];
		oAuth = [[OAuth alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
		[oAuth loadOAuthTwitterContextFromUserDefaults];
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidAppear:(BOOL)animated
{

}
- (void)resignKeyboard
{
	[tweetField resignFirstResponder];
}
- (void)addEffects:(UIView*)view
{
	view.layer.cornerRadius = 5;
	view.layer.shadowOpacity = 0.3;
	view.layer.shadowOffset = CGSizeMake(0.0, 0.1);
	view.layer.shadowRadius = 1;
	view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	view.layer.shouldRasterize = YES;
}
- (void)viewDidLoad
{	
    [self resetUi];
	twitterLoginShown = NO;
    [super viewDidLoad];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	tweetField.delegate = self;
	self.navigationItem.title = @"Live Feed";
	eventName.text = thisEvent.eventName;
	if([UIDevice currentDevice].multitaskingSupported)
	{
		[self addEffects:liveEventBack];
	}
	logoutButton.title = @"Logout";
	logoutButton.target = self;
	logoutButton.action = @selector(logout);
//	[self.navigationItem setRightBarButtonItem:logout];
	self.navigationItem.rightBarButtonItem = logoutButton;
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"MMMM d - hh:mm a";
	eventDate.text = [df stringFromDate:thisEvent.eventDate];
	[df release];
	tweetTable.backgroundColor = [UIColor colorWithRed:0.914 green:0.902 blue:0.863 alpha:1.000]; 
	tweetTable.dataSource = self;
	tweetTable.delegate = self;
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
    // Do any additional setup after loading the view from its nib.
}
- (void)resetUi 
{
    if (oAuth.oauth_token_authorized) 
	{
		//logged in
		
    }
	else 
	{
		[self login];
    }
    
}
- (void)login 
{
	loginPopup = [[TwitterLoginPopup alloc] initWithNibName:@"TwitterLoginCallbackFlow" bundle:nil];
	loginPopup.oAuthCallbackUrl = @"trueRSVP://handleOAuthLogin";
	loginPopup.flowType = TwitterLoginCallbackFlow;
	loginPopup.oAuth = oAuth;
	loginPopup.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
	[self presentModalViewController:nav animated:YES];
	[nav release];
}
- (void)logout 
{
    [oAuth forget];
    [oAuth saveOAuthTwitterContextToUserDefaults];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)handleOAuthVerifier:(NSString *)oauth_verifier {
    [loginPopup authorizeOAuthVerifier:oauth_verifier];
}
#pragma mark -
#pragma mark TwitterLoginPopupDelegate

- (void)twitterLoginPopupDidCancel:(TwitterLoginPopup *)popup {
    [self dismissModalViewControllerAnimated:YES];        
    [loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
}

- (void)twitterLoginPopupDidAuthorize:(TwitterLoginPopup *)popup {
    [self dismissModalViewControllerAnimated:YES];        
    [loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
    [oAuth saveOAuthTwitterContextToUserDefaults];
    [self resetUi];
}

- (void)viewDidUnload
{
    [self setLiveEventBack:nil];
    [eventName release];
    eventName = nil;
    [eventDate release];
    eventDate = nil;
    [cameraButton release];
    cameraButton = nil;
    [tweetField release];
    tweetField = nil;
    [shareButton release];
    shareButton = nil;
	[tweetTable release];
	tweetTable = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];	
	}
}

- (IBAction)tweet:(UIButton*)sender
{
	if(tweetField.text.length == 0 )
	{
		return;
	}
	
	NSString *postUrl = @"https://api.twitter.com/1/statuses/update.json";
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc]
                                   initWithURL:[NSURL URLWithString:postUrl]];
	[tweetField resignFirstResponder];
	NSString *hashtag = [NSString stringWithFormat:@"#trueRSVP%@", thisEvent.eventID];
	if(tweetField.text.length > 139-hashtag.length)
	{
		tweetField.text = [NSString stringWithFormat:@"%@ %@", [tweetField.text substringToIndex:139-hashtag.length], hashtag];
	}
	else
	{
		tweetField.text = [NSString stringWithFormat:@"%@ %@", tweetField.text, hashtag];	
	}
	[tweetTable reloadData];
	
	NSMutableDictionary *postInfo = [NSMutableDictionary
                                     dictionaryWithObject:tweetField.text
                                     forKey:@"status"];
	for (NSString *key in [postInfo allKeys]) {
        [request setPostValue:[postInfo objectForKey:key] forKey:key];
    }
	[request addRequestHeader:@"Authorization" value:[oAuth oAuthHeaderForMethod:@"POST" andUrl:postUrl andParams:postInfo]];
	[request startSynchronous];
	tweetField.text = @"";
	[request release];
	[tweetField resignFirstResponder];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[tweetField resignFirstResponder];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitpic.com/2/upload.json"]];
    
    [req addRequestHeader:@"X-Auth-Service-Provider" value:@"https://api.twitter.com/1/account/verify_credentials.json"];
    [req addRequestHeader:@"X-Verify-Credentials-Authorization"
                    value:[oAuth oAuthHeaderForMethod:@"GET"
                                               andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                            andParams:nil]];    
    
    [req setData:UIImageJPEGRepresentation(((UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"]), 0.8) forKey:@"media"];
    [req setPostValue:@"e668abdf76a647a1ec1ccfcbbd857878" forKey:@"key"];
    // [req setPostValue:@"tweetmessage here" forKey:@"message"];
	req.delegate = self;
    [req startAsynchronous];
	UIView *blackView = [[[UIView alloc] initWithFrame:self.view.frame]autorelease];
	CGRect rect = blackView.frame;
	rect.origin.y += 44;
	blackView.frame = rect;
	blackView.backgroundColor = [UIColor blackColor];
	blackView.tag = 7778;
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
	uploadingMessage.tag = 7777;
	
	original.origin.x = original.size.width/2;
	original.origin.y = original.size.height/2;
	
	UILabel *uploadingMessageLabel = [[[UILabel alloc] initWithFrame:original] autorelease];
	uploadingMessageLabel.text = @"Uploading...";	
	uploadingMessageLabel.backgroundColor = [UIColor clearColor];
	uploadingMessageLabel.tag = 7777;
	uploadingMessageLabel.textAlignment = UITextAlignmentCenter;
	uploadingMessageLabel.textColor = [UIColor whiteColor];
	uploadingMessageLabel.font = [UIFont systemFontOfSize:15];
	[uploadingMessage addSubview:uploadingMessageLabel];
	
	[self.view addSubview:uploadingMessage];
	self.view.userInteractionEnabled = NO;
	self.navigationController.navigationBar.userInteractionEnabled = NO;
	[uploadingMessage release];
	
    [req release];
	[self dismissModalViewControllerAnimated:YES];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
	[UIView animateWithDuration:0.3 animations:^(void) {
		[self.view viewWithTag:7778].alpha = 0.0;
	} completion:^(BOOL finished) {
		 [[self.view viewWithTag:7778] removeFromSuperview];
	}];
	
	[[self.view viewWithTag:7777] removeFromSuperview];
	self.view.userInteractionEnabled = YES;
	self.navigationController.navigationBar.userInteractionEnabled = YES;
	NSDictionary *twitpicResponse = [[request responseString] JSONValue];
    tweetField.text = [NSString stringWithFormat:@"%@ %@", [twitpicResponse valueForKey:@"url"], tweetField.text];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	[UIView animateWithDuration:1.0 animations:^(void) {
		[self.view viewWithTag:7778].alpha = 0.0;
	}];
	self.view.userInteractionEnabled = YES;
	self.navigationController.navigationBar.userInteractionEnabled = YES;
	[[self.view viewWithTag:7777] removeFromSuperview];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
													message:@"There was an error uploading your picture. Try again."
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
- (IBAction)cameraPressed:(id)sender
{
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera" 
														message:@"Your device does not have a camera."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}
#pragma mark - Twitter
- (void)updateStream
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%%23truersvp%@", thisEvent.eventID]];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	NSArray *temp = [[[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil] objectForKey:@"results"];
	[tweets removeAllObjects];
	for(NSDictionary *dictionary in temp)
	{
		[tweets addObject:dictionary];
	}
}
#pragma mark - UITableView methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 75)];
	view.tag = 150;
	cell.backgroundColor = [UIColor clearColor];
	view.backgroundColor = [UIColor whiteColor];
	if([UIDevice currentDevice].multitaskingSupported)
	{
		[self addEffects:view];
	}
	[cell.contentView addSubview:view];
	int index = indexPath.row;
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[tweets objectAtIndex:index] objectForKey:@"profile_image_url"]]];
	[request startSynchronous];
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)] autorelease];
	imageView.image = [UIImage imageWithData:[request responseData]];
	[view addSubview:imageView];
	UITextView *theTweet = [[[UITextView alloc] initWithFrame:CGRectMake(65, 10, 225, 65)] autorelease];
	theTweet.userInteractionEnabled = NO;
	theTweet.text = [[tweets objectAtIndex:index] objectForKey:@"text"];
	theTweet.font = [UIFont systemFontOfSize:12];
	[view addSubview:theTweet];
	[view release];
	return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	[self updateStream];
	return [tweets count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 95.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self tweet:nil];
	return NO;
}
#pragma mark - Other
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	if([self.view isUserInteractionEnabled])
	{
		return YES;
	}
	return NO;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		liveEventBack.frame = CGRectMake(10, 54, 460, 40);
		tweetField.frame = CGRectMake(59, 109, 364, 31);
		shareButton.frame = CGRectMake(431, 109, 39, 31);
		for(UITableViewCell *cell in tweetTable.visibleCells)
		{
			for(UIView *view in cell.contentView.subviews)
			{
				if(view.tag == 150)
				{
					CGRect rect = view.frame;
					rect.size.width = 460;
					view.frame = rect;
				}
			}
		}
	}
	else
	{
		liveEventBack.frame = CGRectMake(10, 54, 300, 40);
		tweetField.frame = CGRectMake(59, 109, 204, 31);
		shareButton.frame = CGRectMake(271, 109, 39, 31);
		for(UITableViewCell *cell in tweetTable.visibleCells)
		{
			for(UIView *view in cell.contentView.subviews)
			{
				if(view.tag == 150)
				{
					CGRect rect = view.frame;
					rect.size.width = 300;
					view.frame = rect;
				}
			}
		}
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)dealloc {
    [liveEventBack release];
    [eventName release];
    [eventDate release];
    [cameraButton release];
    [tweetField release];
    [shareButton release];
	[tweets release];
	[tweetTable release];
//	[lastTweet release];
	[logoutButton release];
	[thisEvent release];
//	[uploadingMessage release];
//	[showUploadingMessage release];
	[oAuth release];
	[loginPopup release];
    [super dealloc];
}
@end
