//
//  Sector.m
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "Sector.h"

@implementation Sector

@synthesize minValue, maxValue, midValue, sectorNumber;

- (NSString *) description {
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.sectorNumber, self.minValue, self.midValue, self.maxValue];
}

@end
