//
//  SaveViewController.h
//  DriveTest
//
//  Created by Marvin Galang on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SaveViewController;
@protocol SaveViewControllerDelegate <NSObject>
@required
- (void)saveTableViewWillSave:(SaveViewController *)mySaveViewController
             fileName:(NSString *) fileName fileDesc:(NSString *) fileDesc;

- (void) saveTableViewWillDismiss:(SaveViewController *)mySaveViewController;
@end

@interface SaveViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSString *tmpFileName;
@property (nonatomic, retain) NSString *tmpFileDesc;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;

@property (nonatomic, retain) IBOutlet UITableView* savedTable;
@property (retain, nonatomic) id <SaveViewControllerDelegate> delegate;



- (IBAction) cancel:(id)sender;
- (IBAction) save:(id)sender;
    
    
@end
