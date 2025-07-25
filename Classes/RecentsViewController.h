
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <sqlite3.h>

#import "PhoneCallDelegate.h"
#import "RecentCall.h"

@interface RecentsViewController : UITableViewController <UIActionSheetDelegate,
  ABPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>
//<UIActionSheetDelegate,
//    UITableViewDelegate, UITableViewDataSource>
{
  id<PhoneCallDelegate> phoneCallDelegate;
  
  NSMutableArray *calls;
  // Opaque reference to the SQLite database.
  sqlite3 *database;
  
  @private
  RecentCall *unknownCall;
}

@property (nonatomic, retain)  id<PhoneCallDelegate> phoneCallDelegate;
// Makes the main array of recentCall objects available to other objects in the application.
@property (nonatomic, retain) NSMutableArray *calls;

// Creates a new recentCall object with default data. 
- (void)addCall:(RecentCall *)call;
// Removes a recentCall from the array of calls, and also deletes it from the 
// database. There is no undo.
- (void)removeCall:(RecentCall *)call;

@end
