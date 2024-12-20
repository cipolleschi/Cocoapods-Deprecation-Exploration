//
//  Dummy.m
//  ReactNativeFramework
//
//  Created by Riccardo Cipolleschi on 03/12/2024.
//

#import "Dummy.h"
#import <react/renderer/RCTReactRenderer.h>

@implementation Dummy

- (void)render {
  auto renderer = Renderer();
  int result = renderer.render(std::string("tree"));
  NSLog(@"Result is %d", result);
}

@end
