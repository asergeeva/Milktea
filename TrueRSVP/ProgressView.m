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
@synthesize progressBar;
NSTimer *timer;
- (void)progressCheck
{
	if(progressBar.progress == 1.0 && [[NetworkManager sharedNetworkManager] checkFilled])
	{
//		UINavigationController *navController = self.navigationController;
//		NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
//		[controllers removeLastObject];
//		navController.viewControllers = controllers;
		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:mainVC animated:YES];
//		[navController pushViewController:mainVC animated:YES];
//		[mainVC willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
		[mainVC release];
		[timer invalidate];
		[[SettingsManager sharedSettingsManager].settings setObject:[NSNumber numberWithBool:TRUE] forKey:@"Preloaded"];
		[[SettingsManager sharedSettingsManager] save];
//		[NetworkManager sharedNetworkManager].delegate = nil;
	}
}
- (void)offlineMode
{
	if([[NetworkManager sharedNetworkManager] checkFilled])
	{
		MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:mainVC animated:YES];
		[mainVC release];
		[timer invalidate];
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
	[NetworkManager sharedNetworkManager].delegate = self;
	[[NetworkManager sharedNetworkManager] refreshAll:progressBar];
	self.navigationController.navigationItem.hidesBackButton = YES;
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressCheck) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setProgressBar:nil];
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
    [progressBar release];
    [super dealloc];
}
@end
