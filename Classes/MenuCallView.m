
#import "MenuCallView.h"


@implementation MenuCallView

@synthesize delegate;

- (void)preloadButtons
{
  int i;
  CGRect rect = {0.0f, 0.0f, 0.0f, 0.0f};
  NSString *bg, *bgSel;
  UIImage *image, *selectedImage;
  
  for (i = 0; i < 6; ++i)
  {
    bg    = [NSString stringWithFormat:@"sixsqbutton_%d.png", i+1];
    bgSel = [NSString stringWithFormat:@"sixsqbuttonsel_%d.png", i+1];
    image = [UIImage imageNamed:bg];
    selectedImage = [UIImage imageNamed:bgSel];
    
    rect.size = [image size];
    PushButton *button = [[PushButton alloc] initWithFrame:rect];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    
    
    [button setTag:i];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect content = CGRectMake(11.0, 11.0, 72.0, 75.0);
    if (i == 0 || i == 3)
      content.origin.x += 5.;
    if (i < 3)
      content.origin.y += 2.;
    [button setContentRect: content];
    
    _buttons[i] = button;
    [self addSubview:_buttons[i]];
    
    if (i == 2)
    {
     
      rect.origin.y += rect.size.height - 9.0f;
      rect.origin.x = 0.0f;
    }
    else
      rect.origin.x += rect.size.width;
  }
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        
        
        // Initialization code
      // TODO display text maybe I need to derivate UIButton
      [self preloadButtons];
    }
    return self;
}

- (void)clicked:(UIButton *)button
{
  if ([delegate respondsToSelector:@selector(menuButtonClicked:)])
  {
    [delegate menuButtonClicked:[button tag]];
  }
}

- (void)dealloc 
{
  int i;
  for (i = 0; i < 6; ++i)
    [_buttons[i] release];
    [super dealloc];
}

- (PushButton *)buttonAtPosition:(NSInteger)pos
{
  if (pos < 0 || pos > 5)
    return nil;
  return _buttons[pos];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image forPosition:(NSInteger)pos
{
  if (pos < 0 || pos > 5)
    return;
  if (image)
  {
    [_buttons[pos] setImage:image forState:UIControlStateNormal];
    [_buttons[pos] setImage:image forState:UIControlStateSelected];
  }
  if (title)
  {
    _buttons[pos].titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize] - 5.];
    [_buttons[pos] setTitle:title forState:UIControlStateNormal];
    
  }
}

@end
