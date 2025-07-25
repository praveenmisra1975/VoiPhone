
#import <UIKit/UIKit.h>

@protocol PhonePadDelegate;

@interface PhonePad : UIControl
{
  id<PhonePadDelegate> _delegate;
  int _downKey;
  
  UIImage *_keypadImage;
  UIImage *_pressedImage;
  
  CGFloat _topHeight, _midHeight, _bottomHeight;
  CGFloat _leftWidth, _midWidth, _rightWidth;
  
  CFDictionaryRef _keyToRect;
  BOOL _soundsActivated;
}

- (id)initWithFrame:(CGRect)rect;

- (UIImage*)keypadImage;
- (UIImage*)pressedImage;

- (void)handleKeyDown:(id)sender forEvent:(UIEvent *)event;
- (void)handleKeyUp:(id)sender forEvent:(UIEvent *)event;
- (void)handleKeyPressAndHold:(id)sender;
- (int)keyForPoint:(CGPoint)point;
- (CGRect)rectForKey:(int)key;
- (void)drawRect:(CGRect)rect;

- (void)setNeedsDisplayForKey:(int)key;

- (void)setPlaysSounds:(BOOL)activate;
- (void)playSoundForKey:(int)key;

@property (nonatomic, retain) id<PhonePadDelegate> delegate;

@end

@protocol PhonePadDelegate <NSObject>

@optional
- (void)phonePad:(id)phonepad appendString:(NSString *)string;
- (void)phonePad:(id)phonepad replaceLastDigitWithString:(NSString *)string;

- (void)phonePad:(id)phonepad keyDown:(char)car;
- (void)phonePad:(id)phonepad keyUp:(char)car;
@end
