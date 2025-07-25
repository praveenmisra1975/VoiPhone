
#import "BottomBar.h"


@implementation BottomBar

CGFloat widthBottomBar;
CGFloat heighBottomBar;



- (id)initWithDefaultSize
{
    CGRect myRect = [[UIScreen mainScreen] bounds];
    widthBottomBar=  myRect.size.width ;
    heighBottomBar= myRect.size.height ;
    
    
    
    CGRect rect = CGRectMake(0.0f, (heighBottomBar*.95) - (heighBottomBar*.20) ,widthBottomBar, heighBottomBar*.20);
    
  return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
    {
        UIGraphicsBeginImageContext(frame.size);
        [[UIImage imageNamed:@"lcd_call_bottom.png"] drawInRect:self.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        
        // Initialization code
      
      self.alpha = 0.7f;
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}


@end
