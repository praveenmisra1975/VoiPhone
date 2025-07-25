
#import "ContactViewController.h"

@interface ABPeoplePickerNavigationController ()

//- (void)setAllowsCardEditing:(BOOL)allowCardEditing;
//- (void)setAllowsCancel:(BOOL)allowsCancel;

@end


@implementation ContactViewController

@synthesize phoneCallDelegate;

- (id)init 
{
  self = [super init];
	if (self) 
  {
		// Initialization code
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem: 
                       UITabBarSystemItemContacts tag:3];
    self.peoplePickerDelegate = self;
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;

   // [self setAllowsCardEditing:YES];
   // [self setAllowsCancel:NO];
	}
	return self;
}

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
	[super dealloc];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel: 
    (ABPeoplePickerNavigationController *)peoplePicker 
{

}

- (BOOL)peoplePickerNavigationController:
  (ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
  return YES;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
  CFTypeRef multiValue;
  CFIndex valueIdx;
  
  // FIXME duplicate code from FavoritesListController.personViewController
  if (kABPersonPhoneProperty == property)
  {
    multiValue = ABRecordCopyValue(person, property);
    valueIdx = ABMultiValueGetIndexForIdentifier(multiValue,identifier);
    NSString *phoneNumber = (NSString *)
            ABMultiValueCopyValueAtIndex(multiValue, valueIdx);
    
    if (phoneNumber && 
        [phoneCallDelegate respondsToSelector:@selector(dialup:number:)])
    {
      [phoneCallDelegate dialup: phoneNumber number:YES];
    }
    
    return NO;
  }

  return YES;
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
  [super setEditing:flag animated:animated];
  if (flag == YES){
    // change view to an editable view
  }
  else {
    // save the changes if needed and change view to noneditable
  }
}

@end
