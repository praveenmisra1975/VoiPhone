
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <sqlite3.h>

//ABRecordRef ABCFindPersonMatchingPhoneNumber(ABAddressBookRef addressBook,NSString *phoneNumber,int, int);
//ABRecordRef ABAddressBookFindPersonMatchingPhoneNumber(ABAddressBookRef addressBook,
//                                                       NSString *phoneNumber,???);
//ABRecordRef ABAddressBookFindPersonMatchingURL(ABAddressBookRef addressBook,
//                                               NSString *url,???);

typedef enum 
{
  Undefined,
  Dialled,
  Received,
  Missed
} CallType;

@interface RecentCall : NSObject
{
  // Opaque reference to the underlying database.
  sqlite3 *database;
  // Primary key in the database.
  NSInteger primaryKey;

  // Dirty tracks whether there are in-memory changes to data which have no been written to the database.
  BOOL dirty;

  CallType  type;
  NSString *number;
  NSDate   *date;
  NSString *compositeName;
  
  ABRecordID             uid;
  ABMultiValueIdentifier identifier;
}
#if 0
- (id)initWithCallNumber:(NSString *)phoneNumber;
#endif
// Finalize (delete) all of the SQLite compiled queries.
+ (void)finalizeStatements;
// Creates the object with primary key and title is brought into memory.
- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
// Inserts the book into the database and stores its primary key.
- (void)insertIntoDatabase:(sqlite3 *)db;

// Remove the recent call complete from the database. In memory deletion to 
//follow...
- (void)deleteFromDatabase;


@property (assign)  CallType   type;
@property (nonatomic, retain)  NSString  *number;
@property (nonatomic, retain/*, readonly*/)  NSDate    *date; // TODO en lecture uniquement
@property (nonatomic, retain)  NSString  *compositeName;
@property (assign)  ABRecordID uid;
@property (assign)  ABMultiValueIdentifier identifier;

- (NSString *)displayName;

@end
