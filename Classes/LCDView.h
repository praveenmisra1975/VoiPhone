
#import <UIKit/UIKit.h>

#import "AbsLCDView.h"

@interface LCDView : AbsLCDView
{
  UILabel *_label;
  UILabel *_text;
  UIImageView *_image;
}

//@property (nonatomic, retain) UIImageView *image;

- (id) initWithDefaultSize;
- (void) setLabel: (NSString *)label;
- (void) setText: (NSString *)text;
- (void) setSubImage: (UIImage *)image;
@end
