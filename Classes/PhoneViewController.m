
#import "PhoneViewController.h"
#import "SiphonApplication.h"

#include <pjsua-lib/pjsua.h>

@interface PhoneViewController (private)

@end

@implementation PhoneViewController
NSString *forbiddenChars;

CGFloat width;
CGFloat height;



@synthesize phoneCallDelegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    
    
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) 
  {
      
      CGRect myRect = [[UIScreen mainScreen] bounds];
      width=  myRect.size.width ;
      height= myRect.size.height ;
      
		// Initialization code
    self.title = NSLocalizedString(@"Numpad", @"PhoneView");
    self.tabBarItem.image = [UIImage imageNamed:@"Dial.png"];
    forbiddenChars = [NSString stringWithString:@",;/?:&=+$"];
    
      
    _lcd = [[AbsLCDView alloc] initWithFrame:
            CGRectMake(0.0f, 0.0f, width, height*.15)];
      UIGraphicsBeginImageContext(_lcd.frame.size);
      [[UIImage imageNamed:@"lcd_top_simple.png"] drawInRect:_lcd.bounds];
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      _lcd.backgroundColor = [UIColor colorWithPatternImage:image];

      
    [_lcd leftText: [[NSUserDefaults standardUserDefaults] stringForKey:
                     @"server"]];
    [_lcd rightText:@"Service Unavailable"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processRegState:)
                                                 name: kSIPRegState 
                                               object:nil];
