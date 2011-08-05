//
//  HostingViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostingController.h"
#import "HostingDetailViewController.h"
#import "ListViewController.h"
@protocol HostingDelegate
@optional
- (void)selectedEvent:(UIViewController*)viewController;
@end
@interface HostingViewController : ListViewController
{
	HostingController *hostingController;
	HostingDetailViewController *hostingDetailVC;
	id<HostingDelegate> delegate;
}
@property (nonatomic, retain) HostingController *hostingController;
@property (nonatomic, retain) HostingDetailViewController *hostingDetailVC;
@property (nonatomic, assign) id<HostingDelegate> delegate;
@end
