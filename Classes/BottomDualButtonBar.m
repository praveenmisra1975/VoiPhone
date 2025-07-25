
#import "BottomDualButtonBar.h"


@implementation BottomDualButtonBar

CGFloat widthBDBar;
CGFloat heightBDBar;


@synthesize button2;


- (id) initForIncomingCallWaiting
{
  
  self = [super initForIncomingCallWaiting];
  if (self)
  {
      CGRect myRect = [[UIScreen mainScreen] bounds];
      widthBDBar=  myRect.size.width ;
      heightBDBar= myRect.size.height ;
      
    
    [super setSmallTitle:NSLocalizedString(@"Decline", @"PhoneView")];
    [super setBigTitle:NSLocalizedString(@"Decline", @"PhoneView")];
    [[super button] setTitle:NSLocalizedString(@"Decline", @"PhoneView") 
                    forState:UIControlStateNormal];

    UIImage *buttonBackground = [UIImage imageNamed:@"bottombargreen.png"];
    UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"bottombargreen_pressed.png"];
      
    UIImage *image = [UIImage imageNamed:@"answer.png"];

    UIButton * answer = [BottomButtonBar createButtonWithTitle: NSLocalizedString(@"Answer", @"PhoneView")
            image: image frame: CGRectZero background: buttonBackground
                    backgroundPressed: buttonBackgroundPressed];
    [self setButton2: answer];
  }
  return self;
}

- (void)dealloc
{
  [button2 release];
	[super dealloc];
}

- (void)setButton2:(UIButton *)newButton
{
  [newButton retain];
  [newButton setFrame:CGRectMake((widthBDBar*.05) + (widthBDBar*.412) + 20.0, heightBDBar*.05,(widthBDBar*.412),  heightBDBar*.10)];
  
  [button2 removeFromSuperview];
  [button2 release];
  button2 = newButton;
  [self addSubview:button2];
  
  if (newButton == nil)
  {
    if ([self.bigTitle length])
      [button setTitle:self.bigTitle forState:UIControlStateNormal];
    CGRect rect = [button frame];
      rect.size.width = widthBDBar*.89;
    [button setFrame:rect];
  }
  else
  {
    if ([self.smallTitle length])
      [button setTitle:self.smallTitle forState:UIControlStateNormal];
    CGRect rect = [button frame];
    rect.size.width = widthBDBar * .412;
    [button setFrame:rect];
  }
}

@end
