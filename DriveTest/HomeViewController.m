//
//  HomeViewController.m
//  RouteTracker
//
//  Created by Marvin Galang on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "MapViewController.h"

@interface HomeViewController() 
@property (nonatomic, retain) IBOutlet UITableView *tableMenu;


@end


@implementation HomeViewController

@synthesize tableMenu=_tableMenu;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"test";
        self.tabBarItem.image=nil;
        self.tabBarItem.title=@"test";
        
        self.tableMenu=[[[UITableView alloc]init]autorelease];

    }
    return self;
}

- (void)dealloc 
{
    
    [super dealloc];
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableMenu.rowHeight=(self.tableMenu.bounds.size.height-20)/4;
    self.tableMenu.scrollEnabled=NO;
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


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"tableMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    // Set up the cell...
    
    int row = [indexPath row];
    
    UIFont *font=[UIFont fontWithName:@"ArialMT" size:12];
    cell.detailTextLabel.font=font;
    
    switch (row) {
        case 0: 
            cell.textLabel.text = @"Create Waypoints";
            cell.detailTextLabel.text=@"Manually create waypoints or tracks";
        case 1: 
            cell.textLabel.text = @"Record Paths";
            cell.detailTextLabel.text=@"Track your adventures by recording your locations";
        case 2: 
            cell.textLabel.text = @"Navigate";
            cell.detailTextLabel.text=@"Follow an existing tracks";
        case 3: 
            cell.textLabel.text = @"Display";
            cell.detailTextLabel.text=@"Replay the existing routes";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];
    
    if (row==1) {
            MapViewController *recView=[[[MapViewController alloc] init]autorelease];
            [self.navigationController pushViewController:recView animated:YES];
            self.navigationController.navigationBarHidden=NO;
    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    

}



@end
