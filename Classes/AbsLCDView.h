
#import <UIKit/UIKit.h>


@interface AbsLCDView : UIView 
{
  UILabel *_topLabel;
  UILabel *_leftLabel;
  UILabel *_rightLabel;
  UIScrollView *_scrollView;
}

//- (void)displayState:(NSString *)state animated:(BOOL)animated;
//- (NSString *)text;
//- (void)setText:(NSString *)text;
- (void)topText:(NSString *)text;
- (void)rightText:(NSString *)text;
- (void)leftText:(NSString *)text;

@end
