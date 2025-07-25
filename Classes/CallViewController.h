
#import <UIKit/UIKit.h>
#import "PhonePad.h"
#import "BottomButtonBar.h"
#import "BottomDualButtonBar.h"
#import "MenuCallView.h"
#import "LCDView.h"
#import "DualButtonView.h"
#import "RecentCall.h"

#include <pjsua-lib/pjsua.h>


@interface CallViewController : UIViewController<PhonePadDelegate,
    MenuCallViewDelegate
#if defined(ONECALL) && (ONECALL == 1)
#else 
, DualButtonViewDelegate
#endif
	>
{
  LCDView             *_lcd;
  
  UIView              *_switchViews[2];
  NSUInteger           _whichView;
  UIView		          *_containerView;
  
#if defined(ONECALL) && (ONECALL == 1)
#else
  DualButtonView      *_buttonView;
  BottomButtonBar     *_bottomBar;
#endif

  BottomDualButtonBar *_defaultBottomBar;
  UIButton            *_menuButton;

  BottomDualButtonBar *_dualBottomBar;

  NSTimer *_timer;
  NSString *dtmfCmd;

#if defined(ONECALL) && (ONECALL == 1)
  pjsua_call_id  _call_id;
#else
  pjsua_call_id  _current_call;
  pjsua_call_id  _new_call;
#endif
  RecentCall    *_call[PJSUA_MAX_CALLS];
}

#if 0
- (void)setState:(int)state callId:(pjsua_call_id)call_id;
#else
- (void)processCall:(NSDictionary *)userinfo;
#endif

@property (nonatomic, retain)  NSString *dtmfCmd;

@end
