//
//  AttendingViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendingController.h"
#import "AttendingDetailViewController.h"
@protocol AttendingDelegate
@optional
- (void)selectedEvent:(UIViewController*)viewController;
@end
@interface AttendingViewController : UIViewController <UITableViewDelegate>
{
	IBOutlet UITableView *eventTableView;
	AttendingController *attendingController;
	AttendingDetailViewController *attendingDetailVC;
//	NSMutableArray *uniqueMonths;
//	NSMutableArray *eventSections;
	id<AttendingDelegate> delegate;
//	NSMutableArray *eventRows;
}
@property (nonatomic, retain) IBOutlet UITableView *eventTableView;
@property (nonatomic, retain) AttendingController *attendingController;
@property (nonatomic, retain) AttendingDetailViewController *attendingDetailVC;
//@property (nonatomic, retain) NSMutableArray *uniqueMonths;
//@property (nonatomic, retain) NSMutableArray *eventSections;
@property (nonatomic, assign) id<AttendingDelegate> delegate;
@end
