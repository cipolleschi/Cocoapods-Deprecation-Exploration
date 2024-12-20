//
//  ViewController.m
//  ReactNativeApp
//
//  Created by Riccardo Cipolleschi on 02/12/2024.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor systemOrangeColor];
  UITextField *tf = [UITextField new];
  [self.view addSubview:tf];
  tf.keyboardType = UIKeyboardTypeEmailAddress;
  tf.borderStyle = UITextBorderStyleLine;
  tf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
  
  [tf setTranslatesAutoresizingMaskIntoConstraints:NO];
  [NSLayoutConstraint activateConstraints:@[
    [tf.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
    [tf.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
    [tf.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    [tf.heightAnchor constraintEqualToConstant:50]
  ]];
  
  
}


@end
