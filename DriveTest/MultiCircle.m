//
//  MultiPolygon.m
//  DriveTest
//
//  Created by Marvin Galang on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiCircle.h"
#import "RoutePoint.h"

@implementation MultiCircle

@synthesize routePointsToDraw = routePointsToDraw_;
@synthesize boundingMapRect=boundingMapRect_;

- (id)initWithPoints:(NSArray *)points
{
    if (self = [super init]) {
        self.routePointsToDraw = points;
        NSUInteger circleCount = [self.routePointsToDraw count];
        if (circleCount) {
            CLLocationCoordinate2D x=[[self.routePointsToDraw objectAtIndex:0] coords];
            
            MKMapPoint origin = MKMapPointForCoordinate(x);
            
            origin.x -= MKMapSizeWorld.width / 8.0;
            origin.y -= MKMapSizeWorld.height / 8.0;
            MKMapSize size = MKMapSizeWorld;
            size.width /= 4.0;
            size.height /= 4.0;
            self.boundingMapRect = (MKMapRect) { origin, size };
            MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
            MKMapRect t=self.boundingMapRect;
            self.boundingMapRect = MKMapRectIntersection(t, worldRect);
            }
        }
    return self;
}


- (void)dealloc
{
    self.routePointsToDraw=nil;
    [super dealloc];
}

- (MKMapRect)boundingMapRect
{
    return boundingMapRect_;
}

- (CLLocationCoordinate2D)coordinate
{
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(self.boundingMapRect), MKMapRectGetMidY(self.boundingMapRect)));
}


@end


