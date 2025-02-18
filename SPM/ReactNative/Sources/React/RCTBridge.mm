#import "RCTBridge.h"

@implementation RCTBridge

- (void)loadModule:(NSString *)name
{
  NSLog(@"Loading module %@...", name);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSLog(@"Module %@ loaded!", name);
  });
}

@end
