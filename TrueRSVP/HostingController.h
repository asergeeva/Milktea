//
//  HostingController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostingController : NSObject <UITableViewDataSource>
{
	NSMutableArray *uniqueMonths;
	NSMutableArray *eventSections;
}
+ (NSString*)getSectionText:(NSString*)selectedMonth;
- (void)refreshHosting;
@property (nonatomic, retain) NSMutableArray *uniqueMonths;
@property (nonatomic, retain) NSMutableArray *eventSections;
@end
