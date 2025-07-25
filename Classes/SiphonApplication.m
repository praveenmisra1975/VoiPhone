
#import "SiphonApplication.h"
#include "version.h"

#import "ContactViewController.h"
#import "RecentsViewController.h"
//#import "FavoritesListController.h"
#import "VoicemailController.h"
#import "Reachability.h"
#import "RecentCall.h"
#include <unistd.h>
//praveen added inappsetting
#import "InAppSettings.h"


#define THIS_FILE "SiphonApplication.m"
#define kDelayToCall 10.0
static NSString *kVoipOverEdge = @"siphonOverEDGE";

typedef enum ConnectionState {
  DISCONNECTED,
  IN_PROGRESS,
  CONNECTED,
  ERROR
} ConnectionState;

#define KEEP_ALIVE_INTERVAL 600


@interface UIApplication ()

- (BOOL)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)suspended;
- (void)addStatusBarImageNamed:(NSString *)imageName removeOnExit:(BOOL)remove;
- (void)addStatusBarImageNamed:(NSString *)imageName;
- (void)removeStatusBarImageNamed:(NSString *)imageName;

@end


@interface SiphonApplication (private)
- (BOOL) sipStartup;
- (void) sipCleanup;
- (BOOL) sipConnect;
- (BOOL) sipDisconnect;

@end


@implementation SiphonApplication

@synthesize window;
//@synthesize navController;
@synthesize tabBarController;
@synthesize recentsViewController;

@synthesize launchDefault;
@synthesize isConnected;


/***** MESSAGE *****/
-(void)displayParameterError:(NSString *)msg
{
  NSString *message = NSLocalizedString(msg, msg);
  NSString *error = [message stringByAppendingString:NSLocalizedString(
      @"\nTo correct this parameter, select \"Settings\" from your Home screen, "
       "and then tap the \"VoiPhone\" entry.", @"VoiPhoneApp")];
  
  
  UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil 
                                                   message:error
                                                  delegate:nil

                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"VoiPhoneApp") 
                                         otherButtonTitles:NSLocalizedString(@"Settings", @"VoiPhoneApp"), nil ] autorelease];
  [alert show];
  //[alert release];
}


-(void)displayError:(NSString *)error withTitle:(NSString *)title
{
  UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title 
                                                   message:error 
                                                  delegate:nil 
                                         cancelButtonTitle:NSLocalizedString(@"OK", @"VoiPhoneApp") 
                                         otherButtonTitles:nil] autorelease];
   [alert show];
   //[alert release];
}

-(void)displayStatus:(pj_status_t)status withTitle:(NSString *)title
{
  char msg[80];
  pj_str_t pj_msg = pj_strerror(status, msg, 80);
  PJ_UNUSED_ARG(pj_msg);
  
  NSString *message = [NSString stringWithUTF8String:msg];
  
  [self displayError:message withTitle:nil];
  //[message release];
}



/***** SIP ********/
/* */
- (BOOL)sipStartup
{
  if (_app_config.pool)
    return YES;
  
  self.networkActivityIndicatorVisible = YES;
  
  if (sip_startup(&_app_config) != PJ_SUCCESS)
  {
    self.networkActivityIndicatorVisible = NO;
    return NO;
  }else
  {
      
      NSLog(@"sip_startup Done in delegate sipStartup !!!!");
  }
    
  self.networkActivityIndicatorVisible = NO;
  
  /** Call management **/
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(processCallState:)
                                               name: kSIPCallState object:nil];
  
  /** Registration management */
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(processRegState:)
                                               name: kSIPRegState object:nil];
  
  return YES;
}

/* */
- (void)sipCleanup
{
  //[[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name: kSIPRegState
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name:kSIPCallState 
                                                object:nil];
  [self sipDisconnect];
  
  if (_app_config.pool != NULL)
  {
    sip_cleanup(&_app_config);
  }
}

