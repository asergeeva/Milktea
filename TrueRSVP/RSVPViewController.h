//
//  RSVPViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 9/3/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;
@class CheckInButton;
@interface RSVPViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UILabel *eventTitle;
	IBOutlet UILabel *eventDate;
	IBOutlet UILabel *currentRSVP;
	IBOutlet UITableView *rsvpTable;
	IBOutlet UIView *eventBack;
	NSArray *choices;
	IBOutlet UIView *rsvpBack;
	NSArray *confidenceLevels;
	NSMutableArray *checkboxes;
	NSString *eid;
	int confidence;
//	IBOutlet UIToolbar *selectToolbar;
	IBOutlet UILabel *orangeLabel;
	Event *_event;
	IBOutlet UIButton *updateButton;
}
- (void)cellPressed:(int)confidence;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)event;
- (IBAction)updatePressed:(id)sender;
@end
