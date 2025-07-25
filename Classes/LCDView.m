
#import "LCDView.h"

@implementation LCDView

CGFloat widthLCDView;
CGFloat heightLCDView;


//@synthesize image;

+ (UILabel *)createLabel:(CGRect)rect size:(CGFloat)fontSize
{
  UILabel *label;
  
  label = [[UILabel alloc] initWithFrame:rect];
  label.backgroundColor = [UIColor clearColor];
  label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 15;
  label.lineBreakMode = UILineBreakModeHeadTruncation;
  label.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
  label.textAlignment = UITextAlignmentCenter;
  label.textColor = [UIColor whiteColor];
  
  return label;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
	if (self)
  {
      
		// Initialization code
      
      UIGraphicsBeginImageContext(frame.size);
      [[UIImage imageNamed:@"lcd_call_bottom.png"] drawInRect:self.bounds];
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      self.backgroundColor = [UIColor colorWithPatternImage:image];
      
      
      
    self.alpha = 0.7f;
    
      CGRect rect = frame;
    
    rect.size.height = CGRectGetHeight(frame) - 30;
    _text = [LCDView createLabel:rect size:32];
    rect.origin.y = CGRectGetHeight(frame) / 2;
    rect.size.height = CGRectGetHeight(frame) / 2;
    _label = [LCDView createLabel:rect size:20];

    _image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - frame.size.height, 
                                                          5.0f, 
                                                          frame.size.height - 10.0f, 
                                                          frame.size.height - 10.0f)];
    
    [self addSubview:_image];
    [self addSubview:_label];
    [self addSubview:_text];
  }
	return self;
}

- (id) initWithDefaultSize
{
    CGRect myRect = [[UIScreen mainScreen] bounds];
    widthLCDView=  myRect.size.width ;
    heightLCDView= myRect.size.height ;
    
  CGRect rect = CGRectMake(0.0f, 0.0f, widthLCDView, heightLCDView*.2);
  return [self initWithFrame: rect];
}

- (void)dealloc 
{
  [_label release];
  [_text release];
  [_image release];
	[super dealloc];
}

- (void) setLabel: (NSString *)label
{
  _label.text = label;
}
- (void) setText: (NSString *)text
{
  _text.text = text;
}

- (void) setSubImage: (UIImage *)image
{
  // TODO Resize text and label if image is defined
  [_image.image release];
  _image.image = image;
  [_image.image retain];
  if (image == nil)
  {
    _label.textAlignment = UITextAlignmentCenter;
    _text.textAlignment = UITextAlignmentCenter;
  }
  else
  {
    _label.textAlignment =  UITextAlignmentLeft;
    _text.textAlignment =  UITextAlignmentLeft;
  }
}

@end
