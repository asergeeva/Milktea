//
//  HostingController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListController.h"
@interface HostingController : ListController
{
//	NSMutableArray *uniqueMonths;
//	NSMutableArray *eventSections;
}
+ (NSString*)getSectionText:(NSString*)selectedMonth;
- (void)refresh;
//@property (nonatomic, retain) NSMutableArray *uniqueMonths;
//@property (nonatomic, retain) NSMutableArray *eventSections;
@end