#if SPECIFIC_ADD_PERSON
    peoplePickerCtrl = [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerCtrl.navigationBar.barStyle = UIBarStyleBlackOpaque;
    peoplePickerCtrl.peoplePickerDelegate = self;
#endif
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
*/
- (void)loadView 
{  
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

  
  _label = [[UITextField alloc] initWithFrame: CGRectMake(0.0f, 0.0f,width,height*.15)];
  
  _label.autocorrectionType = UITextAutocorrectionTypeNo;
  _label.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _label.keyboardType = UIKeyboardTypeURL;
  
  _label.returnKeyType = UIReturnKeyDone;
  _label.borderStyle = UITextBorderStyleNone;
  _label.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _label.delegate = self;
  _label.textColor = [UIColor lightGrayColor];
  _label.backgroundColor = [UIColor clearColor];
  _label.font = [UIFont fontWithName:@"Helvetica" size:30];
  _label.minimumFontSize = 15;
  _label.adjustsFontSizeToFitWidth = YES;
  _label.textAlignment = UIBaselineAdjustmentAlignCenters;
  
  _label.text = @"";
  [_lcd addSubview:_label];
  
  _pad = [[DialerPhonePad alloc] initWithFrame: 
          CGRectMake(0.0f, height*.15, width, height*.57)];

 
  [_pad setPlaysSounds:[[NSUserDefaults standardUserDefaults] 
                        boolForKey:@"keypadPlaySound"]];
  [_pad setDelegate:self];
  
  SiphonApplication *app = (SiphonApplication *)[SiphonApplication sharedApplication];
  
    _gsmCallButton =[[UIButton alloc] initWithFrame:
                     CGRectMake(0.0f, 0.0f, width*.33, height*.13)];
    [_gsmCallButton setImage:[UIImage imageNamed:@"video.png"]
                 forState: UIControlStateNormal];
      
   // _gsmCallButton.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
    [_gsmCallButton setTitle:@"" forState:UIControlStateNormal];
   // _gsmCallButton.titleShadowOffset = CGSizeMake(0,-1);
    [_gsmCallButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_gsmCallButton setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
    [_gsmCallButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_gsmCallButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
    _gsmCallButton.font = [UIFont boldSystemFontOfSize:26];
   
    UIGraphicsBeginImageContext(_gsmCallButton.frame.size);
    [[UIImage imageNamed:@"call.png"] drawInRect:_gsmCallButton.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _gsmCallButton.backgroundColor = [UIColor colorWithPatternImage:image];

    
    [_gsmCallButton addTarget:self action:@selector(gsmCallButtonPressed:) 
          forControlEvents:UIControlEventTouchDown];
  
  _callButton =[[UIButton alloc] initWithFrame:
                CGRectMake(width*.33, 0.0f, width*.33, height*.13)];
  
  [_callButton setImage:[UIImage imageNamed:@"answer.png"]
               forState: UIControlStateNormal];
    
 // _callButton.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
  [_callButton setTitle:@"" forState:UIControlStateNormal];
 // _callButton.titleShadowOffset = CGSizeMake(0,-1);
  [_callButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  [_callButton setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
  [_callButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  [_callButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5]  forState:UIControlStateDisabled];
  _callButton.font = [UIFont boldSystemFontOfSize:26];
  
    UIGraphicsBeginImageContext(_callButton.frame.size);
    [[UIImage imageNamed:@"call.png"] drawInRect:_callButton.bounds];
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _callButton.backgroundColor = [UIColor colorWithPatternImage:image1];

    

  [_callButton addTarget:self action:@selector(callButtonPressed:)
               forControlEvents:UIControlEventTouchDown];
  
  _deleteButton = [[UIButton alloc] initWithFrame:
                   CGRectMake(width*.66, 0.0f, width*.34, height*.13)];
    
    _deleteButton.contentMode = UIViewContentModeScaleToFill;
    _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

  [_deleteButton setImage:[UIImage imageNamed:@"delete.png"]
                 forState:UIControlStateNormal];
  [_deleteButton setImage: [UIImage imageNamed:@"delete_pressed.png"]
                 forState:UIControlStateHighlighted];
  [_deleteButton addTarget:self action:@selector(deleteButtonPressed:) 
                 forControlEvents:UIControlEventTouchDown];
  [_deleteButton addTarget:self action:@selector(deleteButtonReleased:) 
                 forControlEvents:UIControlEventValueChanged| 
                 UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    
    
    
 _container = [[UIView alloc] initWithFrame:
                CGRectMake(0.0f, height*.72, width, height*.13)];
  
  
  [view addSubview:_pad];
  [view addSubview:_lcd];

  [_container addSubview:_gsmCallButton];
  [_container addSubview:_callButton];
  [_container addSubview:_deleteButton];
  
  [view addSubview:_container];

  self.view = view;
  [view release];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{ 
  _pad.enabled = NO;
  
  if (_gsmCallButton)
    _gsmCallButton.enabled = NO;
  
    UIGraphicsBeginImageContext(_lcd.frame.size);
    [[UIImage imageNamed:@"lcd_top_simple.png"] drawInRect:_lcd.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _lcd.backgroundColor = [UIColor colorWithPatternImage:image];
  
  NSDictionary* info = [aNotification userInfo];
  
  // Get the size of the keyboard.
  NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
  CGSize keyboardSize = [aValue CGRectValue].size;
  
  [UIView beginAnimations:@"scroll" context:nil];
  [UIView setAnimationDuration:0.3];
  // FIXME use toolbar.height
  CGRect rect = _container.frame;
    rect.origin.y = height*.72 - keyboardSize.height + height*.11;
   
  _container.frame = rect;
  
  [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    UIGraphicsBeginImageContext(_lcd.frame.size);
    [[UIImage imageNamed:@"lcd_top_simple.png"] drawInRect:_lcd.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _lcd.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    [UIView beginAnimations:@"scroll" context:nil];
  [UIView setAnimationDuration:0.3];
  CGRect rect = _container.frame;
    rect.origin.y = height*.72;
  _container.frame = rect;
  [UIView commitAnimations];
  _pad.enabled = YES;
}




- (void)viewWillAppear:(BOOL)animated 
{
    
    
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification 
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated 
{
  [_label resignFirstResponder];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification 
                                                object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification 
                                                object:nil];
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name: kSIPRegState 
                                                object:nil];
#if SPECIFIC_ADD_PERSON
  [peoplePickerCtrl release];
#endif
  
  [_label release];
  [_lcd release];
  [_pad release];

  [_addContactButton release];
  [_gsmCallButton release];

  [_callButton release];
  [_deleteButton release];

  [forbiddenChars release];
  [_container release];

  
	[super dealloc];
}

/*** Buttons callback ***/
- (void)phonePad:(id)phonepad appendString:(NSString *)string
{
  NSString *curText = [_label text];
  [_label setText: [curText stringByAppendingString: string]];
  
  _callButton.enabled = YES;
  if (_gsmCallButton)
    _gsmCallButton.enabled = YES;
    
    UIGraphicsBeginImageContext(_lcd.frame.size);
    [[UIImage imageNamed:@"lcd_top_simple.png"] drawInRect:_lcd.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _lcd.backgroundColor = [UIColor colorWithPatternImage:image];
  
}
- (void)phonePad:(id)phonepad replaceLastDigitWithString:(NSString *)string
{
  NSString *curText = [_label text];
  curText = [curText substringToIndex:([curText length] - 1)];
  [_label setText: [curText stringByAppendingString: string]];
}

- (void)callButtonPressed:(UIButton*)button
{
  if (([[_label text] length] > 0) && 
      ([phoneCallDelegate respondsToSelector:@selector(dialup:number:)]))
  {
    [phoneCallDelegate dialup:[_label text] number:NO];
    _lastNumber = [[NSString alloc] initWithString: [_label text]];
    [_label setText:@""];
      
      UIGraphicsBeginImageContext(_lcd.frame.size);
      [[UIImage imageNamed:@"lcd_top_simple.png"] drawInRect:_lcd.bounds];
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      _lcd.backgroundColor = [UIColor colorWithPatternImage:image];
      
    
  }
  else
  {
      UIGraphicsBeginImageContext(_lcd.frame.size);
      [[UIImage imageNamed:@"lcd_top_simple.png"] drawInRect:_lcd.bounds];
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      _lcd.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [_label setText:_lastNumber];
    [_lastNumber release];
  }
}



- (void)gsmCallButtonPressed:(UIButton*)button
{
  NSURL *url;
  NSString *urlStr;
  if ([[_label text] length] > 0)
  {
    urlStr = [NSString stringWithFormat:@"tel://%@",[_label text],nil];
    url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL: url]; 
    
  }
  else
  {
    [_label setText:_lastNumber];
    [_lastNumber release];
  }
}

- (void)stopTimer
{
  if (_deleteTimer)
  {
    [_deleteTimer invalidate];
    [_deleteTimer release];
    _deleteTimer = nil;
  }
  if ([[_label text] length] == 0)
  {
    _callButton.enabled = NO;
    if (_gsmCallButton)
      _gsmCallButton.enabled = NO;
    if (!_label.editing)
    {
        UIGraphicsBeginImageContext(_lcd.frame.size);
        [[UIImage imageNamed:@"lcd_top_simple.png"] drawInRect:_lcd.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _lcd.backgroundColor = [UIColor colorWithPatternImage:image];
        
    }
  }
}

- (void)deleteRepeat
{
  NSString *curText = [_label text];
  int length = [curText length];
  if(length > 0)
  {
    _deletedChar++;
    if (_deletedChar == 6)
    {
      [_label setText:@""];
    }
    else
    {
      [_label setText: [curText substringToIndex:(length-1)]];
    }
  }
  else
  {
    [self stopTimer];
  }
}

- (void)deleteButtonPressed:(UIButton*)unused
{
  _deletedChar = 0;
  [self deleteRepeat];
  _deleteTimer = [[NSTimer scheduledTimerWithTimeInterval:0.2 target:self 
                                                selector:@selector(deleteRepeat) 
                                                userInfo:nil 
                                                repeats:YES] retain];
}

- (void)deleteButtonReleased:(UIButton*)unused
{
  [self stopTimer];
}

#if !SPECIFIC_ADD_PERSON

#pragma mark ABUnknownPersonViewControllerDelegate 
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCtrl
                 didResolveToPerson:(ABRecordRef)person
{
  //[self/*.parentViewController*/ dismissModalViewControllerAnimated:YES];
  [unknownCtrl dismissModalViewControllerAnimated:YES];
}

- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
  return YES;
}

#else /* SPECIFIC_ADD_PERSON */
- (void)addNewPerson
{
  CFErrorRef error = NULL;
  // Create New Contact
  ABRecordRef person = ABPersonCreate ();
  
  // Add phone number
  ABMutableMultiValueRef multiValue = 
  ABMultiValueCreateMutable(kABStringPropertyType);
  
  ABMultiValueAddValueAndLabel(multiValue, [_label text], kABPersonPhoneMainLabel, 
                               NULL);  
  
  ABRecordSetValue(person, kABPersonPhoneProperty, multiValue, &error);
  
  
  ABNewPersonViewController *newPersonCtrl = [[ABNewPersonViewController alloc] init];
  newPersonCtrl.newPersonViewDelegate = self;
  newPersonCtrl.displayedPerson = person;
  CFRelease(person); // TODO check
  
  UINavigationController *navCtrl = [[UINavigationController alloc] 
                                     initWithRootViewController:newPersonCtrl];
  navCtrl.navigationBar.barStyle = UIBarStyleBlackOpaque;
  [self.parentViewController presentModalViewController:navCtrl animated:YES];
  [newPersonCtrl release];
  [navCtrl release];
}

#pragma mark ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController 
       didCompleteWithNewPerson:(ABRecordRef)person
{
  [newPersonViewController dismissModalViewControllerAnimated:YES];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
  CFErrorRef error = NULL;
  BOOL status;
  ABMutableMultiValueRef multiValue;
  // Inserer le numéro dans la fiche de la personne
  // Add phone number
  CFTypeRef typeRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
  if (ABMultiValueGetCount(typeRef) == 0)
    multiValue = ABMultiValueCreateMutable(kABStringPropertyType);
  else
    multiValue = ABMultiValueCreateMutableCopy (typeRef);
  
  // TODO type (mobile, main...)
  // TODO manage URI
  status = ABMultiValueAddValueAndLabel(multiValue, [_label text], kABPersonPhoneMainLabel, 
                                        NULL);  
  
  status = ABRecordSetValue(person, kABPersonPhoneProperty, multiValue, &error);
  status = ABAddressBookSave(peoplePicker.addressBook, &error);
  [peoplePicker dismissModalViewControllerAnimated:YES];
  return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                                property:(ABPropertyID)property 
                              identifier:(ABMultiValueIdentifier)identifier
{
  return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
  [peoplePicker dismissModalViewControllerAnimated:YES];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex) 
  {
    case 0: // Create new contact
      [self addNewPerson];
      break;
    case 1: // Add to existing Contact
      [self presentModalViewController:peoplePickerCtrl animated:YES];
      // do something else
    default:
      break;
  }
}
#endif /* SPECIFIC_ADD_PERSON */

- (void)cancelAddPerson:(id)unused
{
  [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
  [_lcd rightText:@"Service Unavailable"];
}

- (void)processRegState:(NSNotification *)notification
{
  NSDictionary *dictionary = [notification userInfo];
  if ([[dictionary objectForKey:@"Status"] intValue] == 200)
    [_lcd rightText:@"Connected"];
  else
    [_lcd rightText:[dictionary objectForKey:@"StatusText"]];
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  [_label setText:@""];
  _callButton.enabled = NO;
  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSRange r = [forbiddenChars rangeOfString: string];
  if (r.location != NSNotFound)
    return NO;
  
  _callButton.enabled = ([[textField text] length] + [string length] - range.length > 0);
  
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  return ([[textField text] length] == 0);
}

@end
