//
//  ListViewController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/4/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListController.h"
#import <QuartzCore/QuartzCore.h>
@protocol RefreshDelegate
@optional
-(void)refresh;
@end
@interface ListViewController : UIViewController <UITableViewDelegate>
{
	IBOutlet UITableView *eventTableView;
	ListController *listController;
	UIView *refreshHeaderView;
	BOOL isDragging;
    BOOL isLoading;
}
- (void)addPullRefreshHeader:(UITableView*)tableView;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
@property (nonatomic, retain) ListController *listController;
@property (nonatomic, retain) IBOutlet UITableView *eventTableView;
@property (nonatomic, retain) UIView *refreshHeaderView;
@end
