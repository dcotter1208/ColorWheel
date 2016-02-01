//
//  RotaryWheel.m
//  VFCodeChallenge
//
//  Created by Donovan Cotter on 1/28/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

#import "RotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import <WatchConnectivity/WatchConnectivity.h>


#define DEG2RAD(angle) angle*M_PI/180.0

@interface RotaryWheel () <WCSessionDelegate>
//added a private method called drawWheel
    -(void)drawWheel;

//Helper method to ignore taps too close to the center of the wheel, by preventing the dispatch of any event when such taps occur.
    - (float) calculateDistanceFromCenter:(CGPoint)point;

    //Two helper method definitions to build the sectors
    -(void) buildSectorsEven;
    -(void) buildSectorsOdd;

@end

//To save the angle when the user touches the component, we add a static variable of type float
static float deltaAngle;


@implementation RotaryWheel

//@synthesize will generate getter and setter methods for your property.

//synthesized the three properties and defined initWithFrame:andDelegate:withSections: where the parameters are saved in the properties and the drawWheel method is called to draw the wheel.
@synthesize delegate, container, numberOfSections;
@synthesize startTransform;
@synthesize sectors;
@synthesize currentSector;
@synthesize currentSectorColor;

-(id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
//1 Call super init
    if ((self = [super initWithFrame: frame])) {
        //2 set properties
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
        
        self.wheelColor = [[WheelColor alloc]init];

        //3 Draw Wheel
        
        [self drawWheel];
        
        //Activate WCSession for watch connectivity.
        [self activateWCSession];
        
    }
    return self;
}

-(void) drawWheel {

    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
    bg.image = [UIImage imageNamed:@"bg.png"];
    [self addSubview:bg];
    
    CGPoint circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    //1 Create a view that we’ll put everything else inside.
    container = [[UIView alloc] initWithFrame:self.frame];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 100.0;
    container.layer.borderColor = [UIColor clearColor].CGColor;
    container.layer.borderWidth = 1.0;

    CGFloat angleSize = 2*M_PI/numberOfSections;

    for (int i = 0; i < numberOfSections; i++) {
        
        CAShapeLayer *slice = [CAShapeLayer layer];
        
        UIColor *color;
        color = [self.wheelColor.colorArray objectAtIndex:i];
        
        slice.strokeColor = [UIColor whiteColor].CGColor;
        slice.lineWidth = 3.0;
        slice.fillColor = color.CGColor;
        CGPoint center = CGPointMake(100.0, 100.0);
        CGFloat radius = self.container.frame.size.width - 20.0;
        CGFloat startAngle = angleSize * i;
        
        UIBezierPath *piePath = [UIBezierPath bezierPath];
        [piePath moveToPoint:center];
        [piePath addLineToPoint:circleCenter];
        [piePath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:startAngle + angleSize clockwise:YES];
        [piePath closePath]; // this will automatically add a straight line to the center
        slice.path = piePath.CGPath;
        
        [container.layer addSublayer:slice];
  
    }

    //7 Adds the container to the main control.
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    //8 Initialize sectors
    sectors = [NSMutableArray arrayWithCapacity:numberOfSections];
    if (numberOfSections % 2 == 0) {
        [self buildSectorsEven];
//        NSLog(@"Sector Count: %lu", self.sectors.count);
    } else {
        [self buildSectorsOdd];
//        NSLog(@"Sector Count: %lu", self.sectors.count);
    }

}

// MARK: Rotation Methods

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    //1 Get touch position
    CGPoint touchPoint = [touch locationInView:self];
    //1.1 Get the distance from the center
    float distance = [self calculateDistanceFromCenter:touchPoint];
    //1.2 This way, when taps are too close to the center, the touches are simply ignored because you return a NO, indicating that the component is not handling that touch.
    if (distance < 40) {
//        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    //2 Calculate distance from center
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y = container.center.y;
    
    //3 Calculate arctangent value - you get the arctangent value and save the current transform so that you have an initial reference point when the user starts dragging the wheel.
    deltaAngle = atan2f(dy, dx);
    startTransform = container.transform;
    
    //return YES from the method because the wheel is also meant to respond when a touch is dragged
    return YES;

}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGFloat radians = atan2f(container.transform.b, container.transform.a);
//    NSLog(@"rad is %f", radians);
    
    //the radian calculation is pretty similar to what we did in beginTrackingWithTouch
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x - container.center.x;
    float dy = pt.y - container.center.y;
    float angle = atan2(dy, dx);
    float angleDifference = deltaAngle - angle;
    //the code specifies -angleDifference to compensate for the fact that values might be in the negative quadrant.
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);

    return YES;
}

//The method calculates the current value of radians and compares it to min and max values to find the right sector. Then it finds the difference and builds a new CGAffineTransform. To make the effect look natural, the setting of the rotation is wrapped in an animation lasting 0.2 seconds.
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    //1 Get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    //2 Initialize new value
    CGFloat newVal = 0.0;
    //3 - Iterate through all the sectors
    for (Sector *s in sectors) {
        //4 See if the current sector contains the radian value
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                //5 Find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                currentSector = s.sectorNumber;
                self.currentSectorColor = s.sectorColor;
            }
            
        } else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            currentSector = s.sectorNumber;
            self.currentSectorColor = s.sectorColor;
