//
//  WinnerView.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 30/08/2012.
//  Copyright (c) 2012 Taptastic Apps. All rights reserved.
//

#import "WinnerView.h"

#define kLabelFontSize  (iPad? 42 : 24)
#define kLabelY         (iPad? 70 : 48)
#define kLabelWidth     (iPad? 250 : 150)
#define kLabelHeight    (iPad? 90 : 50)
#define kShadowSize     (iPad? 4 : 3)

@interface WinnerView()

@property (strong) UILabel *nameLabel;

@end

@implementation WinnerView

- (id) initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
		//self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        self.userInteractionEnabled = NO;
        self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeScaleAspectFit;
        
        self.background = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"WinnerBanner.png"]];
        self.background.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.background.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.background];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.text = name;
        self.nameLabel.textColor = rgb(238, 221, 194);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont fontWithName:@"debussy" size:kLabelFontSize];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.layer.shadowOffset = CGSizeMake(0, kShadowSize);
        self.nameLabel.layer.shadowColor = rgb(146, 4, 5).CGColor;
        self.nameLabel.layer.shadowRadius = 0.0;
        self.nameLabel.layer.shadowOpacity = 1.0;
		
		self.nameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.background.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.nameLabel.frame = CGRectMake((self.frame.size.width-kLabelWidth)/2, kLabelY, kLabelWidth, kLabelHeight);
}

@end
