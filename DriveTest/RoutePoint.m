//
//  RoutePoint.m
//  DriveTest
//
//  Created by Marvin Galang on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoutePoint.h"

@implementation RoutePoint

@synthesize coords = coords_;
@synthesize directions=directions_;

#pragma mark - Initializers/Destructors
- (id) initWithCenterCoordinate:(CLLocationCoordinate2D)coord directions:(CLLocationDirection) directions {
    self = [super init];
    if (self) {
        self.coords=coord;
        self.directions=directions;
    }
    return self;
}

#pragma mark - Archieving
- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super init])) {
        
        CLLocationDegrees latitude;
        CLLocationDegrees longitude;
        CLLocationDirection pointCourse;
        
        [decoder decodeValueOfObjCType:@encode(CLLocationDegrees) at:&latitude];
        [decoder decodeValueOfObjCType:@encode(CLLocationDegrees) at:&longitude];
        [decoder decodeValueOfObjCType:@encode(CLLocationDirection) at:&pointCourse];
        
        self.coords=CLLocationCoordinate2DMake(latitude, longitude);
        self.directions=pointCourse;

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    CLLocationDegrees latitude=self.coords.latitude;
    CLLocationDegrees longitude=self.coords.longitude;
    
    [coder encodeValueOfObjCType:@encode(CLLocationDegrees) at:&latitude];
    [coder encodeValueOfObjCType:@encode(CLLocationDegrees) at:&longitude];
    [coder encodeValueOfObjCType:@encode(CLLocationDirection) at:&directions_];
}

@end

