//
//  MapViewController.m
//  DriveTest
//
//  Created by Marvin Galang on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "RouteList.h"
#import "RoutePoint.h"
#import "CustomAnnotation.h"

#define kStartTag 1
#define kLoadTag 2

@interface MapViewController ()

@property (nonatomic, retain) UILongPressGestureRecognizer *longPress;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *pauseButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *startButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *stopButton;
@property (nonatomic, assign) IBOutlet UILabel *courseLabel;
@property (nonatomic, assign) IBOutlet UILabel *distanceLabel;

@property (nonatomic, retain) RouteList *routeList;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, assign) CLLocationDirection currentCourse;

@property (nonatomic, retain) RouteTableViewController *myRouteTableController;
@property (nonatomic, retain) SaveViewController *mySaveViewController;
@property (nonatomic, retain) MultiCircleView *multiCircleView;

@property (nonatomic, retain) Route *prevOverlay;
//@property (nonatomic, retain) NSTimer *timer;

-(IBAction) saveRoute:(id)sender;
-(IBAction) startRecording:(id)sender;
-(IBAction) stopRecording:(id)sender;

-(void) initRoutePath;
-(void)enableGesture;
-(void)disableGesture;
-(void)addAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation MapViewController

@synthesize mapView = mapView_;
@synthesize saveButton=saveButton_;
@synthesize pauseButton=pauseButton_;
@synthesize startButton=startButton_;
@synthesize stopButton=stopButton_;
@synthesize courseLabel=courseLabel_;
@synthesize distanceLabel=distanceLabel_;

@synthesize routeList=routeList_;
@synthesize locationManager=locationManager_;
@synthesize currentLocation=currentLocation_;
@synthesize currentCourse=currentCourse_;

@synthesize myRouteTableController=myRouteTableController_;
@synthesize mySaveViewController=mySaveViewController_;
@synthesize multiCircleView=multiCircleView_;
@synthesize prevOverlay=prevOverlay_;
//@synthesize timer=timer_;

@synthesize longPress=_longPress;


#pragma mark - Initializers/Destructors

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set buttons enable property
    stopButton_.enabled=NO;    
    saveButton_.enabled=NO;
    pauseButton_.enabled=NO;
    
    //configure navigation bar
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)] autorelease];

    
    //load the saved Route List. If there is no one saved, create a new one
    self.routeList=[RouteList loadRouteList:@"myRouteList.archieve"];
    if (!self.routeList) 
        self.routeList=[[[RouteList alloc]init]autorelease];
    
    
    /* add route from CSV file. 
    [self.routeList createRouteFromCSVFile]; */

    self.locationManager = [[[CLLocationManager alloc] init]autorelease];
    [self.locationManager setDelegate:self];
    
    self.locationManager.purpose=@"Location is required in order to record a route.";
    
    
    //limit the location manager accuracy when not recording
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setDistanceFilter:20]; 
    
    self.mapView.showsUserLocation=YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    
    [self.locationManager startUpdatingLocation];
    self.currentLocation=self.locationManager.location.coordinate;  
    self.longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addAnnotation:)]autorelease];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.locationManager stopUpdatingLocation];

    // Release any retained subviews of the main view.
    self.mapView = nil; 
    self.routeList=nil;
    self.locationManager=nil;
    self.myRouteTableController=nil;
    self.mySaveViewController=nil;
    self.multiCircleView=nil;
    self.prevOverlay=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


           
                      
#pragma mark - Target Acton Methods

-(void) backToHome {

    self.locationManager.delegate=nil;
    //self.mapView.showsUserLocation=NO;
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    self.longPress =nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) startRecording:(id)sender {
    
    if ([CLLocationManager locationServicesEnabled]==NO) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Location Service Disabled" message:@"Go To Settings Menu To Enable" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]autorelease];
        [alert show];
        return;
    }
    
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorized)
        {
            NSString *title, *message;
        
            if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
                title=@"Location Services OFF for this app";
                message=@"Go To Settings Menu To Turn On";
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil]autorelease];
                [alert show];
            }
            else {
                title=@"Location Service Restricted or Denied";
                message=@"Go To Settings To Authorize";
                
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]autorelease];
                [alert show];
            }
        
            return;
        }

    
    if(self.routeList.tempRoute.routePoints.count>5) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"You have an unsaved Route." message:@"Do you want to continue?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil]autorelease];
        alert.tag=kStartTag;
        [alert show];
        return;
        }
    
    //remove previous overlay
    [self.mapView removeOverlay:self.prevOverlay];
    self.multiCircleView=nil;
    
    //set accuracy to best when recording
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [self.locationManager setDistanceFilter:5];
    
    [self initRoutePath];
    self.routeList.recording=YES;
    startButton_.enabled=NO;
    saveButton_.enabled=NO;
    pauseButton_.enabled=YES;
    stopButton_.enabled=YES;
    
    self.mapView.showsUserLocation=YES;
    
    //enable gesture recognizer
    [self enableGesture];
    
}