/* */
- (BOOL)sipConnect
{
  pj_status_t status;
  
  if (![self sipStartup])
  {
      return FALSE;
  }else
  {
      NSLog(@"Sip Startup  (sipConnect) already Done !!!!");
  }

  
  if (_sip_acc_id == PJSUA_INVALID_ID)
  {
      NSLog(@"No Valid Account yet  !!!!");
    self.networkActivityIndicatorVisible = YES;
    if ((status = sip_connect(_app_config.pool, &_sip_acc_id)) != PJ_SUCCESS)
    {
      self.networkActivityIndicatorVisible = NO;
      return FALSE;
    }else
    {
        NSLog(@"sip_connect (sipConnect) is already Done !!!!");
    }
  }else
  {
      pjsua_acc_set_registration(_sip_acc_id, PJ_TRUE);
     
  }
  
  return TRUE;
}

/* */
- (BOOL)sipDisconnect
{
  if ((_sip_acc_id != PJSUA_INVALID_ID) &&
      (sip_disconnect(&_sip_acc_id) != PJ_SUCCESS))
  {
    return FALSE;
  }
  
  _sip_acc_id = PJSUA_INVALID_ID;

  isConnected = FALSE;

  return TRUE;
}

- (void)initUserDefaults:(NSMutableDictionary *)dict fromSettings:(NSString *)settings
{
  NSDictionary *prefItem;
  
  NSString *pathStr = [[NSBundle mainBundle] bundlePath];
  NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
  NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:settings];
  NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
  NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
  
  for (prefItem in prefSpecifierArray)
  {
    NSString *keyValueStr = [prefItem objectForKey:@"Key"];
    if (keyValueStr)
    {
      id defaultValue = [prefItem objectForKey:@"DefaultValue"];
      if (defaultValue)
      {
        [dict setObject:defaultValue forKey: keyValueStr];
      }
    }
  }
}

- (void)initUserDefaults
{

  NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
  
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity: 10];
  [self initUserDefaults:dict fromSettings:@"Advanced.plist"];
  [self initUserDefaults:dict fromSettings:@"Network.plist"];
  [self initUserDefaults:dict fromSettings:@"Phone.plist"];
  [self initUserDefaults:dict fromSettings:@"Codec.plist"];
  
  [userDef registerDefaults:dict];
  [userDef synchronize];
  //[dict release];

}


  

- (UIViewController *)applicationStartWithSettings
    {
        
        /* Settings */
    InAppSettingsViewController *settings = [[[InAppSettingsViewController alloc] init] autorelease];
    UINavigationController *settingsNav = [[[UINavigationController alloc] initWithRootViewController:settings] autorelease];
        settingsNav.navigationBar.barStyle = UIBarStyleBlack;
        settingsNav.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
        settingsNav.tabBarItem.title = @"Settings";
        

    
        
    /* Recents list */
    recentsViewController = [[RecentsViewController alloc]
                              initWithStyle:UITableViewStylePlain];
                                             //autorelease];
    recentsViewController.phoneCallDelegate = self;
    UINavigationController *recentsViewCtrl = [[[UINavigationController alloc]
                initWithRootViewController:
                    recentsViewController] autorelease];
    recentsViewCtrl.navigationBar.barStyle = UIBarStyleBlack;
    [recentsViewController release];

    /* Dialpad */
    phoneViewController = [[[PhoneViewController alloc]
                            initWithNibName:nil bundle:nil] autorelease];
    phoneViewController.phoneCallDelegate = self;

    /* Contacts */
    ContactViewController *contactsViewCtrl = [[[ContactViewController alloc]
                                                init] autorelease];
    contactsViewCtrl.phoneCallDelegate = self;

    /* Voicemail */
    VoicemailController *voicemailController = [[VoicemailController alloc]
            initWithStyle:UITableViewStylePlain];
    voicemailController.phoneCallDelegate = self;
        
    UINavigationController *voicemailNavCtrl = [[[UINavigationController alloc]
                initWithRootViewController:
                    voicemailController] autorelease];
        
    voicemailNavCtrl.navigationBar.barStyle = UIBarStyleBlack;
    [voicemailController release];

    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:
                                        voicemailNavCtrl, recentsViewCtrl,
                                        phoneViewController, contactsViewCtrl,
                                        settingsNav, nil];
       
       
    tabBarController.selectedIndex = 2;

  return tabBarController;
}



