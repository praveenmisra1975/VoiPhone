
#import <UIKit/UIKit.h>
#import "PhoneCallDelegate.h"

@interface VoicemailController : UITableViewController <UIAlertViewDelegate> 
{
  id<PhoneCallDelegate> phoneCallDelegate;
}

@property (nonatomic, retain)   id<PhoneCallDelegate> phoneCallDelegate;

@end