-(IBAction)stopRecording:(id)sender {
    self.routeList.recording=NO;
    startButton_.enabled=YES;
    saveButton_.enabled=YES;
    pauseButton_.enabled=NO;
    stopButton_.enabled=NO;
    
    //limit the location manager accuracy when not recording
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setDistanceFilter:20];
    
    //disable gesture recognizer
    [self disableGesture];
}

-(IBAction)saveRoute:(id)sender {
    
    if(self.routeList.tempRoute.routePoints.count>5) {
        self.mySaveViewController = [[[SaveViewController alloc] init]autorelease];
        [self.mySaveViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        self.mySaveViewController.delegate=self;
        [self presentModalViewController:self.mySaveViewController
                            animated:YES];
    }
    else {
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Route Not Saved" message:@"Not enough data points" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]autorelease];
        [alert show];
    }

}



#pragma mark - Route Related Methods

-(void) initRoutePath {
    self.routeList.tempRoute = [[[Route alloc] initWithFirstCoordinate:self.currentLocation directions:self.currentCourse]autorelease];
    self.routeList.tempRoute.delegate=self;
    
    //remove and add new overlay
    self.multiCircleView=nil;
    [self.mapView removeOverlay:self.prevOverlay];
    [self.mapView addOverlay:self.routeList.tempRoute];
    self.prevOverlay=self.routeList.tempRoute;
    
    MKCoordinateRegion initRegion= MKCoordinateRegionMakeWithDistance(self.routeList.tempRoute.previousCoord, 2000, 2000);
    
    [self.mapView setRegion:initRegion animated:YES];
}



#pragma mark - CLLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    
    self.currentLocation=newLocation.coordinate;
    self.currentCourse=newLocation.course;
    
    if (self.routeList.isRecording==YES)
        {
        
        // Compute the currently visible map zoom scale
        MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
        
        // Find out the line width at this zoom scale use it as a radius
        CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
        
        MKMapRect updateRect = [self.routeList.tempRoute addCoordinate:self.currentLocation directions:self.currentCourse radius:lineWidth map:self.mapView];
        
        if (!MKMapRectIsNull(updateRect)) {
            
            // There is a non null update rect.
            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
            
            // Ask the overlay view to update just the changed area.
            [self.multiCircleView setNeedsDisplayInMapRect:updateRect];
            
        }
        
        self.courseLabel.text= [NSString stringWithFormat:@"Heading: %@",[Route headingDescription:newLocation.course]];
        self.distanceLabel.text=[NSString stringWithFormat:@"Distance: %.2f miles",self.routeList.tempRoute.distanceTravelled/1600];
        }
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status==kCLAuthorizationStatusAuthorized) {
        [self.locationManager startUpdatingLocation];
        self.mapView.showsUserLocation=YES;
    }
    
    else {
        self.mapView.showsUserLocation=NO;
        [self.locationManager stopUpdatingLocation];
    }
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error);
    
    if ([error code]==1) {
        self.mapView.showsUserLocation=NO;
        //[self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        [self.locationManager stopUpdatingLocation];
    }
    
}


#pragma mark - MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if(!self.multiCircleView)
        {
        self.multiCircleView= [[[MultiCircleView alloc]initWithOverlay:overlay]autorelease];
        } 
    
    return self.multiCircleView; 
}

    
    
#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (actionSheet.tag==kStartTag) {
        if (buttonIndex == 0)
        {
            //remove previous overlay
            [self.mapView removeOverlay:self.prevOverlay];
            self.multiCircleView=nil;
        
            [self initRoutePath];
            self.routeList.recording=YES;
            startButton_.enabled=NO;
            saveButton_.enabled=NO;
            pauseButton_.enabled=YES;
            stopButton_.enabled=YES;
            self.mapView.showsUserLocation=YES;
        }
        return;
    }
    
}


#pragma mark - Route TableView Delegate Methods

- (void) routeTableViewWillDismiss:(RouteTableViewController *)myRouteTableViewController
    {
        [self dismissViewControllerAnimated:YES completion: nil];
    }