/***** APPLICATION *****/
- (BOOL)application:(UIApplication *)application 
      didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  _sip_acc_id = PJSUA_INVALID_ID;

  isConnected = FALSE;
  

  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    

  NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
  [self initUserDefaults];
    
    NSLog(@" User name : %@",[userDef objectForKey: @"Username"]);
    NSLog(@" server name : %@",[userDef objectForKey: @"Domain"]);
    
      if ([[userDef objectForKey: @"Username"] length] ||
            [[userDef objectForKey: @"Domain"] length])
    {
        NSString *server = [userDef stringForKey: @"OutboundProxies"];
         NSArray *array = [server componentsSeparatedByString:@","];
         NSEnumerator *enumerator = [array objectEnumerator];
         while (server = [enumerator nextObject])
           if ([server length])break;
         //[enumerator release];
        // [array release];
         if (!server || [server length] < 1)
           server = [userDef stringForKey: @"Domain"];

         NSRange range = [server rangeOfString:@":"
                        options:NSCaseInsensitiveSearch|NSBackwardsSearch];
         if (range.length > 0)
         {
           server = [server substringToIndex:range.location];
         }
        _hostReach = [[Reachability reachabilityWithHostName: server] retain];
        [_hostReach startNotifer];
        
        
       
       
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
      selector:@selector(reachabilityChanged:)
                name:kReachabilityChangedNotification object:nil];
     
    
    // Build GUI
    callViewController = [[CallViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.window setRootViewController:[self applicationStartWithSettings]];
    
  //  launchDefault = YES;
 
       [self performSelector:@selector(sipConnect) withObject:nil afterDelay:0.2];
    
    
    
   // if ([userDef boolForKey:@"keepAwake"])
    //  [self keepAwakeEnabled];
  

  [window makeKeyAndVisible];
    return YES;

    
    
}



- (void)applicationWillTerminate:(UIApplication *)application
{
  
  // TODO enregistrer le numéro en cours pour le rappeler au retour ?
  [_hostReach stopNotifer];
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name:kReachabilityChangedNotification 
                                                object:nil];
  [self sipCleanup];
    [callViewController release];
   
    [recentsViewController finalizeDatabase];
}


- (void)dealloc
{
  [_hostReach release];

  [phoneViewController release];
  [recentsViewController release];
  
	//[navController release];
  [callViewController release];
  [tabBarController release];  
	[window release];
	[super dealloc];
}

/************ **************/

- (NSString *)normalizePhoneNumber:(NSString *)number
{
  const char *phoneDigits = "22233344455566677778889999",
             *nb = [[number uppercaseString] UTF8String];
  int i, len = [number length];
  char *u, *c, *utf8String = (char *)calloc(sizeof(char), len+1);
  c = (char *)nb; u = utf8String;
  for (i = 0; i < len; ++c, ++i)
  {
    if (*c == ' ' || *c == '(' || *c == ')' || *c == '/' || *c == '-' || *c == '.')
      continue;
/*    if (*c >= '0' && *c <= '9')
    {
      *u = *c;
      u++;
    }
    else*/ if (*c >= 'A' && *c <= 'Z')
    {
      *u = phoneDigits[*c - 'A'];
    }
    else
      *u = *c;
    u++;
  }
  NSString * norm = [[NSString alloc] initWithUTF8String:utf8String];
  free(utf8String);
  return norm;
}


