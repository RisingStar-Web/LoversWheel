//
//  SpinnerView.h
//  Wheel
//
//  Created by Alec Bettinson on 25/09/2012.
//  Copyright (c) 2012 Alec Bettinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpinnerViewDelegate <NSObject>

- (void)spinnerDidSpinWithOutcome:(NSString *)outcome andDescription:(NSString *)description;

@end

@interface SpinnerView : UIView

typedef enum {
    kWheelDirectionClockwise,
    kWheelDirectionAnticlockwise
}kWheelDirection;

@property (nonatomic, unsafe_unretained) id<SpinnerViewDelegate> delegate;
@property (nonatomic, assign) kWheelDirection wheelDirection;

- (id)initWithSegmentText:(id)textObject;

- (void)spinWheelWithDirection:(kWheelDirection)wheelDirection;

- (NSString *)textForPickedSegment;
- (NSString *)descriptionForPickedSegment;

- (BOOL)isSpinning;
- (BOOL)isSlowing;

@end
