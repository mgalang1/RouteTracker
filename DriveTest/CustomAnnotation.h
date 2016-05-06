//
//  CustomAnnotation.h
//  RouteTracker
//
//  Created by Marvin Galang on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CLLocationCoordinate2D coord;
@property (nonatomic, retain) NSString *note;

@end
