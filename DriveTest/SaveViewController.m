//
//  SaveViewController.m
//  DriveTest
//
//  Created by Marvin Galang on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveViewController.h"

#define numberOfEditableRows          2
#define kfileNameTag                  0
#define kfileDescTag                  1
#define kLabelTag                     4096

@implementation SaveViewController

@synthesize fieldLabels=fieldLabels_;
@synthesize tmpFileName=tmpFileName_;
@synthesize tmpFileDesc=tmpFileDesc_;
@synthesize textFieldBeingEdited=textFieldBeingEdited_;
@synthesize savedTable=savedTable_;

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

- (void)dealloc 
{

    [super dealloc];
}

#pragma mark - Target Action Methods

- (void) hideKeyboard {
    [self.textFieldBeingEdited resignFirstResponder];
}

- (void)textFieldDone:(id)sender {
    //determine the tableview cell associated to the current text field
    UITableViewCell *cell =
	(UITableViewCell *)[[sender superview] superview];
    
    //determine the tag of the current text field
    UITextField *currentTextField = nil;
    for (UIView *oneView in cell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            currentTextField = (UITextField *)oneView;
    }
    
    NSUInteger tagID=currentTextField.tag;
    switch (tagID) {
        case kfileNameTag:
            self.tmpFileName=currentTextField.text;
            self.title=self.tmpFileName;
            break;
        case kfileDescTag:
            self.tmpFileDesc=currentTextField.text;
			break;
        default:
            break;
    }
    
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= numberOfEditableRows) {
        row = 0;
    }
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:0];
    UITableViewCell *nextCell = [self.savedTable
								 cellForRowAtIndexPath:newPath];
    
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}


- (IBAction) cancel:(id)sender {
    if ([delegate respondsToSelector:@selector(saveTableViewWillDismiss:)])
        [delegate saveTableViewWillDismiss:self];
}

- (IBAction) save:(id)sender {
    
    if (self.textFieldBeingEdited != nil) {
        NSUInteger tagID=self.textFieldBeingEdited.tag;
        switch (tagID) {
            case kfileNameTag:
                self.tmpFileName=self.textFieldBeingEdited.text;
                break;
            case kfileDescTag:
                self.tmpFileDesc=self.textFieldBeingEdited.text;
                break;
            default:
                break;
        }
    }
      
    
    if (self.tmpFileName.length==0) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Empty Filename" message:@"Enter a FileName." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]autorelease];
        [alert show];
        
        //Invalid FileName
        return;
    }
    
    if (self.tmpFileDesc.length==0) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Empty Description" message:@"Enter a Description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]autorelease];
        [alert show];
        
        //Invalid FileName
        return;
    }
    
    if ([delegate respondsToSelector:@selector(saveTableViewWillSave:fileName:fileDesc:)])
        [delegate saveTableViewWillSave:self fileName:self.tmpFileName fileDesc:self.tmpFileDesc];
    
    
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fieldLabels=[[[NSArray alloc] initWithObjects:@"Filename:", @"Description:", nil]autorelease];
    
    UITapGestureRecognizer *gestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]autorelease];
    [self.savedTable addGestureRecognizer:gestureRecognizer];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fieldLabels=nil;
    self.tmpFileName=nil;
    self.tmpFileDesc=nil;
    self.textFieldBeingEdited=nil;
    self.delegate=nil;
    self.savedTable=nil;
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


#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return numberOfEditableRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *wishListCellIdentifier = @"saveCellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             wishListCellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleValue1
				 reuseIdentifier:wishListCellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:
						  CGRectMake(10, 10, 92, 25)];
        label.textAlignment = UITextAlignmentLeft;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.backgroundColor= [UIColor clearColor];
        
        [cell.contentView addSubview:label];
        [label release];
		
        UITextField *textField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(100, 10, 200, 25)];
        
        textField.autocorrectionType=UITextAutocorrectionTypeNo;
        textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        [textField addTarget:self
                      action:@selector(textFieldDone:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
        [textField release];
    }
    
    NSUInteger row = [indexPath row];
	
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *textField = nil;
    
    for (UIView *oneView in cell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
    
    label.text = [self.fieldLabels objectAtIndex:row];
    textField.text=nil;
    self.tmpFileDesc=nil;
    self.tmpFileName=nil;
    self.title=@"Untitled";

    textField.tag = row;
    return cell;
}

#pragma mark - Text Field Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldBeingEdited = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSUInteger tagID=textField.tag;
    switch (tagID) {
        case kfileNameTag:
            self.tmpFileName=textField.text;
            self.title=self.tmpFileDesc;
            break;
        case kfileDescTag:
            self.tmpFileDesc=textField.text;
			break;
        default:
            break;
    }
}



@end
