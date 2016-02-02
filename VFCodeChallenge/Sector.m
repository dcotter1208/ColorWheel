//
//  Sector.m
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "Sector.h"

@implementation Sector

- (NSString *) description {
    return [NSString stringWithFormat:@"%i | %f, %f, %f", _sectorNumber, _minValue, _midValue, _maxValue];
}

@end
