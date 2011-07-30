//
//  LiveViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/29/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "LiveViewController.h"

@implementation LiveViewController
@synthesize liveEventBack;
//@synthesize twit;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [liveEventBack release];
    [eventName release];
    [eventDate release];
    [cameraButton release];
    [tweetField release];
    [shareButton release];
    [super dealloc];
}
@end
