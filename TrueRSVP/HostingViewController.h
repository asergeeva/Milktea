//
//  HostingViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostingController.h"
@protocol HostingDelegate
@optional
- (void)selectedEvent:(UIViewController*)viewController;
@end
@interface HostingViewController : UIViewController <UITableViewDelegate>
{
	HostingController *hostingController;
	id<HostingDelegate> delegate;
}
@property (nonatomic, retain) IBOutlet UITableView *eventTableView;
@property (nonatomic, retain) HostingController *hostingController;
@property (nonatomic, assign) id<HostingDelegate> delegate;
@end
