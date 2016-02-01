//
//  ViewController.h
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelColor.h"
#import "Sector.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface ViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *colorSections;
@property (nonatomic, strong) WheelColor *wheelColor;
@property (nonatomic, strong) Sector *sector;

@end

