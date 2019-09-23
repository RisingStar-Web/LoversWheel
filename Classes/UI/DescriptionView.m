//
//  DescriptionView.m
//  Wheel
//
//  Created by Alec Bettinson on 21/10/2012.
//  Copyright (c) 2012 Alec Bettinson. All rights reserved.
//

#import "DescriptionView.h"

#define kTitleLabelHeight 30
#define kDescriptionFontSize (iPad ? 26 : 16)

@interface DescriptionView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation DescriptionView

- (id)initWithTitle:(NSString *)title andDescription:(NSString *)description
{
    self = [super init];
    if (self)
	{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.titleLabel setText:title];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:26.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
		self.titleLabel.hidden = YES;
        [self addSubview:self.titleLabel];
                
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.backgroundColor = [UIColor clearColor];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        [self.descriptionLabel setText:description];
        self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:kDescriptionFontSize];
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*
    CGSize descSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - 40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.titleLabel.frame = CGRectMake((self.frame.size.width / 2) - ((self.frame.size.width - 20) / 2),
                                       5,
                                       self.frame.size.width - 20,
                                       kTitleLabelHeight);
    
    self.descriptionLabel.frame = CGRectMake((self.frame.size.width / 2) - ((self.frame.size.width - 20) / 2),
                                             self.titleLabel.frame.size.height + 10,
                                             self.frame.size.width - 20,
                                             descSize.height);
	 */
	self.descriptionLabel.frame = CGRectMake(40, (self.bounds.size.height - (self.bounds.size.height - 80)) / 2, self.bounds.size.width - 80, self.bounds.size.height - 80);
}

- (NSInteger)heightOfBox {
    CGSize descSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.bounds.size.width - 80, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    //return (NSInteger)descSize.height + kTitleLabelHeight + 25;
	return (NSInteger)descSize.height + 80;
}

@end
