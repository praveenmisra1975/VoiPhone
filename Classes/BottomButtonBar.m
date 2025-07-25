
#import "BottomButtonBar.h"


@implementation BottomButtonBar

@synthesize button;
@synthesize smallTitle, bigTitle;

CGFloat widthBBBar;
CGFloat heightBBBar;



+ (UIButton *)createButtonWithTitle:(NSString *)title
                              image:(UIImage *)image
                              frame:(CGRect)frame
                         background:(UIImage *)backgroundImage
                  backgroundPressed:(UIImage *)backgroundImagePressed
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
  [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
  if (image)
  {
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake (0., 0., 0., 5.);
  }
	
	UIImage *newImage = [backgroundImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [backgroundImagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];

  // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
  
	return button;
}

#define kStdButtonWidth			284.0
#define kStdButtonHeight		48.0    

- (id) initForEndCall
{
  self = [super initWithDefaultSize];
  if (self)
  {
      
      
    UIImage *buttonBackground = [UIImage imageNamed:@"bottombarred.png"];
    UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"bottombarred_pressed.png"];
    UIImage *image = [UIImage imageNamed:@"decline.png"];
    [self setSmallTitle:NSLocalizedString(@"Small end call", @"PhoneView")];
    [self setBigTitle:NSLocalizedString(@"End call", @"PhoneView")];
    UIButton *endCall = [BottomButtonBar createButtonWithTitle: NSLocalizedString(@"End call", @"PhoneView")
                                              image: image
                                              frame: CGRectZero
                                         background: buttonBackground
                                  backgroundPressed: buttonBackgroundPressed];
    [self setButton:endCall];
  }
  return self;
}

- (id) initForIncomingCallWaiting
{
  self = [super initWithDefaultSize];
  if (self)
  {
      CGRect myRect = [[UIScreen mainScreen] bounds];
      widthBBBar=  myRect.size.width ;
      heightBBBar= myRect.size.height ;
      
      
    UIImage *buttonBackground = [UIImage imageNamed:@"bottombarred.png"];
    UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"bottombarred_pressed.png"];
    UIImage *image = [UIImage imageNamed:@"decline.png"];
    
      UIButton *declineCall = [BottomButtonBar createButtonWithTitle: NSLocalizedString(@"End Call + Answer", @"PhoneView")
                                                         image: image
                                                         frame: CGRectZero
                                                    background: buttonBackground
                                             backgroundPressed: buttonBackgroundPressed];
    [self setButton:declineCall];
  }
  return self;
}



- (void)dealloc 
{
  [button release];
	[super dealloc];
}

- (void)setButton:(UIButton *)newButton
{
  [newButton retain];
  [newButton setFrame:CGRectMake(widthBBBar*.05, heightBBBar*.05, widthBBBar*.89, heightBBBar*.10)];

  //  [newButton setFrame:CGRectMake(18.0, 24.0, widthBBBar*.89, heightBBBar*.10)];
    
  
  [button removeFromSuperview];
  [button release];
  button = newButton;
  [self addSubview:button];
}

@end