/** FIXME plutôt à mettre dans l'objet qui gère les appels **/
-(void) dialup:(NSString *)phoneNumber number:(BOOL)isNumber
{
  pjsua_call_id call_id;
  pj_status_t status;
  NSString *number;
  
  UInt32 hasMicro, size;

  // Verify if microphone is available (perhaps we should verify in another place ?)
  size = sizeof(hasMicro);
  AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable,
                          &size, &hasMicro);
  if (!hasMicro)
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Microphone Available", @"VoiPhoneApp")
                                                    message:NSLocalizedString(@"Connect a microphone to phone", @"VoiPhoneApp")
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"VoiPhoneApp")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
  }
  
  if (isNumber)
    number = [self normalizePhoneNumber:phoneNumber];
  else
    number = phoneNumber;

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"removeIntlPrefix"])
  {
    number = [number stringByReplacingOccurrencesOfString:@"+"
                                               withString:@"" 
                                                     options:0 
                                                       range:NSMakeRange(0,1)];
  }
  else
  {
  NSString *prefix = [[NSUserDefaults standardUserDefaults] stringForKey: @"intlPrefix"];
  if ([prefix length] > 0)
  {
    number = [number stringByReplacingOccurrencesOfString:@"+"
                                                   withString:prefix 
                                                      options:0 
                                                        range:NSMakeRange(0,1)];
  }
  }
  
  // Manage pause symbol
  NSArray * array = [number componentsSeparatedByString:@","];
  [callViewController setDtmfCmd:@""];
  if ([array count] > 1)
  {
    number = [array objectAtIndex:0];
    [callViewController setDtmfCmd:[array objectAtIndex:1]];
  }

  if (!isConnected )
  {
    _phoneNumber = [[NSString stringWithString: number] retain];
   
      UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"The SIP server is unreachable!",@"VoiPhoneApp") 
                                                               delegate:self 
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel",@"VoiPhoneApp") 
                                                 destructiveButtonTitle:nil 
                                                      otherButtonTitles:NSLocalizedString(@"Cellular call",@"VoiPhoneApp"),
                                     nil] autorelease];
      actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
      [actionSheet showInView: self.window];
    
    return;
  }

  if ([self sipConnect])
  {
    NSRange range = [number rangeOfString:@"@"];
    if (range.location != NSNotFound)
    {
      status = sip_dial_with_uri(_sip_acc_id, [[NSString stringWithFormat:@"sip:%@", number] UTF8String], &call_id);
    }
    else
    status = sip_dial(_sip_acc_id, [number UTF8String], &call_id);
    if (status != PJ_SUCCESS)
    {
      // FIXME
      //[self displayStatus:status withTitle:nil];
      const pj_str_t *str = pjsip_get_status_text(status);
      NSString *msg = [[NSString alloc]
                       initWithBytes:str->ptr 
                       length:str->slen 
                       encoding:[NSString defaultCStringEncoding]];
      [self displayError:msg withTitle:@"registration error"];
    }
  }
}
/** Fin du FIXME */


