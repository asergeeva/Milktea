//
//  LiveViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "LiveViewController.h"
#import "SettingsManager.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
@implementation LiveViewController
@synthesize liveEventBack;
@synthesize event;
@synthesize tweets;
@synthesize tweetTable;
//@synthesize twit;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)thisEvent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		event = thisEvent;
		tweets = [[NSMutableArray alloc] init];
		lastTweet = [[NSMutableDictionary alloc] init];
//		twit = [[MGTwitterEngine alloc] initWithDelegate:self];
//		[twit setConsumerKey:@"oDMGOs0jPxFz7DDULHnw" secret:@"wHO9IHpUUkDIj1sGCs7YWRRUnKj4FMrmBrYwQGoMpw"];
//		[twit setUsesSecureConnection:YES];
//		[twit getXAuthAccessTokenForUsername:@"deadmau50r" password:@"deadmau5"];
        // Custom initialization
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
	if(!twit)
	{
		twit = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
		twit.consumerKey = consumerKey;
		twit.consumerSecret = consumerSecret;
	}
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twit delegate:self];
	
	if (controller)
		[self presentModalViewController:controller animated: YES];
	else 
	{
		[self updateStream];
	}
}
- (void)resignKeyboard
{
	[tweetField resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
	[self.view addGestureRecognizer:tap];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	eventName.text = event.eventName;
	liveEventBack.layer.cornerRadius = 5;
	liveEventBack.layer.shadowOffset = CGSizeMake(0.0, 0.25);
	liveEventBack.layer.shadowOpacity = 0.25;
	liveEventBack.layer.shouldRasterize = YES;
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"MMMM d - hh:mm a";
	eventDate.text = [df stringFromDate:event.eventDate];
	[df release];
	tweetTable.backgroundColor = [UIColor colorWithRed:0.925 green:0.914 blue:0.875 alpha:1.000];
	tweetTable.dataSource = self;
	tweetTable.delegate = self;
	CGRect rect = self.view.frame;
	rect.origin.y += 44;
	self.view.bounds = rect;
    // Do any additional setup after loading the view from its nib.
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
	[tweetField resignFirstResponder];
	NSString *hashtag = [NSString stringWithFormat:@"#trueRSVP%@", event.eventID];
	if(tweetField.text.length > 139-hashtag.length)
	{
		[twit sendUpdate:[NSString stringWithFormat:@"%@ %@", [tweetField.text substringToIndex:139-hashtag.length], hashtag]];
	}
	else
	{
		[twit sendUpdate:[NSString stringWithFormat:@"%@ %@", tweetField.text, hashtag]];	
	}
//	NSDictionary *dictionary = [[NSDictionary alloc] init];
	[lastTweet removeAllObjects];
	[lastTweet setValue:[[User sharedUser] picURL] forKey:@"profile_image_url"];
	[lastTweet setValue:tweetField.text forKey:@"text"];
	[tweets insertObject:lastTweet atIndex:0];
	[tweetTable reloadData];
}
#pragma mark - Twitter
- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username
{
	[[SettingsManager sharedSettingsManager].twitterCache setString:data];
	[[SettingsManager sharedSettingsManager] save];
}
- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *)username
{
	return [SettingsManager sharedSettingsManager].twitterCache;
}
- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username
{
	
}
- (void)updateStream
{
	NSURL *url = [NSURL URLWithString:@"http://search.twitter.com/search.json?q=%23deadmau5"];
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%23truersvp%@", event.eventID]];
//	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%23truersvp%@", event.eventID]]];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	NSArray *temp = [[[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil] objectForKey:@"results"];
	[tweets removeAllObjects];
	for(NSDictionary *dictionary in temp)
	{
		[tweets addObject:dictionary];
	}
//	NSLog(@"%@", [twit getSearchResultsForQuery:@"%23twitterapi"]);
}
#pragma mark - UITableView methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 75)];
	cell.backgroundColor = [UIColor clearColor];
	view.backgroundColor = [UIColor whiteColor];
	view.layer.cornerRadius = 5;
	view.layer.shadowOpacity = 0.25;
	view.layer.shadowOffset = CGSizeMake(0.0, 0.2);
	view.layer.shouldRasterize = YES;
	[cell.contentView addSubview:view];
	int index = indexPath.row;
	if([lastTweet count] > 0 && indexPath.row != 0)
	{
		index++;
	}
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
	return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if([tweets count] <= 0)
	{
		[self updateStream];
	}
	if([lastTweet count] > 0)
	{
		return [tweets count]+1;
	}
	return [tweets count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 95.0;
}
#pragma mark - Other
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		liveEventBack.frame = CGRectMake(10, 54, 460, 40);
		tweetField.frame = CGRectMake(59, 109, 364, 31);
		shareButton.frame = CGRectMake(431, 109, 39, 31);
	}
	else
	{
		liveEventBack.frame = CGRectMake(10, 54, 300, 40);
		tweetField.frame = CGRectMake(59, 109, 204, 31);
		shareButton.frame = CGRectMake(271, 109, 39, 31);
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
	[lastTweet release];
    [super dealloc];
}
@end
