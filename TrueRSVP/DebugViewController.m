//
//  DebugViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/27/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "DebugViewController.h"
//#import "Constants.h"
#import "SettingsManager.h"
@implementation DebugViewController
@synthesize debugAddress;
@synthesize debugDoneButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dismissDebug:(id)sender
{
//	[[SettingsManager sharedSettingsManager] setObject:debugAddress.text forKey:@"rootAddress"];
	[[NSUserDefaults standardUserDefaults] setValue:debugAddress.text forKey:@"rootAddress"];
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@api/", debugAddress.text] forKey:@"APILocation"];
	[[NSUserDefaults standardUserDefaults] synchronize];
//	[[SettingsManager sharedSettingsManager] save];
	[self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
	[debugAddress release];
	[debugDoneButton release];
	[super dealloc];
}
#pragma mark - View lifecycle
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self dismissDebug:nil];
	return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"debugBackground.png"]];
	debugAddress.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"rootAddress"];
	debugAddress.returnKeyType = UIReturnKeyDone;
	debugAddress.delegate = self;
    // Do any additional setup after loading the view from its nib.
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