//            NSLog(@"CURRENT SECTOR: %i", currentSector);
            
        }
        
    }
    
//7 set up animation for final rotation
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform transform = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = transform;
    [UIView commitAnimations];
    
    UIColor *currentColor = self.currentSectorColor;
    [self.delegate wheelDidChangeColor:currentColor];
    
    int colorHashValue = (int)currentColor.hash;
    
    NSString *colorHashStringValue = [NSString stringWithFormat:@"%d", colorHashValue];

    NSLog(@"COLOR STRING VALUE: %@", colorHashStringValue);
    
    int backStringBackToInt = [colorHashStringValue intValue];
    NSLog(@"BACK TO INT: %i", backStringBackToInt);

    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    
    [session sendMessage:@{@"color":colorHashStringValue} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
        NSLog(@"Phone Message Sent - RotaryWheel");
        
    } errorHandler:^(NSError * _Nonnull error) {
        
        NSLog(@"Error sending the message - RotaryWheel");
        
    }];
    
  
}

//This just measures how far the tap point is from the center
-(float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrtf(dx*dx + dy*dy);

}

-(void) buildSectorsOdd {
    //1 - Identify the length (or the width) of the sector in radians.
    CGFloat fanWidth = M_PI*2/numberOfSections;
    
    //2 Initialize a variable with the initial midpoint. Since our starting point is always zero radians, that becomes our first midpoint.
    CGFloat mid = 0;
    
    //3 Then we iterate through each of the sectors to set up the min, mid, and max values for each sector
    for (int i = 0; i < numberOfSections; i++) {
        Sector *sector = [[Sector alloc] init];
        
        //4 When calculating the min and max values, you add/subtract half of the sector width to get the correct values. Remember that your range is from -pi to pi, so everything has to be “normalized” between those values. If a value is greater than pi or –pi, that means you’ve changed quadrant. Since you’ve populated the wheel clockwise, you have to take into account when the minimum value is less than pi, and in that case change the sign of the midpoint.
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sectorNumber = i;
        sector.sectorColor = [self.wheelColor.colorArray objectAtIndex:i];
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
//        NSLog(@"Sector: %@", sector);

        //5 Add sector to the 'sectors' array
        [sectors addObject: sector];
//        NSLog(@"Sector: %i", sector.sectorNumber);
//        NSLog(@"Sector: %@", sector.sectorColor);
    }
    
}

-(void) buildSectorsEven {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < numberOfSections; i++) {
        Sector *sector = [[Sector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sectorNumber = i;
        sector.sectorColor = [self.wheelColor.colorArray objectAtIndex:i];
        
        //The main difference from the buildSectorsOdd method is that in this instance pi (or -pi if you move counterclockwise) is not a max or min point, but it coincides with a midpoint. So you have to check if, by subtracting the sector width from the max value, you pass the -pi limit, and if you do, set the min value as positive.
        
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
        }
        
        mid -= fanWidth;
//        NSLog(@"Sector: %@", sector);
        // 5 - Add sector to array
        [sectors addObject:sector];
//        NSLog(@"Sector: %i", sector.sectorNumber);
//        NSLog(@"Sector: %@", sector.sectorColor);
        

    }
    
}

-(void) createSector {
    
    for (int i = 0; i < numberOfSections; i++) {
        
        CAShapeLayer *slice = [CAShapeLayer layer];
        slice.fillColor = [UIColor yellowColor].CGColor;
        slice.strokeColor = [UIColor blackColor].CGColor;
        slice.lineWidth = 1.0;
        
        CGFloat startValue = 0.00;
        for (int k = 0; k < i; k++) {
            startValue = startValue + .25;
        }
        CGFloat startAngle = startValue * 2 * M_PI - M_PI/2;
        
        // Determine end angle
        CGFloat endValue = .25;
        for (int j = (int)i; j >= 0; j--) {
            endValue = endValue + .25;
        }
        CGFloat endAngle = endValue * 2 * M_PI - M_PI/2;
        
        CGPoint center = CGPointMake(100.0, 100.0);
        CGFloat radius = 100.0;
        
        UIBezierPath *piePath = [UIBezierPath bezierPath];
        [piePath moveToPoint:center];
        [piePath addLineToPoint:CGPointMake(center.x + radius * cosf(startAngle), center.y + radius * sinf(endAngle))];
        [piePath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [piePath closePath]; // this will automatically add a straight line to the center
        slice.path = piePath.CGPath;
//        NSLog(@"START ANGLE: %f", startAngle);
//        NSLog(@"END ANGLE: %f", endAngle);

        [container.layer addSublayer:slice];
    }
}

-(void)activateWCSession {
    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    
    //THIS IS WHERE WE SET UP THAT THE BUTTON ON THE WATCH TAPPED AND COLOR CHANGED AND THAT IS WHEN THE WHEEL SHOULD CHANGE.
    
}





@end
