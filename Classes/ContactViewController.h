
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "PhoneCallDelegate.h"

@interface ContactViewController : ABPeoplePickerNavigationController
    <ABPeoplePickerNavigationControllerDelegate,
//ABNewPersonViewControllerDelegate,
    UIActionSheetDelegate>
{
   id<PhoneCallDelegate> phoneCallDelegate;
}

@property (nonatomic, retain)  id<PhoneCallDelegate> phoneCallDelegate;

@end
