//
//  ProgressView.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "ProgressView.h"
#import "NetworkManager.h"
#import "MainViewController.h"
@implementation ProgressView
@synthesize hostingList;
@synthesize progressBar;
@synthesize timer;
//BOOL test = NO;
- (void)progressCheck
{
	if([[NetworkManager sharedNetworkManager] checkFilled])
	{
		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:mainVC animated:YES];
		[mainVC release];
		[[SettingsManager sharedSettingsManager].settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"Preloaded"];
		[[SettingsManager sharedSettingsManager] save];
		[timer invalidate];
	}
}
- (void)offlineMode
{
	if(![[NetworkManager sharedNetworkManager] isOnline])
	{
		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:mainVC animated:YES];
		[mainVC release];
//		[timer invalidate];
		[[SettingsManager sharedSettingsManager].settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"Preloaded"];
		[[SettingsManager sharedSettingsManager] save];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline" message:@"No internet connection detected. Going offline. Some features are disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}	

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
//	if(!test)
//	{
//	[NetworkManager sharedNetworkManager].delegate = self;
//	}

//		test = YES;

//	self.navigationItem.hidesBackButton = YES;

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
	//[super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
//	[[NetworkManager sharedNetworkManager] refreshAll:progressBar];
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressCheck) userInfo:nil repeats:YES];	
	[super viewDidAppear:animated];
}
- (void)viewDidUnload
{
//    [self setProgressBar:nil];
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
//    [progressBar release];
    [super dealloc];
}
@end
