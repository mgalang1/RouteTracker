//
//  RoutePoint.h
//  DriveTest
//
//  Created by Marvin Galang on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RoutePoint : NSObject {
    
}

@property (nonatomic, assign) CLLocationCoordinate2D coords;
@property (nonatomic, assign) CLLocationDirection directions;

- (id) initWithCenterCoordinate:(CLLocationCoordinate2D)coord directions:(CLLocationDirection) directions;

@end

