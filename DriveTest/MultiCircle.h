//
//  MultiPolygon.h
//  DriveTest
//
//  Created by Marvin Galang on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MultiCircle : NSObject <MKOverlay> 

@property (nonatomic, retain) NSArray *routePointsToDraw;
@property (nonatomic, assign) MKMapRect boundingMapRect;

-(id)initWithPoints:(NSArray *)points;


@end
