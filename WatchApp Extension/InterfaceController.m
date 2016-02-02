//
//  InterfaceController.m
//  WatchApp Extension
//
//  Created by Donovan Cotter on 2/1/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>


@interface InterfaceController() <WCSessionDelegate>

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)sendMessage {
    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    [session sendMessage:@{@"b":@"goodBye"} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
        NSLog(@"W - Message Sent");
        
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"WATCH message not sent");

        
    }];
    
}

- (void) session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler{

    
    NSString *stringColorSentFromPhone = [message valueForKey:@"color"];
    int colorStringBackToInt = [stringColorSentFromPhone intValue];
    
    switch (colorStringBackToInt) {
        case 65536:
            [_colorButton setBackgroundColor:[UIColor blackColor]];
            break;
        case 11141120:
            [_colorButton setBackgroundColor:[UIColor greenColor]];
            break;
        case 149585920:
            [_colorButton setBackgroundColor:[UIColor orangeColor]];
            break;
        case 917504:
            [_colorButton setBackgroundColor:[UIColor blueColor]];
            break;
        case 72482816:
            [_colorButton setBackgroundColor:[UIColor purpleColor]];
            break;
        case 155123712:
            [_colorButton setBackgroundColor:[UIColor yellowColor]];
            break;
        case 144048128:
            [_colorButton setBackgroundColor:[UIColor redColor]];
            break;
        case 91054330:
            [_colorButton setBackgroundColor:[UIColor brownColor]];
            break;
        default:
            break;
    }

    NSLog(@"MESSAGE RECEIVED FROM PHONE: %@", message);
}

@end



