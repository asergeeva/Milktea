//
//  ListController.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/4/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "SettingsManager.h"
@interface ListController : NSObject <UITableViewDataSource>
{
	NSMutableArray *uniqueMonths;
	NSMutableArray *eventSections;
	NSArray *eventArray;
}
@property (nonatomic, retain) NSMutableArray *uniqueMonths;
@property (nonatomic, retain) NSMutableArray *eventSections;
@property (nonatomic, retain) NSArray *eventArray;
@end
