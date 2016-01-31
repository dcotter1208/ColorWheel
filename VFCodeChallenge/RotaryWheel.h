//
//  RotaryWheel.h
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryProtocol.h"
#import "Sector.h"
#import "WheelColor.h"


@interface RotaryWheel : UIControl

//These properties keep track of the delegate to notify when the user selects a section, the container view that the rotary wheel will be inside, and the number of sections in the rotary view.

@property (weak) id <RotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;

//This is needed to save the transform when the user taps on the component.
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;

@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, retain) NSMutableArray *sliceArray;
@property (nonatomic, retain) NSMutableArray *colorsArray;
@property (nonatomic, strong) WheelColor *wheelColor;

//This method will be called from the view controller to initialize the component.
-(id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;


@end
