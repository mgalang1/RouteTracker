//
//  RouteList.m
//  DriveTest
//
//  Created by Marvin Galang on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteList.h"
#import "RoutePoint.h"

@implementation RouteList

@synthesize routeCollection=routeCollection_;
@synthesize tempRoute=tempRoute_;
@synthesize replayRoute=replayRoute_;
@synthesize routeToPlay=routeToPlay_;
@synthesize recording=recording_;
@synthesize replaying=replaying_;
@synthesize countOfPointsDidReplayed=countOfPointsDidReplayed_;
@synthesize routeAnnotations=_routeAnnotations;


#pragma mark - Initializers/Destructors
- (id)init
{
    self = [super init];
    if (self) {
        self.recording=NO;
        self.replaying=NO;
        self.routeCollection=[[[NSMutableArray alloc] init]autorelease];
        self.routeAnnotations=[[[NSMutableArray alloc] init]autorelease];
        self.countOfPointsDidReplayed=0;
        
        }
    return self;
}

-(void) dealloc
{
    self.routeCollection=nil;
    self.tempRoute=nil;
    self.replayRoute=nil;
    self.routeToPlay=nil;
    [super dealloc];
}

#pragma mark - Archieving


- (id)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super init])) {
        self.routeCollection = [decoder decodeObjectForKey:@"routeCollection"];
        self.recording=NO;
        self.replaying=NO;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.routeCollection forKey:@"routeCollection"];
}


#pragma mark - Route Management Methods

-(void) addRoute:myFileName fileDesc:myFileDesc; {
    if (self.tempRoute.routePoints.count==0) return;
    
    self.tempRoute.fileName=myFileName;
    self.tempRoute.fileDesc=myFileDesc;
    [self.routeCollection addObject:self.tempRoute];
    [self saveRouteList:@"myRouteList.archieve"];
    self.tempRoute=nil;
}

-(void) removeRoute: (NSIndexPath *) indexPath {
    NSUInteger row = [indexPath row];
    [self.routeCollection removeObjectAtIndex:row];
    [self saveRouteList:@"myRouteList.archieve"];
}


- (void)saveRouteList: (NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSError *error = nil;
    if ([fileManager createDirectoryAtURL:documentsURL withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
        // Some more consideration should be given to error handling in this case
        NSLog(@"%s Unable to create documents directory: %@", __PRETTY_FUNCTION__, error);
        return;
    }
    
    NSURL *wishListURL = [documentsURL URLByAppendingPathComponent:fileName];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToURL:wishListURL atomically:YES];
}


+ (id)loadRouteList: (NSString*) fileName
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *routeListURL = [documentsURL URLByAppendingPathComponent:fileName];
    
    NSData *routeListData = [NSData dataWithContentsOfURL:routeListURL];
    
    RouteList *mySavedRouteList = nil;
    
    if (routeListData) {
        mySavedRouteList = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfURL:routeListURL]];
    }
    return mySavedRouteList;
}

-(void) createRouteFromCSVFile {
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
	NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    Route *routeFromCSV = [[[Route alloc] init]autorelease];
    routeFromCSV.fileName=@"testRoute2";
    routeFromCSV.fileDesc=@"testArea2";
	
	for(int i = 0; i < pointStrings.count; i++)
        {
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:i];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
		CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
		CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        
		// create our coordinate and add it to the correct spot in the array 
		CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
        
        [routeFromCSV addCoordinateFromCSV:coord];
        
        }
    [self.routeCollection addObject:routeFromCSV];
    [self saveRouteList:@"myRouteList.archieve"];
    
}


-(RoutePoint *)pointsToBeReplayed {
    self.countOfPointsDidReplayed=self.countOfPointsDidReplayed+1;
    
    if (self.countOfPointsDidReplayed==[self.replayRoute.routePoints count])
        return nil;
    else    
        return ([self.replayRoute.routePoints objectAtIndex:self.countOfPointsDidReplayed]);
}

@end
