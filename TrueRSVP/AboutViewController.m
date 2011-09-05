//
//  AboutViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/30/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation AboutViewController
@synthesize OKButton;

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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if([request.URL isEqual:[NSURL URLWithString:@"https://www.truersvp.com/method"]])
	{
		return YES;
	}
	return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	OKButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	OKButton.contentMode = UIViewContentModeBottom;
	OKButton.layer.cornerRadius = 5;
	OKButton.clipsToBounds = YES;
	legalButton.contentMode = UIViewContentModeBottom;
	legalButton.layer.cornerRadius = 5;
	legalButton.clipsToBounds = YES;
	NSURL *url = [NSURL URLWithString:@"https://www.truersvp.com/method"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
	webView.scalesPageToFit = YES;
	webView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)legal:(id)sender
{
	if(!legalShown)
	{
		legalShown = YES;
		webView.hidden = YES;
		legalView.hidden = NO;
		[legalButton setTitle:@"About" forState:UIControlStateNormal];
	}
	else
	{
		legalView.hidden = YES;
		webView.hidden = NO;
		legalShown = NO;
		[legalButton setTitle:@"Legal" forState:UIControlStateNormal];
	}
}
- (void)viewDidUnload
{
    [self setOKButton:nil];
	[webView release];
	webView = nil;
	[legalButton release];
	legalButton = nil;
	[legalView release];
	legalView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)dealloc {
    [OKButton release];
	[webView release];
	[legalButton release];
	[legalView release];
    [super dealloc];
}
- (IBAction)dismiss:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
@end
