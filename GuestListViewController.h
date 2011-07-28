//
//  GuestListViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/27/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GuestListController.h"
#import "Event.h"
#import "Attendee.h"

@interface GuestListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
{
	IBOutlet UILabel *eventName;
	IBOutlet UILabel *eventDate;
	IBOutlet UIView *eventNameBack;
	IBOutlet UITableView *guestTable;
	IBOutlet UIView *eventCheckBack;
//	GuestListController *guestList;
	IBOutlet UILabel *eventCheck;
	NSMutableArray *guestNameAttendance;
	Event *event;
	UIToolbar *toolbar;
	UIButton *searchButton;
	UIButton *refreshButton;
	UIButton *sendButton;
//	IBOutlet UISearchDisplayController *searchBar;
}
- (void)refreshGuestList;
- (void)checkboxPressed:(UIButton*)sender;
- (void)sortPressed:(UIButton*)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)thisEvent;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventDate;
@property (nonatomic, retain) IBOutlet UIView *eventNameBack;
@property (nonatomic, retain) IBOutlet UIView *eventCheckBack;
@property (nonatomic, retain) IBOutlet UITableView *guestTable;
//@property (nonatomic, retain) GuestListController *guestList;
@property (nonatomic, retain) IBOutlet UILabel *eventCheck;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSMutableArray *guestNameAttendance;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIButton *searchButton;
@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UIButton *sendButton;
//@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchBar;
@end
