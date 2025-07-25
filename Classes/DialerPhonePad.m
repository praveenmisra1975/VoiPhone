#import "DialerPhonePad.h"

@implementation DialerPhonePad
- (UIImage*)keypadImage;
{
  if (_keypadImage == nil)
  {
    _keypadImage = [[UIImage imageNamed: @"dialerkeypad.png"] retain];
  }
  return _keypadImage;
}

- (UIImage*)pressedImage
{
  if (_pressedImage == nil)
  {
    _pressedImage = [[UIImage imageNamed: @"dialerkeypad_pressed.png"] retain];
  }
  return _pressedImage;
}

- (id)initWithFrame:(struct CGRect)rect
{
  if ((self = [super initWithFrame:rect]) != nil)
  {
    [self setOpaque: TRUE];
    _topHeight = 69.0;
    _midHeight = 68.0;
    _bottomHeight = 68.0;
    _leftWidth = 107.0;
    _midWidth = 105.0;
    _rightWidth = 108.0;
  }
  return self;
}

@end
