//
//  QRViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 9/6/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "QRViewController.h"
#import "QREncoder/QREncoder.h"
#import <QuartzCore/QuartzCore.h>
@implementation QRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil string:(NSString*)contents
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_contents = contents;
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
- (void)viewWillAppear:(BOOL)animated
{
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
	[super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//	UIViewController *qrVC = [[UIViewController alloc] init];
	//	qrVC.view.backgroundColor = [UIColor colorWithRed:0.914 green:0.902 blue:0.863 alpha:1.000];
	UIImage *qrImage = [QREncoder encode:_contents];
//	UIImageView* imageView = [[UIImageView alloc] initWithImage:qrImage];
	[qrView setImage:qrImage];
	[qrView layer].magnificationFilter = kCAFilterNearest;
	[self.view addSubview:qrView];
	
//	NSString *contents = [NSString stringWithFormat:@"truersvp-%@-%@", eventAttending.eventID, [User sharedUser].uid];
//	QRViewController *qrVC = [[QRViewController alloc] initWithNibName:@"QRViewController" bundle:[NSBundle mainBundle] string:contents];
//	[self presentModalViewController:qrVC animated:YES];
	
//	[qrVC release];
	
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[qrView release];
	qrView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		qrView.frame = CGRectMake(140, 34, 200, 200);
	}
	else
	{
		qrView.frame = CGRectMake(10, 80, 300, 300);
	}
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)dealloc {
	[qrView release];
	[super dealloc];
}
@end
