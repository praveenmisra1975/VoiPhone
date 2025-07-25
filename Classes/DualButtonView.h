
#import <UIKit/UIKit.h>

@protocol DualButtonViewDelegate;

@interface DualButtonView : UIView 
{
  UIButton *_buttons[2];
  id<DualButtonViewDelegate> delegate;
}

@property (nonatomic, retain)  id<DualButtonViewDelegate> delegate;

- (UIButton *)buttonAtPosition:(NSInteger)button;
- (void)setTitle:(NSString *)title image:(UIImage *)image forPosition:(NSInteger)pos;

@end

@protocol DualButtonViewDelegate <NSObject>
- (void)buttonClicked:(NSInteger)button;
@end
