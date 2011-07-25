//
//  EventAnnotation.m
//  TrueRSVP
//
//  Created by Nicholas C Chan on 7/25/11.
//  Copyright 2011 Komocode. All rights reserved.
//

#import "EventAnnotation.h"

@implementation EventAnnotation
@synthesize name;
@synthesize coordinate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithName:(NSString*)eventName coordinate:(CLLocationCoordinate2D)eventCoordinate
{
	if((self = [super init]))
	{
		name = [eventName copy];
		coordinate = eventCoordinate;
	}
	return self;
}
- (void)dealloc
{
	[name release];
	[super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
