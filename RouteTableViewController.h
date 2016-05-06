//
//  RouteTableViewController.h
//  DriveTest
//
//  Created by Marvin Galang on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RouteTableViewController;
@protocol RouteTableViewControllerDelegate <NSObject>
@required
- (void) routeTableViewWillDismiss:(RouteTableViewController *)myRouteTableViewController;

- (void)routeTableViewSelectRoute:(RouteTableViewController *)myRouteTableViewController
          selectedPath:(NSIndexPath *) path;

- (void)routeTableViewDeleteRoute:(RouteTableViewController *)myRouteTableViewController
deletedPath:(NSIndexPath *) path;

@end


@class RouteList;
@interface RouteTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView* myRouteListTable;
@property (retain, nonatomic) id <RouteTableViewControllerDelegate> delegate;
@property (nonatomic, retain) RouteList *routeList;


-(IBAction)toggleEdit:(id)sender;
-(IBAction)cancel:(id)sender;


@end
