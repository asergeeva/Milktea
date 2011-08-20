//
//  Attendee.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/27/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "Attendee.h"

@implementation Attendee
@synthesize uid;
@synthesize fname;
@synthesize lname;
@synthesize isAttending;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (id)initWithCoder:(NSCoder*)aDecoder
{
	self.uid = [aDecoder decodeObjectForKey:@"uid"];
	self.fname = [aDecoder decodeObjectForKey:@"fname"];
	self.lname = [aDecoder decodeObjectForKey:@"lname"];
	self.isAttending = [aDecoder decodeBoolForKey:@"isAttending"];
    return self;
}
- (void)encodeWithCoder:(NSCoder*)coder
{
	[coder encodeObject:uid forKey:@"uid"];
	[coder encodeObject:fname forKey:@"fname"];
	[coder encodeObject:lname forKey:@"lname"];
	[coder encodeBool:isAttending forKey:@"isAttending"];
}
- (id)copyWithZone:(NSZone*)zone
{
	id copy;
	copy = [[[self class] allocWithZone:zone] init];
	[copy setUid:[self valueForKey:@"uid"]];
	[copy setFname:[self valueForKey:@"fname"]];
	[copy setLname:[self valueForKey:@"lname"]];
	[copy setIsAttending:[self isAttending]];
	return copy;
}
- (void)dealloc
{
	[uid release];
	[fname release];
	[lname release];
	[super dealloc];
}
@end