- (void)routeTableViewSelectRoute:(RouteTableViewController *)myRouteTableViewController
                     selectedPath:(NSIndexPath *) path {
        
    [self dismissViewControllerAnimated:YES completion: nil];
    
//    replayButton_.enabled=YES; 
    saveButton_.enabled=NO;
    
    NSUInteger row=[path row];
    
    //set replay route to the selected route
    self.routeList.replayRoute=[self.routeList.routeCollection objectAtIndex:row];
    
    //update bounding map rect and region using the routePoints    
    [self.routeList.replayRoute calcBoundingMapAndRegionEntireRoute:self.routeList.replayRoute];
    MKCoordinateRegion region = [self.routeList.replayRoute regionEntireRoute];
    
    //set the new region
    [self.mapView setRegion:region animated:YES];
    
    //remove previous overlay
    [self.mapView removeOverlay:self.prevOverlay];
    self.multiCircleView=nil;
    
    //add new overlay
    [self.mapView addOverlay:self.routeList.replayRoute];
    self.prevOverlay=self.routeList.replayRoute;
        
    //set recording flag to NO and set tempRoute used for recording to nil 
    self.routeList.recording=NO;
    self.routeList.tempRoute=nil;
    
    //initialize the count of routes being replayed counter
    self.routeList.countOfPointsDidReplayed=0;
    self.routeList.routeToPlay=nil;
    
    //set the value of the labels
    self.courseLabel.text= nil;
    self.distanceLabel.text=[NSString stringWithFormat:@"Distance: %.2f miles",self.routeList.replayRoute.distanceTravelled/1600];
    
    //dont show user location when there is a loaded data.
    self.mapView.showsUserLocation=NO;
    //[self.mapView setUserTrackingMode:MKUserTrackingModeNone];
}


- (void)routeTableViewDeleteRoute:(RouteTableViewController *)myRouteTableViewController
                      deletedPath:(NSIndexPath *) path {
    [self.routeList removeRoute:path];
    
}

#pragma mark - Save Table View Delegate Methods

- (void)saveTableViewWillSave:(SaveViewController *)mySaveViewController
             fileName:(NSString *) fileName fileDesc:(NSString *) fileDesc {
    
    [self dismissViewControllerAnimated:YES completion: nil];
    [self.routeList addRoute:fileName fileDesc:fileDesc];
    if (self.routeList.tempRoute.routePoints.count==0) saveButton_.enabled=NO;
    
}

- (void) saveTableViewWillDismiss:(SaveViewController *)mySaveViewController {
    [self dismissViewControllerAnimated:YES completion: nil];
    saveButton_.enabled=YES;
}


#pragma mark - Route Delegate Methods
-(void) routeRegionWillChange:(Route *)routeSender centerCoord:(CLLocationCoordinate2D) center

{
    [self.mapView setCenterCoordinate:center animated:YES];

}
     

#pragma mark - GestureRecognizer method

-(void)enableGesture {
    [self.mapView addGestureRecognizer:self.longPress];
    self.mapView.userInteractionEnabled=YES;
}

-(void)disableGesture {
    [self.mapView removeGestureRecognizer:self.longPress];
    self.mapView.userInteractionEnabled=NO;
}


- (void)addAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //CGPoint location = [gestureRecognizer locationInView:self.view];
    
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
        CustomAnnotation *annot = [[[CustomAnnotation alloc] init]autorelease];
        annot.coord=self.currentLocation;
        [self.mapView addAnnotation:annot];
        [self.mapView selectAnnotation:annot animated:YES];
        
        
        //[self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        
    }
    
//    switch (gestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:
//            NSLog(@"handleLongPress: StateBegan");
//            break;
//        case UIGestureRecognizerStateChanged:
//            NSLog(@"handleLongPress: StateChanged");
//            //if(location.y > 75.0 && location.x > 25 && location.x < 300)
//            //button.frame = CGRectMake(location.x-25, location.y-15, 50, 30);           
//            break;
//        case UIGestureRecognizerStateEnded:
//            NSLog(@"handleLongPress: StateEnded");
//            break;
//        default:
//            break;
//    }   
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* annotationIdentifier = @"RouteAnnotation";
    
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView)
        {
        // if an existing pin view was not available, create one
        MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                               initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        // add a detail disclosure button to the callout which will open a new view controller page
        //
        // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
        //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
        //
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(showDetails:)
              forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        return customPinView;
        
        }
    
    return pinView;
}

@end
