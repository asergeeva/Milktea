//
//  CheckIn.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 8/20/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "CheckIn.h"

@implementation CheckIn
@synthesize eid;
@synthesize uid;
@synthesize isAttending;
@synthesize date;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.eid = [aDecoder decodeObjectForKey:@"eid"];
	self.uid = [aDecoder decodeObjectForKey:@"uid"];
	self.isAttending = [aDecoder decodeBoolForKey:@"isAttending"];
	self.date = [aDecoder decodeObjectForKey:@"date"];
	return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:eid forKey:@"eid"];
	[aCoder encodeObject:uid forKey:@"uid"];
	[aCoder encodeBool:isAttending forKey:@"isAttending"];
	[aCoder encodeObject:date forKey:@"date"];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc
{
	[eid release];
	[uid release];
	[date release];
	[super dealloc];
}
@end
