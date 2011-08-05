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
}
+ (NSString*)getSectionText:(NSString*)selectedMonth;
- (void)refresh;
@end
