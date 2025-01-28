//
//  ViewController.m
//  ReactNativeApp
//
//  Created by Riccardo Cipolleschi on 28/01/2025.
//

#import "ViewController.h"
#import <ReactNative/react/renderer/ReactRenderer.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor redColor];
//  
  auto renderer = Renderer();
  renderer.render();
}


@end
