//
//  ReplayViewController.m
//  RouteTracker
//
//  Created by Marvin Galang on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReplayViewController.h"

@implementation ReplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-(void) playRoute {
//    
//    RoutePoint *nextPoint=[self.routeList pointsToBeReplayed];
//    CLLocationDirection nextCourse=nextPoint.directions;
//    CLLocationCoordinate2D nextCoord=nextPoint.coords;
//    
//    if (nextPoint && self.routeList.isReplaying==YES) {
//        
//        // Compute the currently visible map zoom scale
//        MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
//        
//        // Find out the line width at this zoom scale use it as a radius
//        CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
//        
//        MKMapRect updateRect = [self.routeList.routeToPlay addCoordinate:nextCoord directions:nextCourse radius:lineWidth map:self.mapView];
//        
//        if (!MKMapRectIsNull(updateRect)) {
//            
//            // There is a non null update rect.
//            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
//            
//            // Ask the overlay view to update just the changed area.
//            [self.multiCircleView setNeedsDisplayInMapRect:updateRect];
//            
//            self.courseLabel.text= [NSString stringWithFormat:@"Heading: %@",[Route headingDescription:nextCourse]];
//            self.distanceLabel.text=[NSString stringWithFormat:@"Distance: %.2f miles",self.routeList.routeToPlay.distanceTravelled/1600];
//            
//            //update center coordinate for the region when route is being played
//            if (self.routeList.countOfPointsDidReplayed % 5 ==0) {
//                [self.mapView setCenterCoordinate:nextCoord animated:YES];
//            }
//            
//        }
//    }
//    else {
//        [self.timer invalidate];
//        self.timer=nil;
//        self.routeList.replaying=NO;
//        self.routeList.routeToPlay=nil;
//        startButton_.enabled=YES;
//        //        loadButton_.enabled=YES;
//        stopButton_.enabled=NO;
//        saveButton_.enabled=NO;
//        //        replayButton_.title=@"Replay";
//        
//        //initialize the count of routes being replayed counter
//        self.routeList.countOfPointsDidReplayed=0;
//        
//    }
//    
//}


//-(IBAction)loadRoute:(id)sender {
//    
//    if(self.routeList.tempRoute.routePoints.count>5) {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"You have an unsaved Route." message:@"Do you want to continue?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil]autorelease];
//        alert.tag=kLoadTag;
//        [alert show];
//        return;
//    }
//    //present the list of saved Routes
//    self.myRouteTableController = [[[RouteTableViewController alloc] init]autorelease];
//    [self.myRouteTableController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    self.myRouteTableController.delegate=self;
//    self.myRouteTableController.routeList=self.routeList;
//    [self presentModalViewController:self.myRouteTableController
//                            animated:YES];
//    
//}    


//-(IBAction)replayRoute:(id)sender {
//    if (self.routeList.isReplaying==YES) {
//        self.routeList.replaying=NO;
//        startButton_.enabled=YES;
//        //        loadButton_.enabled=YES;
//        stopButton_.enabled=NO;
//        saveButton_.enabled=NO;
//        //        replayButton_.title=@"Replay";
//        [self.timer invalidate];
//        self.timer=nil;
//    }
//    else {
//        startButton_.enabled=NO;
//        //        loadButton_.enabled=NO;
//        stopButton_.enabled=NO;
//        saveButton_.enabled=NO;
//        self.routeList.replaying=YES;
//        //        replayButton_.title=@"Stop";
//        
//        if (!self.routeList.routeToPlay) {
//            //first Point
//            //initialize temp storage of route to be replayed
//            
//            
//            self.routeList.routeToPlay= [[[Route alloc] initWithFirstCoordinate:[[self.routeList.replayRoute.routePoints objectAtIndex:0] coords] directions:[[self.routeList.replayRoute.routePoints objectAtIndex:0] directions]]autorelease];
//            
//            self.routeList.routeToPlay.delegate=self;
//            
//            //remove and add new overlay
//            [self.mapView removeOverlay:self.prevOverlay];
//            self.multiCircleView=nil;
//            
//            [self.mapView addOverlay:self.routeList.routeToPlay];
//            self.prevOverlay=self.routeList.routeToPlay;
//            
//            MKCoordinateRegion initRegion= MKCoordinateRegionMakeWithDistance(self.routeList.routeToPlay.previousCoord, 2000, 2000);
//            [self.mapView setRegion:initRegion animated:YES];
//            
//            //fire up the timer for the succeeding points
//            self.timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playRoute) userInfo:nil repeats:YES];
//        }
//        
//        else {
//            //fire up the timer for the succeeding points
//            self.timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playRoute) userInfo:nil repeats:YES];
//            
//        }
//        
//        
//    }
//    
//}


@end
