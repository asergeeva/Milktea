//
//  AttendingViewController.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/21/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "ListViewController.h"
#import "NetworkManager.h"
#import "Constants.h"
#import "AttendanceList.h"
@implementation ListViewController
@synthesize eventTableView;
@synthesize listController;
@synthesize refreshHeaderView;

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{

    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	eventTableView.delaysContentTouches = NO;
	eventTableView.autoresizesSubviews = YES;
	eventTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	noticeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//	noticeLabel.contentMode = UIViewContentModeBottom;
	[self addPullRefreshHeader:eventTableView];
}
#pragma mark - Unloading
- (void)viewDidUnload
{
    [noticeLabel release];
    noticeLabel = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
//	[eventTableView release];
//	[listController release];
	[refreshHeaderView release];
    [noticeLabel release];
	[super dealloc];
}
#pragma mark - View Delegate Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
	{
		self.eventTableView.frame = CGRectMake(0, 32, self.eventTableView.frame.size.width, self.eventTableView.frame.size.height);
		self.view.bounds = CGRectMake(0, 32, 480, 320);
		for(UITableViewCell *cell in [eventTableView visibleCells])
		{
			cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_landscape.png"]] autorelease];
			cell.backgroundView.contentMode = UIViewContentModeCenter;
		}
	}
	else
	{
		self.eventTableView.frame = CGRectMake(0, 44, self.eventTableView.frame.size.width, self.eventTableView.frame.size.height);
		self.view.bounds = CGRectMake(0, 44, 320, 383);
		for(UITableViewCell *cell in [eventTableView visibleCells])
		{
			cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_portrait.png"]] autorelease];
			cell.backgroundView.contentMode = UIViewContentModeCenter;
		}
	}
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 22;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)] autorelease];
	sectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"OrangeBackground_1px.png"]];
	UILabel *label = [[[UILabel alloc] initWithFrame:sectionView.frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:15];
	if([UIDevice currentDevice].multitaskingSupported)
	{
		label.layer.shadowOpacity = 0.2;
		label.layer.shadowOffset = CGSizeMake(0.0, 2.0);
		label.layer.rasterizationScale = [[UIScreen mainScreen] scale];
		label.layer.shouldRasterize = YES;
	}
	NSString *selectedMonth = [listController.uniqueMonths objectAtIndex:section];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateFormat = @"yyyy-M/MM";
	if([selectedMonth isEqualToString:[df stringFromDate:[NSDate date]]])
	{
		[label setText:@"   This Month"];
	}
	else
	{
		NSDate *fromString = [df dateFromString:selectedMonth];
		df.dateFormat = @"   MMMM";
		label.text = [df stringFromDate:fromString];
	}
	[sectionView addSubview: label];
	[df release];
	return sectionView;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	       return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)] autorelease];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 5;
}
- (void)addPullRefreshHeader:(UITableView*)tableView
{
//	refreshHeaderView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 0 - REFRESH_HEADER_HEIGHT + 5, 300, REFRESH_HEADER_HEIGHT - 10)] autorelease];
//	refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	refreshHeaderView.image = [UIImage imageNamed:@"bar_portrait.png"];
//	UILabel *refreshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, REFRESH_HEADER_HEIGHT/2 - 15, 320, 19)] autorelease];
//	refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	refreshLabel.text = @"Pull down and release to refresh";
//	refreshLabel.font = [UIFont boldSystemFontOfSize:17.0];
//	refreshLabel.textAlignment = UITextAlignmentCenter;
//	refreshLabel.backgroundColor = [UIColor clearColor];
//	refreshLabel.textColor = [UIColor darkGrayColor];
//	[refreshHeaderView addSubview:refreshLabel];
//	[tableView addSubview:refreshHeaderView];
	refreshHeaderView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 0 - REFRESH_HEADER_HEIGHT + 5, 300, REFRESH_HEADER_HEIGHT - 10)] autorelease];
	refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	UILabel *refreshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, REFRESH_HEADER_HEIGHT/2 - 15, 320, 19)] autorelease];
	refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	refreshLabel.text = @"Pull down and release to refresh";
	refreshLabel.textColor = [UIColor colorWithRed:0.798 green:0.760 blue:0.695 alpha:1.000];
	refreshLabel.font = [UIFont boldSystemFontOfSize:14];
	refreshLabel.textAlignment = UITextAlignmentCenter;
	refreshLabel.backgroundColor = [UIColor clearColor];
	[refreshHeaderView addSubview:refreshLabel];
	UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullarrow.png"]] autorelease];
	CGRect frame = image.frame;
	frame.origin.x += 20;
	frame.origin.y += 5;
	image.frame = frame;
	[refreshHeaderView addSubview:image];
	[tableView addSubview:refreshHeaderView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) 
	{
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.eventTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.eventTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } 
//	else if (isDragging && scrollView.contentOffset.y < 0) 
//	{
//    
//	}
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    if (isLoading) 
	{
		return;
	}
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) 
	{
        [self startLoading];
    }
}
- (void)startLoading 
{
    isLoading = YES;
	[UIView animateWithDuration:0.5 animations:^(void) 
	{
		self.eventTableView.contentInset = UIEdgeInsetsMake(0, REFRESH_HEADER_HEIGHT, 0, 0);		
	} completion:^(BOOL finished) {
		if(finished)
		{
			[self refresh];
		}
	}];

}

- (void)stopLoading 
{
	[eventTableView reloadData];
    isLoading = NO;
	[UIView animateWithDuration:0.3 animations:^(void) 
	{
		self.eventTableView.contentInset = UIEdgeInsetsZero;
	}];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{

}

- (void)refresh 
{
	[[NetworkManager sharedNetworkManager] refreshAllWithDelegate:self completion:@selector(stopLoading)];
//	[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}
@end
