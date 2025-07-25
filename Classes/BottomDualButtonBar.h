
#import <UIKit/UIKit.h>
#import "BottomButtonBar.h"


@interface BottomDualButtonBar : BottomButtonBar 
{
  UIButton *button2;
}

@property (nonatomic, retain)  UIButton *button2;

- (id) initForIncomingCallWaiting;

@end
