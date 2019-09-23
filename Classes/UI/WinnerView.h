//
//  WinnerView.h
//  SpinTheBottle
//
//  Created by Matt Davenport on 30/08/2012.
//  Copyright (c) 2012 Taptastic Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinnerView : UIView

@property (strong) UIImageView *background;

- (id) initWithName:(NSString *)name;

@end
