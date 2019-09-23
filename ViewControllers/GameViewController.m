//
//  GameViewController.m
//  Wheel
//
//  Created by Alec Bettinson on 25/09/2012.
//  Copyright (c) 2012 Alec Bettinson. All rights reserved.
//

#import "GameViewController.h"
#import "SpinnerView.h"
#import "WinnerView.h"
#import "AboutUsViewController.h"
#import "DescriptionView.h"

@interface GameViewController ()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *overlay;

@property (nonatomic, strong) SpinnerView *spinner;
@property (nonatomic, strong) UIImageView *pointer;

@property (nonatomic, strong) UIButton *infoButton;

@property (nonatomic, strong) id wheelTextObj;

@property (nonatomic, assign) float pointerDuration;

@property (nonatomic, assign) BOOL canSpin;

- (void)layout;

- (void)spin;

- (void)infoPressed;

- (void)flickPointer;

- (void)swiped:(UISwipeGestureRecognizer *)recognizer;

- (void)showDescriptionBoxWithTitle:(NSString *)title andDescription:(NSString *)description;
- (void)hideDescriptionBox;

- (void)logSpin;

- (BOOL)isTall;

@end

@implementation GameViewController

- (id)initWithWheelText:(id)wheelText
{
    self.wheelTextObj = wheelText;
    
    self = [super init];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spin)];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    [downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downRecognizer];
    
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    [upRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:upRecognizer];
    
    _canSpin = YES;
    
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   if(iPad)
       return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
    
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.infoButton.superview != nil) {
        if ([touch.view isDescendantOfView:self.infoButton]) {
            return NO;
        }
    }
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Layout

- (void)loadView {
    [super loadView];
    
    self.background = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"Background.png"]];
    [self.view insertSubview:self.background atIndex:0];
    
    self.spinner = [[SpinnerView alloc] initWithSegmentText:self.wheelTextObj];
    self.spinner.delegate = self;
    [self.view addSubview:self.spinner];
    
    self.pointer = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"pointerRight.png"]];
    [self.view addSubview:self.pointer];
    
    self.overlay = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"Overlay.png"]];
	self.overlay.userInteractionEnabled = NO;
	[self.view addSubview:self.overlay];
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.infoButton setBackgroundImage:[UIImage universalImageNamed:@"InfoBtn.png"] forState:UIControlStateNormal];
	[self.infoButton setBackgroundImage:[UIImage universalImageNamed:@"InfoBtnPushed.png"] forState:UIControlStateHighlighted];
	[self.infoButton addTarget:self action:@selector(infoPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.infoButton];
    
    [self layout];
}

- (void)layout {
    CGSize base = self.view.frame.size;
    
    self.background.frame = CGRectMake(0, 0, base.width, base.height);
    self.overlay.frame = CGRectMake(0, 0, base.width, base.height);
    
    if(iPad)
    {
        self.spinner.frame = CGRectMake(base.width / 2 - 252, base.height / 2 - 252, 505, 505);
        self.pointer.frame = CGRectMake(self.spinner.frame.origin.x - 120, self.spinner.frame.origin.y + (self.spinner.frame.size.height / 2 - 54), 170, 100);
//        self.infoButton.frame = CGRectMake(15, 15, self.infoButton.currentBackgroundImage.size.width, self.infoButton.currentBackgroundImage.size.height);
    }
    else
    {
        self.spinner.frame = CGRectMake(base.width - 230, base.height / 2 - 250, 505, 505);
        self.pointer.frame = CGRectMake(-30, base.height / 2 - 50, 170, 100);
//        self.infoButton.frame = CGRectMake(10, 10, self.infoButton.currentBackgroundImage.size.width, self.infoButton.currentBackgroundImage.size.height);
    }
}

- (void)infoPressed {
    AboutUsViewController *viewController = [[AboutUsViewController alloc] initWithView:self.view];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)showDescriptionBoxWithTitle:(NSString *)title andDescription:(NSString *)description {
    if([description length] == 0)
        return;
    
    CGSize base = self.view.frame.size;
	
    DescriptionView *v = [[DescriptionView alloc] initWithTitle:title andDescription:description];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDescriptionBox)];
    [v addGestureRecognizer:tapRecognizer];
    
    int width = iPad ? base.width / 2 : base.width - 20;
    
    v.frame = CGRectMake((base.width / 2 - ((base.width - 20) / 2)), base.height, width, 200);
    v.frame = CGRectMake((base.width - width) / 2, -[v heightOfBox], width, [v heightOfBox]);
    v.alpha = 0;
    [self.view addSubview:v];
	
	v.center = self.view.center;
	v.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveLinear
                     animations:^{
                         v.alpha = 1;
						 v.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2f
											   delay:0.0f
											 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveLinear
										  animations:^{
											  v.transform = CGAffineTransformMakeScale(0.9, 0.9);
										  }
										  completion:^(BOOL finished) {
											  [UIView animateWithDuration:0.15f
																	delay:0.0f
																  options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveLinear
															   animations:^{
																   v.transform = CGAffineTransformMakeScale(1.02, 1.02);
															   }
															   completion:^(BOOL finished) {
																   [UIView animateWithDuration:0.1f
																						 delay:0.0f
																					   options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveLinear
																					animations:^{
																						v.transform = CGAffineTransformMakeScale(0.99, 0.99);
																					}
																					completion:^(BOOL finished) {
																						[UIView animateWithDuration:0.05f
																											  delay:0.0f
																											options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationCurveLinear
																										 animations:^{
																											 v.transform = CGAffineTransformMakeScale(1, 1);
																										 }
																										 completion:nil];
																					}];
															   }];
										  }];
                     }];
    
}

