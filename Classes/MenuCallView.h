
#import <UIKit/UIKit.h>
#import "PushButton.h"

@protocol MenuCallViewDelegate;

@interface MenuCallView : UIView 
{
  PushButton *_buttons[6];
  id<MenuCallViewDelegate> delegate;
}

@property (nonatomic, retain)  id<MenuCallViewDelegate> delegate;

- (PushButton *)buttonAtPosition:(NSInteger)button;
- (void)setTitle:(NSString *)title image:(UIImage *)image forPosition:(NSInteger)pos;

@end
@protocol MenuCallViewDelegate <NSObject>
- (void)menuButtonClicked:(NSInteger)button;
@end
