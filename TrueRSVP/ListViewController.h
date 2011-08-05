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
@interface ListViewController : UIViewController <UITableViewDelegate>
{
	IBOutlet UITableView *eventTableView;
	ListController *listController;
}
@property (nonatomic, retain) ListController *listController;
@property (nonatomic, retain) IBOutlet UITableView *eventTableView;
@end
