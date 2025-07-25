
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

#import "PhoneCallDelegate.h"
#import "DialerPhonePad.h"
#import "AbsLCDView.h"

#define SPECIFIC_ADD_PERSON 1

@interface PhoneViewController : UIViewController <
          UITextFieldDelegate,
#if SPECIFIC_ADD_PERSON
          UIActionSheetDelegate,
          ABNewPersonViewControllerDelegate,
          ABPeoplePickerNavigationControllerDelegate,
#else         
          ABUnknownPersonViewControllerDelegate,
#endif
           PhonePadDelegate>
{
  UITextField *_label;
  UIView      *_container;
  AbsLCDView *_lcd;

  DialerPhonePad *_pad;
  
  UIButton *_addContactButton;
  UIButton *_gsmCallButton;
  UIButton *_callButton;
  UIButton *_deleteButton;
  
  int      _deletedChar;
  NSTimer *_deleteTimer;
  
  NSString *_lastNumber;
  
  id<PhoneCallDelegate> phoneCallDelegate;
#if SPECIFIC_ADD_PERSON
  ABPeoplePickerNavigationController *peoplePickerCtrl;
#endif
}

@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;

@end
