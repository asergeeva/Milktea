//
//  AttendingViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView *eventTableView;
	NSMutableArray *uniqueMonths;
	NSMutableArray *eventSections;
//	NSMutableArray *eventRows;
}
@property (nonatomic, retain) IBOutlet UITableView *eventTableView;
@property (nonatomic, retain) NSMutableArray *uniqueMonths;
@property (nonatomic, retain) NSMutableArray *eventSections;
@end
