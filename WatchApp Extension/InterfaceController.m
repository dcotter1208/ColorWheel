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

    
    
    
//    [[self messageLabel] setText:message[@"a"]];
    NSLog(@"MESSAGE RECEIVED: %@", message);
}

@end



