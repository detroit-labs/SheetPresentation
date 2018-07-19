//
//  ChildViewController.m
//  LegacyExample
//
//  Created by Jeff Kelley on 7/19/18.
//  Copyright © 2018 Detroit Labs. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
