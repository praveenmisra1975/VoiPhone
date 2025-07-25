
#import <UIKit/UIKit.h>

int main(int argc, char **argv)
{
  int returnCode = 0;
  NSAutoreleasePool *autoreleasePool;

  autoreleasePool = [[ NSAutoreleasePool alloc ] init];

  returnCode = UIApplicationMain( argc, argv, @"SiphonApplication", @"SiphonApplication" );
  [ autoreleasePool release ];

  return returnCode;
}

