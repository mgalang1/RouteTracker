//
//  Route.m
//  DriveTest
//
//  Created by Marvin Galang on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Route.h"
#import "RoutePoint.h"

@implementation Route

@synthesize routePoints=routePoints_;
@synthesize fileName=fileName_;
@synthesize fileDesc=fileDesc_;

@synthesize boundingMapRect=boundingMapRect_;
@synthesize minLat=minLat_;
@synthesize minLong=minLong_;
@synthesize maxLat=maxLat_;
@synthesize maxLong=maxLong_;
@synthesize regionEntireRoute=regionEntireRoute_;
@synthesize previousCoord=previousCoord_;
@synthesize distanceTravelled=distanceTravelled_;
@synthesize delegate;


#pragma mark - Initializers/Destructors

- (id)initWithFirstCoordinate:(CLLocationCoordinate2D) coord directions:(CLLocationDirection) directions
{
    self = [super init];
    if (self) {

        self.routePoints=[[[NSMutableArray alloc] init]autorelease];
        self.distanceTravelled=0;
        
        self.minLat=1000;
        self.maxLat=-1000;
        self.minLong=1000;
        self.maxLong=-1000;
        
        RoutePoint *firstObj=[[[RoutePoint alloc] initWithCenterCoordinate:coord directions:directions]autorelease];
        [self.routePoints addObject:firstObj];
         
        // bite off up to 1/4 of the world to draw into.
        MKMapPoint origin = MKMapPointForCoordinate(coord);
        origin.x -= MKMapSizeWorld.width / 8.0;
        origin.y -= MKMapSizeWorld.height / 8.0;
        MKMapSize size = MKMapSizeWorld;
        size.width /= 4.0;
        size.height /= 4.0;
        boundingMapRect_ = (MKMapRect) { origin, size };
        MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
        boundingMapRect_ = MKMapRectIntersection(boundingMapRect_, worldRect);
    
        self.previousCoord=coord;
        
    }
    
    return self;
}

-(void) dealloc {
    self.routePoints=nil;
    self.fileDesc=nil;
    self.fileName=nil;
    self.delegate=nil;
    [super dealloc];
}


#pragma mark - Archieving

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super init])) {
        self.routePoints = [decoder decodeObjectForKey:@"routePoints"];
        self.fileName = [decoder decodeObjectForKey:@"fileName"];
        self.fileDesc = [decoder decodeObjectForKey:@"fileDesc"];
        [decoder decodeValueOfObjCType:@encode(CLLocationDirection) at:&distanceTravelled_];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.routePoints forKey:@"routePoints"];
    [coder encodeObject:self.fileName forKey:@"fileName"];
    [coder encodeObject:self.fileDesc forKey:@"fileDesc"];
    [coder encodeValueOfObjCType:@encode(CLLocationDistance) at:&distanceTravelled_];
}

#pragma mark 
-(MKMapRect) addCoordinate:(CLLocationCoordinate2D)currentCoord directions:(CLLocationDirection) directions radius:(CGFloat)radius map:(MKMapView*) map
{

    RoutePoint *routeObj = [[[RoutePoint alloc] initWithCenterCoordinate:currentCoord directions:directions]autorelease];
    
    CLLocation *newLocation = [[[CLLocation alloc] initWithLatitude:currentCoord.latitude longitude:currentCoord.longitude]autorelease];
    
    CLLocation *oldLocation = [[[CLLocation alloc] initWithLatitude:self.previousCoord.latitude longitude:self.previousCoord.longitude]autorelease];
    
    
    self.distanceTravelled=(self.distanceTravelled+[newLocation distanceFromLocation:oldLocation]);
    
    
    
    MKMapPoint newPoint = MKMapPointForCoordinate(currentCoord);
    
    //[self updateRegion:map coord:coord];
    
    //determine min, max lat and long based on current and previous cooedinates
    self.minLat=MIN(currentCoord.latitude, self.minLat);
    self.maxLat=MAX(currentCoord.latitude, self.maxLat);
    self.minLong=MIN(currentCoord.longitude, self.minLong);
    self.maxLong=MAX(currentCoord.longitude, self.maxLong);
    
    //add routePoints
    [self.routePoints addObject:routeObj];
    
    // Compute MKMapRect bounding for the current Point
    double minX = newPoint.x-radius;
    double minY = newPoint.y-radius;
    double maxX = newPoint.x+radius;
    double maxY = newPoint.y+radius;
    
    self.previousCoord=currentCoord;
    
    //Create a rect that will be redrawn for drawRectMap
    MKMapRect updateRect = MKMapRectNull;
    updateRect = MKMapRectMake(minX, minY, maxX - minX, maxY - minY);
    return updateRect;
}

