//
//  RotaryProtocol.h
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

//This defines a protocol to be used by the SMRotaryWheel Class.

#import <Foundation/Foundation.h>

@protocol RotaryProtocol <NSObject>

//The method that will be called called whenever the user lifts their finger from the screen. It indicates a new selection has been made from the menu.

- (void) wheelDidChangeColor:(NSString *)newValue;


@end
