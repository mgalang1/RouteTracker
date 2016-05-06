//
//  RouteTableViewController.m
//  DriveTest
//
//  Created by Marvin Galang on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteTableViewController.h"
#import "RouteList.h"

@implementation RouteTableViewController

@synthesize myRouteListTable=myRouteListTable_;
@synthesize routeList=routeList_;
@synthesize delegate;


#pragma mark - Initializers/Destructors

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc {
    
    [super dealloc];
}

#pragma mark 

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
    self.myRouteListTable=nil;
    self.delegate=nil;
    self.routeList=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Target Action Methods

-(IBAction)toggleEdit:(id)sender  {
    
    [self.myRouteListTable setEditing:!self.myRouteListTable.editing animated:YES];
    
}

-(IBAction)cancel:(id)sender  {
    if ([delegate respondsToSelector:@selector(routeTableViewWillDismiss:)])
        [delegate routeTableViewWillDismiss:self];
}



#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routeList.routeCollection.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Set up the cell...
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[self.routeList.routeCollection objectAtIndex:row] valueForKeyPath:@"fileName"];
    
    cell.detailTextLabel.text=[[self.routeList.routeCollection objectAtIndex:row] valueForKeyPath:@"fileDesc"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([delegate respondsToSelector:@selector(routeTableViewSelectRoute:selectedPath:)])
        [delegate routeTableViewSelectRoute:self selectedPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([delegate respondsToSelector:@selector(routeTableViewDeleteRoute:deletedPath:)])
        [delegate routeTableViewDeleteRoute:self deletedPath:indexPath];
    
    [self.myRouteListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
