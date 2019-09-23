//
//  GameViewController.h
//  Wheel
//
//  Created by Alec Bettinson on 25/09/2012.
//  Copyright (c) 2012 Alec Bettinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface GameViewController : UIViewController <SpinnerViewDelegate, UIGestureRecognizerDelegate>

- (id)initWithWheelText:(id)wheelText;

@property (nonatomic, assign) BOOL canShowDescription;

@end
