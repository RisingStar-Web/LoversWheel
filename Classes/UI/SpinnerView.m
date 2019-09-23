//
//  SpinnerView.m
//  Wheel
//
//  Created by Alec Bettinson on 25/09/2012.
//  Copyright (c) 2012 Alec Bettinson. All rights reserved.
//

#import "SpinnerView.h"

#define kRadius				(iPad ? 410 : 150)
#define kNameLabelWidth		(iPad ? 140 : 80)
#define kNameLabelHeight	(iPad ? 34 : 16)

@interface SpinnerView()

@property (nonatomic, strong) UIImageView *spinnerImageView;
@property (nonatomic, strong) UIView *labelsView;

@property (nonatomic, strong) NSMutableArray *segmentTextArray;
@property (nonatomic, strong) NSMutableArray *segmentDescriptionArray;
@property (nonatomic, strong) NSMutableArray *textLabelsArray;

@property (nonatomic, assign) int pickedIndex;

@property (nonatomic, assign) BOOL wheelSpinning;
@property (nonatomic, assign) BOOL wheelSlowing;
@property (nonatomic, assign) BOOL canCallbackOutcome;

@property (nonatomic, strong) NSTimer *animationSlowTimer;

- (void)animationSlowing;

- (void)setupWheelLabels;
- (void)drawWheelLabels;

@end

@implementation SpinnerView

- (id)initWithSegmentText:(id)textObject
{
    self = [super init];
    if (self) {
        // Initialization code
        self.segmentTextArray = [[NSMutableArray alloc] init];
        self.segmentDescriptionArray = [[NSMutableArray alloc] init];
        
        if([textObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *textDict = (NSDictionary *)textObject;
            
            for(NSString *key in textDict)
            {
                [self.segmentTextArray addObject:key];
                [self.segmentDescriptionArray addObject:[textDict objectForKey:key]];
            }
        }
        else if([textObject isKindOfClass:[NSArray class]])
        {
            NSArray *textArray = (NSArray *)textObject;
            
            for(NSString *text in textArray)
            {
                [self.segmentTextArray addObject:text];
            }
        }
        
        self.spinnerImageView = [[UIImageView alloc] init];
        self.spinnerImageView.image = [UIImage imageNamed:@"Wheel.png"];
        self.spinnerImageView.frame = CGRectMake(0, 0, 500, 500);
        self.spinnerImageView.layer.anchorPoint = CGPointMake(0.5004, 0.5008);
        [self addSubview:self.spinnerImageView];
        
        self.textLabelsArray = [[NSMutableArray alloc] init];
        
        self.labelsView = [[UIView alloc] init];
        self.labelsView.backgroundColor = [UIColor clearColor];
        self.labelsView.frame = CGRectMake(0, 0, self.spinnerImageView.image.size.width, self.spinnerImageView.image.size.height);
        [self addSubview:self.labelsView];
        
        [self setupWheelLabels];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setupWheelLabels {
	for (int i=0; i < [self.segmentTextArray count]; i++)
    {
		UILabel *nameLabel = [[UILabel alloc] init];
        
        nameLabel.text = [self.segmentTextArray objectAtIndex:i];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        nameLabel.adjustsFontSizeToFitWidth = YES;
		[self.labelsView addSubview:nameLabel];
		[self.textLabelsArray addObject:nameLabel];
	}
	
	[self drawWheelLabels];
}

- (void)drawWheelLabels {
	int count = 0;
    
    float modifier = -7.0f;
    
	for (UILabel *lbl in self.textLabelsArray)
	{
        int radius = self.labelsView.frame.size.width / 2 - 105;
        
        float angle = (102 + (360 / [self.textLabelsArray count]) * count);
        CGPoint center = CGPointMake(185, 235);
        
        angle += modifier;
        modifier += 0.37;

        float x = center.x + radius * cos((180+angle)/ 180.0 * M_PI);
        float y = center.y + radius * sin((180+angle)/ 180.0 * M_PI);
        
        [lbl setFrame:CGRectMake(x, y, 130, 30)];
        
        angle -= 1;
        lbl.transform = CGAffineTransformMakeRotation(angle / 180.0 * M_PI);
        count++;
	}
}

- (void)spinWheelWithDirection:(kWheelDirection)wheelDirection {
    _canCallbackOutcome = YES;
    
    _wheelDirection = wheelDirection;
    
    int numberOfSegments = [self.segmentTextArray count];
    int chosenTextIndex = 1 + arc4random() % numberOfSegments;
    
    self.pickedIndex = chosenTextIndex - 1;
    
    NSNumber *totalRotation = nil;
    
    int ipadModifier = iPad ? -3 : -2;
    float rotationModifier = 0;
    float segmentAngle = 0;

    
    if(wheelDirection == kWheelDirectionClockwise)
    {
        segmentAngle = -(((M_PI / numberOfSegments ) * 2 ) * chosenTextIndex);
        rotationModifier = (280 - ipadModifier) / 180.0 * M_PI;
        totalRotation = [NSNumber numberWithFloat:(M_PI * 2.0 * 3) + (segmentAngle + rotationModifier)];
    }
    else
    {
        segmentAngle = ((M_PI / numberOfSegments ) * 2 ) * chosenTextIndex;
        rotationModifier = (80 + ipadModifier) / 180.0 * M_PI;
        totalRotation = [NSNumber numberWithFloat:-((M_PI * 2.0 * 3) + (rotationModifier + segmentAngle))];
    }
    
    CFTimeInterval duration = 3.0f;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = totalRotation;
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
	rotationAnimation.fillMode = kCAFillModeForwards;
	rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = 1.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.delegate = self;
    [self.spinnerImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self.labelsView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    if(self.animationSlowTimer != nil || [self.animationSlowTimer isValid])
    {
        [self.animationSlowTimer invalidate];
        self.animationSlowTimer = nil;
    }
    
    self.animationSlowTimer = [NSTimer scheduledTimerWithTimeInterval:duration - 1.0f target:self selector:@selector(animationSlowing) userInfo:nil repeats:NO];
    
    _wheelSpinning = YES;
    _wheelSlowing = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(_canCallbackOutcome)
    {
        [self.delegate spinnerDidSpinWithOutcome:[self textForPickedSegment] andDescription:[self descriptionForPickedSegment]];
        _wheelSpinning = NO;
    }
    
    _canCallbackOutcome = NO;
}


- (NSString *)textForPickedSegment {
    return [self.segmentTextArray objectAtIndex:self.pickedIndex];
}

- (NSString *)descriptionForPickedSegment {
    if ([self.segmentDescriptionArray count] > 0)
        return [self.segmentDescriptionArray objectAtIndex:self.pickedIndex];
    
    return nil;
}

- (BOOL)isSpinning {
    return _wheelSpinning;
}

- (BOOL)isSlowing {
    return _wheelSlowing;
}

- (void)animationSlowing {
    _wheelSlowing = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
