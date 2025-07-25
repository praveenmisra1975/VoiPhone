
#import "PushButton.h"


@implementation PushButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
  return _contentRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{  
  CGRect rect = _contentRect;
  CGSize titleSize = [[self titleForState:UIControlStateNormal] sizeWithFont: [self font]];

  rect.origin.x += (rect.size.width - titleSize.width)/2.;
  rect.origin.y = rect.size.height;
  rect.size.width  = titleSize.width;
  rect.size.height = titleSize.height;

  return rect;
}

- (CGRect)contentRectForBounds:(CGRect)bounds
{
  return _contentRect;
}

- (void)dealloc 
{
  //[_contentRect release];
  [super dealloc];
}

- (void)setContentRect:(CGRect)rect
{
  //[_contentRect release];
  _contentRect = rect;
}

@end
