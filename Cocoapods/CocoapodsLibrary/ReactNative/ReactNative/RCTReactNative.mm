//
//  RCTReactNative.m
//  ReactNative
//
//  Created by Riccardo Cipolleschi on 28/01/2025.
//

#import "RCTReactNative.h"
#import <ReactNativeRenderer/ReactRenderer.h>

@implementation RCTReactNative

-(void)render
{
  auto renderer = Renderer();
  renderer.render();
}

@end
