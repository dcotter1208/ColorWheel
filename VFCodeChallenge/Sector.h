//
//  Sector.h
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Sector : NSObject

@property float minValue;
@property float maxValue;
@property float midValue;
@property int sectorNumber;
@property UIColor *sectorColor;

@end