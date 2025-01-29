//
//  ViewController.m
//  CMakeApp
//
//  Created by Riccardo Cipolleschi on 29/01/2025.
//

#import "ViewController.h"
#import <react/renderer/ReactRenderer.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  auto renderer = Renderer();
  renderer.render();
  
}


@end
