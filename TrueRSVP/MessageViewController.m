//
//  MessageViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/2/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "MessageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "SettingsManager.h"
@implementation MessageViewController
@synthesize selectedFromList;
@synthesize eventName;
@synthesize eventDate;
//@synthesize sendButton;
//@synthesize emailCheck;
//@synthesize textCheck;
@synthesize _event;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil list:(NSMutableArray*)list event:(Event*)thisEvent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		selectedFromList = [list mutableCopy];
		_event = thisEvent;
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
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	if([messageTextView isFirstResponder])
	{
		[messageTextView resignFirstResponder];
	}
	[super touchesEnded:touches withEvent:event];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect rect = self.view.frame;
		rect.origin.y = -70;
		self.view.frame = rect;
	}];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect rect = self.view.frame;
		rect.origin.y = 0;
		self.view.frame = rect;
	}];	
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
- (IBAction)emailPressed:(UIButton*)sender
{
	if(emailCheck.selected)
	{
		emailCheck.selected = NO;
	}
	else
	{
		emailCheck.selected = YES;
	}
}
- (IBAction)textPressed:(UIButton*)sender
{
	if(textCheck.selected)
	{
		textCheck.selected = NO;
	}
	else
	{
		textCheck.selected = YES;
	}	
}
- (IBAction)sendPressed:(UIButton*)sender
{
	if(!emailCheck.selected && !textCheck.selected)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaging" 
														message:@"Please select at least one form of messaging service."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sendMessage", [[SettingsManager sharedSettingsManager].settings objectForKey:@"APILocation"]]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	for(int i = 0; i < selectedFromList.count; i++)
	{
		[request setPostValue:[selectedFromList objectAtIndex:i] forKey:[NSString stringWithFormat:@"uid[%i]", i]];
	}
	[request setPostValue:_event.eventID forKey:@"eventId"];
	[request setPostValue:[NSString stringWithFormat:@"Event: %@", eventName.text] forKey:@"reminderSubject"];
	[request setPostValue:messageTextView.text forKey:@"reminderContent"];
	if(emailCheck.selected && textCheck.selected)
	{
		[request setPostValue:@"both" forKey:@"form"];
	}
	else if(emailCheck.selected)
	{
		[request setPostValue:@"email" forKey:@"form"];
	}
	else if(textCheck.selected)
	{
		[request setPostValue:@"text" forKey:@"form"];
	}
	[request startSynchronous];
	NSLog(@"%@", [request responseString]);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	messageTextView.delegate = self;
	sendButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BlueBackground_1px.png"]];
	[textCheck setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
	[emailCheck setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
	sendButton.layer.cornerRadius = 5;
	sendButton.clipsToBounds = YES;
	if([UIDevice currentDevice].isMultitaskingSupported)
	{
		[self addEffects:eventWhiteBack];
		[self addEffects:toWhiteBack];
		[self addEffects:messageWhiteBack];
		[self addEffects:sendWhiteBack];
		[self addEffects:messageTextView];
		messageTextView.layer.borderColor = [[UIColor grayColor] CGColor];
		messageTextView.layer.borderWidth = 2.0;
	}
	eventName.text = _event.eventName;
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-MM-dd hh:mm a";
	eventDate.text = [df stringFromDate:_event.eventDate];
	[df release];
//	eventDate = 
}

- (void)viewDidUnload
{
    [eventWhiteBack release];
    eventWhiteBack = nil;
	[eventName release];
	eventName = nil;
	[eventDate release];
	eventDate = nil;
	[toWhiteBack release];
	toWhiteBack = nil;
	[toLabel release];
	toLabel = nil;
	[selectionButton release];
	selectionButton = nil;
	[messageWhiteBack release];
	messageWhiteBack = nil;
	[messageLabel release];
	messageLabel = nil;
	[messageTextView release];
	messageTextView = nil;
	[emailCheck release];
	emailCheck = nil;
	[textCheck release];
	textCheck = nil;
	[sendAsEmail release];
	sendAsEmail = nil;
	[sendAsText release];
	sendAsText = nil;
	[sendWhiteBack release];
	sendWhiteBack = nil;
	[sendButton release];
	sendButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
	[selectedFromList release];
	[_event release];
	
    [eventWhiteBack release];
	[eventName release];
	[eventDate release];
	[toWhiteBack release];
	[toLabel release];
	[selectionButton release];
	[messageWhiteBack release];
	[messageLabel release];
	[messageTextView release];
	[emailCheck release];
	[textCheck release];
	[sendAsEmail release];
	[sendAsText release];
	[sendWhiteBack release];
	[sendButton release];
	[super dealloc];
}
@end
