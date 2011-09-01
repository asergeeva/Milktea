//
//  AboutViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/30/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "AboutViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	OKButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	OKButton.contentMode = UIViewContentModeBottom;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setOKButton:nil];
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
    [super dealloc];
}
- (IBAction)dismiss:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
@end
