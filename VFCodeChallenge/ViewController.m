//
//  ViewController.m
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "ViewController.h"
#import "RotaryWheel.h"
#import "WheelColor.h"

RotaryWheel *colorWheel;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wheelColor = [[WheelColor alloc]init];
    int wheelColorArrayCount = (int)self.wheelColor.colorArray.count;

    //Set up rotary wheel
    RotaryWheel *wheel = [[RotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 200, 200) andDelegate:self withSections:wheelColorArrayCount];
    
    wheel.center = [super.view center];
    //Add wheel to view
    [self.view addSubview:wheel];

}

- (void) wheelDidChangeColor:(NSString *)newValue {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
