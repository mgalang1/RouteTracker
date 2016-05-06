//
//  MultiCircleView.h
//  DriveTest
//
//  Created by Marvin Galang on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <MapKit/MapKit.h>

@class Route;
@interface MultiCircleView : MKOverlayView

- (CGPathRef)newPathForPoints:(Route *)points
                   pointCount:(NSUInteger)pointCount
                     clipRect:(MKMapRect)mapRect
                    zoomScale:(MKZoomScale)zoomScale;

@end
