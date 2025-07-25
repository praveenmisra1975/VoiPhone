
#import <UIKit/UIKit.h>
#import "BottomBar.h"


@interface BottomButtonBar : BottomBar 
{
  UIButton *button;
  NSString *title;
  NSString *smallTitle, *bigTitle;
  //id _delegate;
}

@property (nonatomic, retain)  UIButton *button;
@property (nonatomic, retain)  NSString *smallTitle , *bigTitle;

- (id) initForIncomingCallWaiting;
- (id) initForEndCall;

+ (UIButton *)createButtonWithTitle:	(NSString *)title
                              image:(UIImage *)image
                              frame:(CGRect)frame
                         background:(UIImage *)backgroundImage
                  backgroundPressed:(UIImage *)backgroundImagePressed;

@end
