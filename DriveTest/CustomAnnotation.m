//
//  CustomAnnotation.m
//  RouteTracker
//
//  Created by Marvin Galang on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coord=_coord;
@synthesize note=_note;
@synthesize image=_image;


- (CLLocationCoordinate2D)coordinate;
{
    return _coord; 
}

- (NSString *)title
{
    return @"Add Note";
}

// optional
- (NSString *)subtitle
{
    return @"Founded: June 29, 1776";
}

@end