- (void)hideDescriptionBox {
    if(self.canShowDescription)
    {
        for(UIView *v in self.view.subviews)
        {
            if([v isKindOfClass:[DescriptionView class]])
            {
                [UIView animateWithDuration:0.3
								 animations:^{
									 v.alpha = 0;
								 } completion:^(BOOL finished) {
									 [v removeFromSuperview];
								 }];
            }
        }
    }
}

#pragma mark Spin Methods

- (void)swiped:(UISwipeGestureRecognizer *)recognizer {
    
    [self hideDescriptionBox];
    
    if(_canSpin)
    {
        if(recognizer.direction == UISwipeGestureRecognizerDirectionDown)
        {
            [self.spinner spinWheelWithDirection:kWheelDirectionAnticlockwise];
        }
        else if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
        {
            [self.spinner spinWheelWithDirection:kWheelDirectionClockwise];
        }
        [self flickPointer];
        _canSpin = NO;
        
        [self logSpin];
    }
}

- (void)spin {
    
    [self hideDescriptionBox];
    
    if(_canSpin)
    {
        [self.spinner spinWheelWithDirection:kWheelDirectionAnticlockwise];
        [self flickPointer];
        _canSpin = NO;
    }
    
    [self logSpin];
}


- (void)logSpin {
}

- (void)spinnerDidSpinWithOutcome:(NSString *)outcome andDescription:(NSString *)description {
	if(self.canShowDescription)
        [self showDescriptionBoxWithTitle:outcome andDescription:description];
	
    
    [self.pointer.layer removeAllAnimations];
    self.pointer.transform = CGAffineTransformMakeRotation(0 / 180.0 * M_PI);
    
    _canSpin = YES;
	    
    if(self.canShowDescription)
        return;
	
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    WinnerView *winnerView = [[WinnerView alloc] initWithName:outcome];
    CGSize bgSize = winnerView.background.image.size;
    winnerView.frame = CGRectMake(center.x-(bgSize.width/2), -bgSize.height, bgSize.width, bgSize.height);
    winnerView.alpha = 0;
    [self.view addSubview:winnerView];
    
    int modifier = 0;
    
    if(![self isTall] && !iPad)
    {
        modifier = -50;
        
        if(!self.canShowDescription)
            modifier = 0;
    }
    

    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         winnerView.frame = CGRectMake(center.x-(bgSize.width/2), center.y-(bgSize.height/2) + modifier, bgSize.width, bgSize.height);
                         winnerView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.4
                                               delay:1.5
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              winnerView.frame = CGRectMake(center.x-(bgSize.width/2), -bgSize.height, bgSize.width, bgSize.height);
                                              winnerView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [winnerView removeFromSuperview];
                                          }];
                     }];
}

- (void)flickPointer {
    
    _pointerDuration = 0.07f;
    
    if([self.spinner isSlowing])
    {
        _pointerDuration += 0.1f;
    }
    
    [UIView animateWithDuration:_pointerDuration
                     animations:^{
                         if(self.spinner.wheelDirection == kWheelDirectionAnticlockwise)
                         {
                             self.pointer.transform = CGAffineTransformMakeRotation(10 / 180.0 * M_PI);
                         }
                         else
                         {
                             self.pointer.transform = CGAffineTransformMakeRotation(-10 / 180.0 * M_PI);
                         }
                     }
                     completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.01f
                                          animations:^{                                              
                                              self.pointer.transform = CGAffineTransformMakeRotation(0 / 180.0 * M_PI);
                                          }
                                          completion:^(BOOL completed) {
                                              if([self.spinner isSpinning])
                                              {
                                                  [self flickPointer];
                                              }
                                          }];
                     }];
}

- (BOOL)isTall {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat height = bounds.size.height;
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    return (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && ((height * scale) >= 1136));
}

@end