- (void)processCallState:(NSNotification *)notification
{

  NSNumber *value = [[ notification userInfo ] objectForKey: @"CallID"];
  pjsua_call_id callId = [value intValue];

  int state = [[[ notification userInfo ] objectForKey: @"State"] intValue];

  switch(state)
  {
    case PJSIP_INV_STATE_NULL: // Before INVITE is sent or received.
      return;
    case PJSIP_INV_STATE_CALLING: // After INVITE is sent.

          [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    case PJSIP_INV_STATE_INCOMING: // After INVITE is received.
      self.idleTimerDisabled = YES;
          self.statusBarStyle = UIStatusBarStyleLightContent;
      if (pjsua_call_get_count() == 1)
      {
        [tabBarController presentModalViewController:callViewController animated:YES];
      }
    case PJSIP_INV_STATE_EARLY: // After response with To tag.
    case PJSIP_INV_STATE_CONNECTING: // After 2xx is sent/received.
      break;
    case PJSIP_INV_STATE_CONFIRMED: // After ACK is sent/received.
          [UIDevice currentDevice].proximityMonitoringEnabled = YES;
      break;
    case PJSIP_INV_STATE_DISCONNECTED:

      self.idleTimerDisabled = NO;
        [UIDevice currentDevice].proximityMonitoringEnabled = NO;
     
      if (pjsua_call_get_count() <= 1)
        [self performSelector:@selector(disconnected:) 
                   withObject:nil afterDelay:1.0];

      break;
  }
  [callViewController processCall: [ notification userInfo ]];
}

- (void)callDisconnecting
{
  self.idleTimerDisabled = NO;
 
 [UIDevice currentDevice].proximityMonitoringEnabled = NO;

  if (pjsua_call_get_count() <= 1)
    [self performSelector:@selector(disconnected:) 
               withObject:nil afterDelay:1.0];
}

- (void)processRegState:(NSNotification *)notification
{
//  const pj_str_t *str;
  //NSNumber *value = [[ notification userInfo ] objectForKey: @"AccountID"];
  //pjsua_acc_id accId = [value intValue];
  self.networkActivityIndicatorVisible = NO;
  int status = [[[ notification userInfo ] objectForKey: @"Status"] intValue];
  
  switch(status)
  {
    case 200: // OK
      isConnected = TRUE;
      break;
    case 403: // registration failed
    case 404: // not found
      //sprintf(TheGlobalConfig.accountError, "SIP-AUTH-FAILED");
      //break;
    case 503:
    case PJSIP_ENOCREDENTIAL: 
      // This error is caused by the realm specified in the credential doesn't match the realm challenged by the server
      //sprintf(TheGlobalConfig.accountError, "SIP-REGISTER-FAILED");
      //break;
    default:
      isConnected = FALSE;
//      [self sipDisconnect];
  }
} 

- (void) disconnected:(id)fp8
{
  self.statusBarStyle = UIStatusBarStyleDefault;
  [tabBarController dismissModalViewControllerAnimated: YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSURL *url;
  NSString *urlStr;
  switch (buttonIndex) 
  {
    case 0: // Call with GSM
      urlStr = [NSString stringWithFormat:@"tel://%@",_phoneNumber,nil];
      url = [NSURL URLWithString:urlStr];
      [self openURL: url];
      break;
    default:
      break;
  }
  [_phoneNumber release];
}

//-(RecentsViewController *)recentsViewController
//{
//  return recentsViewController;
//}


- (app_config_t *)pjsipConfig
{
  return &_app_config;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
  // FIXME on doit pouvoir faire plus intelligent !!
  //NSLog(@"reachabilityChanged");
 // SCNetworkReachabilityFlags flags = [[[ notification userInfo ] 
  //                                     objectForKey: @"Flags"] intValue];
  Reachability* curReach = [notification object];
  if ([curReach currentReachabilityStatus] == NotReachable)
  {
  [phoneViewController reachabilityChanged:notification];
  [self sipDisconnect];
  }
  else
  {
  [self sipConnect];
}
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
  /*  if (@available(iOS 18.2, *)) {
        // setKeepAliveTimeout is deprecated. Use PushKit instead.
        [application setKeepAliveTimeout:KEEP_ALIVE_INTERVAL handler: ^{
        [self performSelectorOnMainThread:@selector(keepAlive) withObject:nil waitUntilDone:YES];
        }];
    }else
    {
        [self performSelectorOnMainThread:@selector(keepAlive) withObject:nil waitUntilDone:YES];
    }
   */
   

}

/*
- (void)keepAlive {
    static pj_thread_desc a_thread_desc;
    static pj_thread_t *a_thread;
    int i;
    
    if (!pj_thread_is_registered()) {
    pj_thread_register("ipjsua", a_thread_desc, &a_thread);
    }
    
    
    for (i = 0; i < (int)pjsua_acc_get_count(); ++i) {
        if (pjsua_acc_is_valid(i)) {
            pjsua_acc_set_registration(i, PJ_TRUE);
        }
    }
}
 */
 
 

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    /*  NSDictionary *userInfo = notification.userInfo;
    NSString *type = (NSString *)[userInfo objectForKey:@"NotificationType"];
    
   if ([type isEqualToString:@"SIP"])
    {
        NSNumber *callIdentifier = (NSNumber *)[userInfo objectForKey:AKSIPCallIdentifier];
        NSNumber *accountIdentifier = (NSNumber *)[userInfo objectForKey:AKSIPAccountIdentifier];
        
        if (callIdentifier && accountIdentifier)
        {
            AccountController *accountController = [[SIPController sharedInstance] accountContollerByIdentifier:[accountIdentifier intValue]];
            AKSIPCall *theCall = nil;
            for (AKSIPCall *aCall in [accountController.account calls])
                if (aCall.identifier == [callIdentifier intValue])
                {
                    theCall = aCall;
                    break;
                }
            
            if (!theCall || theCall.state == PJSIP_INV_STATE_DISCONNECTED)
                return ;
            
            [accountController acceptIncomingCallInBackground:theCall];
        }
    }
    */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    [self performSelector:@selector(sipConnect) withObject:nil afterDelay:0.2];
      
}




@end