-(void)addCoordinateFromCSV:(CLLocationCoordinate2D)coord {
    RoutePoint *routeObj = [[[RoutePoint alloc] initWithCenterCoordinate:coord directions:0.0]autorelease];
    
    //add routePoints
    [self.routePoints addObject:routeObj];

}

- (void) calcBoundingMapAndRegionEntireRoute:(Route *) route
{
    self.minLat=1000;
    self.maxLat=-1000;
    self.minLong=1000;
    self.maxLong=-1000;
    
    for (RoutePoint *point in route.routePoints) 
        {
        CLLocationCoordinate2D coord=[point coords];
    
        //determine min, max lat and long based on current and previous cooedinates
        self.minLat=MIN(coord.latitude, self.minLat);
        self.maxLat=MAX(coord.latitude, self.maxLat);
        self.minLong=MIN(coord.longitude, self.minLong);
        self.maxLong=MAX(coord.longitude, self.maxLong);
        }
    
    CLLocationCoordinate2D centerCoord=CLLocationCoordinate2DMake((self.minLat+self.maxLat)/2,(self.minLong+self.maxLong)/2);
    
    MKMapPoint origin = MKMapPointForCoordinate(centerCoord);
    origin.x -= MKMapSizeWorld.width / 8.0;
    origin.y -= MKMapSizeWorld.height / 8.0;
    MKMapSize size = MKMapSizeWorld;
    size.width /= 4.0;
    size.height /= 4.0;
    self.boundingMapRect = (MKMapRect) { origin, size };
    MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
    self.boundingMapRect = MKMapRectIntersection(boundingMapRect_, worldRect);
}

- (CLLocationCoordinate2D)coordinate
{
    return [[self.routePoints objectAtIndex:0] coords];
}

- (MKMapRect)boundingMapRect
{
    return boundingMapRect_;
}

- (MKCoordinateRegion) regionEntireRoute
{
    CLLocationCoordinate2D centerCoord=CLLocationCoordinate2DMake((self.minLat+self.maxLat)/2,(self.minLong+self.maxLong)/2);
    MKCoordinateSpan span= MKCoordinateSpanMake(self.maxLat-self.minLat,self.maxLong-self.minLong);
    return (MKCoordinateRegionMake(centerCoord,span));    
}

+ (NSString *) headingDescription:(CLLocationDegrees) headingDirection {
    
    NSString *stringDirection;
    
    if (headingDirection>22.5 && headingDirection<=67.5)
        stringDirection=@"NE";
    else if (headingDirection>67.5 && headingDirection<=112.5)
        stringDirection=@"E";
    else if (headingDirection>112.5 && headingDirection<=157.5)
        stringDirection=@"SE";
    else if (headingDirection>157.5 && headingDirection<=202.5)
        stringDirection=@"S";
    else if (headingDirection>202.5 && headingDirection<=247.5)
        stringDirection=@"SW";
    else if (headingDirection>247.5 && headingDirection<=292.5)
        stringDirection=@"W";
    else if (headingDirection>292.5 && headingDirection<=337.5)
        stringDirection=@"NW";
    else if (headingDirection<0) 
        stringDirection=nil;
    else stringDirection=@"N";
    
    return stringDirection;
}

@end
