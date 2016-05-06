//
//  Route.h
//  DriveTest
//
//  Created by Marvin Galang on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Route;
@protocol RouteDelegate <NSObject>
@optional

-(void) routeRegionWillChange:(Route *)routeSender centerCoord:(CLLocationCoordinate2D) center;
@end


@interface Route : NSObject <MKOverlay> 

@property (nonatomic, retain) NSMutableArray *routePoints;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *fileDesc;


@property (nonatomic, assign) MKMapRect boundingMapRect;
@property (nonatomic, assign) CLLocationDegrees minLat;
@property (nonatomic, assign) CLLocationDegrees maxLat;
@property (nonatomic, assign) CLLocationDegrees minLong;
@property (nonatomic, assign) CLLocationDegrees maxLong;
@property (nonatomic, assign) MKCoordinateRegion regionEntireRoute;
@property (nonatomic, assign) CLLocationCoordinate2D previousCoord;
@property (nonatomic, assign) CLLocationDistance distanceTravelled;

@property (retain, nonatomic) id <RouteDelegate> delegate;


-(MKMapRect) addCoordinate:(CLLocationCoordinate2D)currentCoord directions:(CLLocationDirection) directions radius:(CGFloat)radius map:(MKMapView*) map;
-(id)initWithFirstCoordinate:(CLLocationCoordinate2D) coord directions:(CLLocationDirection) directions;
-(void)calcBoundingMapAndRegionEntireRoute:(Route *) route;
-(void)addCoordinateFromCSV:(CLLocationCoordinate2D)coord;

+ (NSString *) headingDescription:(CLLocationDegrees) headingDirection;

@end
