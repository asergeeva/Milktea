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
#import "ListViewController.h"
@protocol AttendingDelegate
@optional
- (void)selectedEvent:(UIViewController*)viewController;
@end
@interface AttendingListViewController : ListViewController
{
	AttendingController *attendingController;
	AttendingDetailViewController *attendingDetailVC;
	id<AttendingDelegate> delegate;
}
@property (nonatomic, retain) AttendingController *attendingController;
@property (nonatomic, retain) AttendingDetailViewController *attendingDetailVC;
@property (nonatomic, assign) id<AttendingDelegate> delegate;
@end
