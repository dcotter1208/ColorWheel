//
//  InterfaceController.h
//  WatchApp Extension
//
//  Created by Donovan Cotter on 2/1/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface InterfaceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *colorButton;

@end
