//
//  QueuedActions.h
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/19/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckIn.h"
@interface QueuedActions : NSObject
{
	NSMutableArray *queue;
}
+(QueuedActions*)sharedQueuedActions;
- (void)addActionWithEID:(NSString*)eid userID:(NSString*)uid attendance:(BOOL)isAttending date:(NSDate*)date;
- (void)save;
- (void)load;
- (void)processQueue;
@property (nonatomic, retain) NSMutableArray *queue;
@end
