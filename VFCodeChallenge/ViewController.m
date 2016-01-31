//
//  ViewController.m
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "ViewController.h"
#import "RotaryWheel.h"

RotaryWheel *colorWheel;

@interface ViewController ()



@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger numberOfSections = colorWheel.colorsArray.count;
    NSLog(@"%lu", (unsigned long)colorWheel.colorsArray.count);
    int castInt = (int)numberOfSections;
    NSLog(@"castInt: %i", castInt);
    //Set up rotary wheel
    RotaryWheel *wheel = [[RotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 200, 200) andDelegate:self withSections:8];
    
    wheel.center = [super.view center];
    //Add wheel to view
    [self.view addSubview:wheel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
