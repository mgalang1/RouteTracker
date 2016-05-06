//
//  MultiCircleView.m
//  DriveTest
//
//  Created by Marvin Galang on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiCircleView.h"
#import "Route.h"
#import "RoutePoint.h"

@implementation MultiCircleView


- (id)initWithOverlay:(id <MKOverlay>)overlay{
    if (self = [super initWithOverlay:overlay]) {
        }
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale 
          inContext:(CGContextRef)context
{

    Route *multiCircle = (Route *) self.overlay;
    
    CGFloat radius = MKRoadWidthAtZoomScale(zoomScale);
    
    // outset the map rect by the line width so that points just outside
    // of the currently drawn rect are included in the generated path.
    MKMapRect clipRect = MKMapRectInset(mapRect, -radius, -radius);
    
    CGPathRef path = [self newPathForPoints:multiCircle
                                 pointCount:multiCircle.routePoints.count
                                   clipRect:clipRect
                                  zoomScale:zoomScale];
        
        if (path) {
            CGContextSetRGBStrokeColor(context, 1.0f, 0.0f, 0.0f,1.0f);
            CGContextSetRGBFillColor(context,1.0f, 0.0f, 0.0f, 1.0f);
            CGContextBeginPath(context);
            CGContextAddPath(context, path);
            CGContextDrawPath(context, kCGPathFillStroke);
            CGPathRelease(path);
        }
            
}

#define MIN_POINT_DELTA 5.0

- (CGPathRef)newPathForPoints:(Route *)routeBeingDrawn
                   pointCount:(NSUInteger)pointCount
                     clipRect:(MKMapRect)mapRect
                    zoomScale:(MKZoomScale)zoomScale
{
    // The fastest way to draw a path in an MKOverlayView is to simplify the
    // geometry for the screen by elide points that are too close together
    // and to omit any line segments that do not intersect the clipping rect.  
    // While it is possible to just add all the points and let CoreGraphics 
    // handle clipping and flatness, it is much faster to do it yourself:
    
    if (pointCount < 2)
      return NULL;
    
    NSArray *points=[[NSArray alloc] initWithArray:(NSArray *)[routeBeingDrawn routePoints]];
    
    CGMutablePathRef path = NULL;
    
    CGFloat radius = MKRoadWidthAtZoomScale(zoomScale);
    
    // Calculate the minimum distance between any two points by figuring out
    // how many map points correspond to MIN_POINT_DELTA of screen points
    // at the current zoomScale.
#define POW2(a) ((a) * (a))
    
    double minPointDelta = MIN_POINT_DELTA / zoomScale;
    double c2 = POW2(minPointDelta);
    
    MKMapPoint currentPoint, lastPoint = MKMapPointForCoordinate([[points objectAtIndex:0] coords]);
    
    int count=0;
    
    if (!path) {
        path = CGPathCreateMutable();
        for (int i=1; i<pointCount; i++) {
            currentPoint=MKMapPointForCoordinate([[points objectAtIndex:i] coords]);
            
            double a2b2 = POW2(currentPoint.x - lastPoint.x) + POW2(currentPoint.y - lastPoint.y);
            
            if (a2b2 >= c2) {
                CGPoint overlayPoint = [self pointForMapPoint:currentPoint];
                CGRect rect=CGRectMake(overlayPoint.x, overlayPoint.y, radius*1.75,radius*1.75);
                CGPathAddEllipseInRect(path,NULL,rect);
                
                lastPoint = currentPoint;
                count=count+1;
            }
        }
    }
    [points release];
    NSLog(@"No of Points Drawn is %i",count);
    return path;
}
                                                         

@end