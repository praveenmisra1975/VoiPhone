
#import "VoicemailController.h"
#import "SiphonApplication.h"

@interface UIAlertView (Extended)
- (UITextField*)addTextFieldWithValue:(NSString*)value label:(NSString*)label;
- (UITextField*)textFieldAtIndex:(NSUInteger)index;
- (NSUInteger)textFieldCount;
- (UITextField*)textField;
@end

static NSString *kVoicemailNum = @"voicemail";

@interface VoicemailController (private)
- (void) callVoicemail;
@end

@implementation VoicemailController

@synthesize phoneCallDelegate;

- (id)initWithStyle:(UITableViewStyle)style 
{
	if (self = [super initWithStyle:style]) 
  {
    self.title = NSLocalizedString(@"Voicemail", @"VoicemailView");
    self.tabBarItem.image = [UIImage imageNamed:@"message.png"];
    
  }
  
  return self;
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
        // Custom initialization
      // Initialization code
      self.title = NSLocalizedString(@"Voicemail", @"VoicemailView");
      self.tabBarItem.image = [UIImage imageNamed:@"message.png"];
      first = YES;
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    
//  [self performSelector:@selector(callVoicemail) withObject:nil afterDelay:0.01];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey: kVoicemailNum];
  if ([number length] > 0)
    return;
  
  UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Voicemail", @"VoicemailView") 
                                                   message:NSLocalizedString(@"Voicemail Number?", @"VoicemailView")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"VoiPhoneApp")
                                         otherButtonTitles:NSLocalizedString(@"Ok", @"VoiPhoneApp"), nil] autorelease];

  [alert addTextFieldWithValue:@"" label:nil];
  [alert textField].keyboardType = UIKeyboardTypePhonePad;
  //[alert textField].borderStyle = UITextBorderStyleRoundedRect;
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *number = [alertView textField].text;
  if ((buttonIndex == 0) || ([number length] == 0))
  {
    self.tabBarController.selectedIndex = 2; // FIXME: find the previous view and display it
  }
  else
    {
      NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
      [userDef setObject:number forKey:kVoicemailNum];
      [userDef synchronize];
      [self callVoicemail];
    }
  }


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;//1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 0;//1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Set up the cell...
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
  //if (section != 0) // Default Account
    return nil;
  //return [[data objectAtIndex:section] objectForKey:@"name"];
  //return NSLocalizedString(@"SIP Account Information", @"Settings");
  //return NSLocalizedString(@"Voicemail Number", @"Voicemail");
}

- (void) callVoicemail
{
  NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey: kVoicemailNum];
  if ([number length] > 0)
  {
    self.tabBarController.selectedIndex = 2; // FIXME: find the previous view and display it
    
    if ([phoneCallDelegate respondsToSelector:@selector(dialup:number:)])
      // TODO Using openURL will allow to define one voicemail number by account.
      [phoneCallDelegate dialup:number number:YES];
  }
}

@end
