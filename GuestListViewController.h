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

@interface GuestListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
	IBOutlet UILabel *eventCheck;
	IBOutlet UILabel *eventDate;
	IBOutlet UILabel *eventName;
//	IBOutlet UINavigationBar *navBar;
	IBOutlet UITableView *guestTable;
	IBOutlet UIView *eventCheckBack;
	IBOutlet UIView *eventNameBack;
	UIButton *doneButton;
	UIButton *refreshButton;
	UIButton *searchButton;
	UIButton *sendButton;
	UISearchBar *searchBar;
	UIToolbar *toolbar;
	UIToolbar *toolbar2;
	UIView *masterHeader;
	UIView *searchHeader;
	NSMutableArray *filteredArray;
	NSMutableArray *guestNameAttendance;
	NSMutableArray *selectionList;
	BOOL showMessages;
	BOOL inSearch;
//	UIView *scale;
	Event *event;
}
- (void)refreshGuestList;
- (void)checkboxPressed:(UIButton*)sender;
- (void)moveSearchOut:(float)duration;
- (void)sortPressed:(UIButton*)sender;
- (void)searchPressed:(UIButton*)sender;
- (void)donePressed:(UISearchBar *)thisSearchBar;
- (void)sendPressed:(UIButton*)sender;
- (void)backButtonPressed;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(Event*)thisEvent;
- (void)textFieldDidChange:(NSNotification*)bar;
//@property (nonatomic, retain) IBOutlet UILabel *eventCheck;
//@property (nonatomic, retain) IBOutlet UILabel *eventDate;
//@property (nonatomic, retain) IBOutlet UILabel *eventName;
//@property (nonatomic, retain) IBOutlet UITableView *guestTable;
//@property (nonatomic, retain) IBOutlet UIView *eventCheckBack;
//@property (nonatomic, retain) IBOutlet UIView *eventNameBack;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIButton *refreshButton;
@property (nonatomic, retain) UIButton *searchButton;
@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIView *masterHeader;
@property (nonatomic, retain) UIView *searchHeader;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIToolbar *toolbar2;
@property (nonatomic, retain) NSMutableArray *guestNameAttendance;
@property (nonatomic, retain) NSMutableArray *filteredArray;
@property (nonatomic) BOOL showMessages;
//@property (nonatomic, retain) NSMutableArray *selectionList;

//@property (nonatomic, retain) UIView *scale;
@property (nonatomic, retain) Event *event;
@end
