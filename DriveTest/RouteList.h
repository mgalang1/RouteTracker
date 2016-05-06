//
//  RouteList.h
//  DriveTest
//
//  Created by Marvin Galang on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

@class RoutePoint;
@interface RouteList : NSObject

@property (nonatomic, retain) NSMutableArray *routeCollection;
@property (nonatomic,retain) Route *tempRoute;
@property (nonatomic,retain) Route *replayRoute;
@property (nonatomic,retain) Route *routeToPlay;
@property (nonatomic, assign, getter=isRecording) BOOL recording;
@property (nonatomic, assign, getter=isReplaying) BOOL replaying;

@property (nonatomic, retain) NSMutableArray *routeAnnotations;

@property (nonatomic, assign) NSUInteger countOfPointsDidReplayed;

-(void) addRoute:myFileName fileDesc:myFileDesc;
-(void) removeRoute: (NSIndexPath *) indexPath;
-(void) saveRouteList: (NSString *) fileName;
-(void) createRouteFromCSVFile;
+(id) loadRouteList: (NSString*) fileName;
-(RoutePoint *)pointsToBeReplayed;

@end
