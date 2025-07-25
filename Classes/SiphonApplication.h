
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SCNetworkReachability.h>


#import "CallViewController.h"
#import "RecentsViewController.h"
#import "PhoneViewController.h"
#import "PhoneCallDelegate.h"
#import "Reachability.h"


#include "call.h"

//#define MWI 1
#define REACHABILITY_2_0 1

@class SiphonApplication;

@interface SiphonApplication : UIApplication <UIActionSheetDelegate, 
	UIApplicationDelegate,

PhoneCallDelegate>
{
  UIWindow *window;
 // UINavigationController *navController;
  UITabBarController *tabBarController;

  PhoneViewController   *phoneViewController;
  RecentsViewController *recentsViewController;
  CallViewController    *callViewController;
    

  app_config_t _app_config; // pointer ???
  BOOL isConnected;


  pjsua_acc_id  _sip_acc_id;

@private
  NSString *_phoneNumber;
  BOOL launchDefault;
  

  Reachability *_hostReach;
  
}

@property (nonatomic, retain) UIWindow *window;
//@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, assign, readonly) RecentsViewController *recentsViewController;
@property (nonatomic, readonly) BOOL isIpod;

@property BOOL launchDefault;
@property BOOL isConnected;

-(void)displayError:(NSString *)error withTitle:(NSString *)title;
-(void)displayParameterError:(NSString *)error;

- (void)callDisconnecting;
-(void)disconnected:(id)fp8;

//-(RecentsViewController *)recentsViewController;
- (app_config_t *)pjsipConfig;



@end
