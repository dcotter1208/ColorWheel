//
//  ViewController.m
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "ViewController.h"
#import "RotaryWheel.h"
#import "WheelColor.h"
#import "Sector.h"
#import <WatchConnectivity/WatchConnectivity.h>

RotaryWheel *colorWheel;

@interface ViewController () <WCSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelOutlet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    
    self.sector = [[Sector alloc]init];
    self.wheelColor = [[WheelColor alloc]init];
    int wheelColorArrayCount = (int)self.wheelColor.colorArray.count;

    //Set up rotary wheel
    RotaryWheel *wheel = [[RotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 200, 200) andDelegate:self withSections:wheelColorArrayCount];
    
    wheel.center = [super.view center];
    //Add wheel to view
    [self.view addSubview:wheel];

}

- (void) wheelDidChangeColor:(UIColor *)newValue {
//    UIColor *currentSectorColor = self.sector.sectorColor;

    NSLog(@"NEW VALUE: %@", newValue);
    
    self.labelOutlet.backgroundColor = newValue;
    
//    WCSession* session = [WCSession defaultSession];
//    session.delegate = self;
//    [session activateSession];
//    
//    
//    [session sendMessage:@{@"color":@"TESTFROMVC"} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
//        
//        NSLog(@"Phone Message Sent - FROM ViewController");
//        
//    } errorHandler:^(NSError * _Nonnull error) {
//        
//        NSLog(@"Error SENDING MESSAGE TO WATCH - ViewController");
//        NSLog(@"%@",error);
//        
//    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.labelOutlet.text = message[@"b"];
        NSLog(@"MESSAGE FROM WATCH SETS LABEL TO: %@",message);
    });
    
}

@end
