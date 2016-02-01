
//
//  WheelColor.m
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/31/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "WheelColor.h"

@implementation WheelColor

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    _colorArray = [[NSMutableArray alloc] initWithObjects: [UIColor redColor], [UIColor yellowColor], [UIColor purpleColor], [UIColor blueColor], [UIColor orangeColor], [UIColor brownColor], [UIColor greenColor], [UIColor blackColor], nil];
        
    }
    
    return self;
}


@end
