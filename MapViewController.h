//
//  MapViewController.h
//  DriveTest
//
//  Created by Marvin Galang on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RouteTableViewController.h"
#import "SaveViewController.h"
#import "MultiCircleView.h"
#import "Route.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,RouteTableViewControllerDelegate,SaveViewControllerDelegate,RouteDelegate>





@end
