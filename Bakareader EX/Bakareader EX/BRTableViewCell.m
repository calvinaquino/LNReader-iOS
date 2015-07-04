//
//  BakaReaderTableViewCell.m
//  Bakareader EX
//
//  Created by Calvin Gonçalves de Aquino on 7/4/15.
//  Copyright (c) 2015 Erakk. All rights reserved.
//

#import "BRTableViewCell.h"
#import "BakaReaderTableViewCellPrivateInterface.h"

@implementation BRTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor backgroundColor];
    self.selectedBackgroundView.backgroundColor = [[UIColor backgroundColor] colorWithAlphaComponent:0.6];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont cellTitleFont];
    self.titleLabel.textColor = [UIColor textColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.titleLabel.minimumScaleFactor = 0.7;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont cellSubtitleFont];
    self.subtitleLabel.textColor = [[UIColor textColor] colorWithAlphaComponent:0.5];
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.subtitleLabel.minimumScaleFactor = 0.5;
    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.overflowButton = [[UIButton alloc] init];
    [self.overflowButton setImage:[UIImage imageNamed:@"moreWhite"] forState:UIControlStateNormal];
    [self.overflowButton addTarget:self action:@selector(performOverflowAction) forControlEvents:UIControlEventTouchUpInside];
    self.overflowButton.hidden = YES;
    _overflowEnabled = NO;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.overflowButton];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.subtitleLabel.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL hasSubtitle = self.subtitleLabel.text.length > 0;
    CGFloat overflowSize = 44.0;
    CGFloat rightMargin = self.isOverflowEnabled ? overflowSize : kMargin;
    
    if (hasSubtitle) {
        self.titleLabel.left = kMargin;
        self.titleLabel.top = kMarginSmall;
        self.titleLabel.width = self.contentView.bounds.size.width - (kMargin + rightMargin);
        
        self.subtitleLabel.left = self.titleLabel.left;
        self.subtitleLabel.top = self.titleLabel.bottom;
        self.subtitleLabel.width = self.titleLabel.width;
    } else {
        self.titleLabel.left = kMargin;
        self.titleLabel.top = kMarginSmall;
        self.titleLabel.width = self.contentView.bounds.size.width - (kMargin + rightMargin);
        
        [self.subtitleLabel zeroFrame];
    }
    
    if (self.isOverflowEnabled) {
        self.overflowButton.hidden = NO;
        self.overflowButton.left = self.titleLabel.right;
        self.overflowButton.top = ([BRTableViewCell height] - overflowSize) / 2.0;
        self.overflowButton.width = overflowSize;
        self.overflowButton.height = overflowSize;
    } else {
        self.overflowButton.hidden = YES;
        [self.overflowButton zeroFrame];
    }
}

- (void)performOverflowAction {
    if (self.overflowActionBlock) {
        self.overflowActionBlock(self);
    }
}


#pragma mark - Overridden Methods

+ (CGFloat)height {
    return 50.0;
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (void)setTitle:(NSString *)title {
    if (![self.titleLabel.text isEqualToString:title]) {
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle {
    if (![self.subtitleLabel.text isEqualToString:subtitle]) {
        self.subtitleLabel.text = subtitle;
        [self.subtitleLabel sizeToFit];
        [self setNeedsLayout];
    }
}

- (NSString *)subtitle {
    return self.subtitleLabel.text;
}

- (void)setOverflowEnabled:(BOOL)overflowEnabled {
    if (_overflowEnabled != overflowEnabled) {
        _overflowEnabled = overflowEnabled;
        
        [self setNeedsLayout];
    }
}

- (void)setMarkedAsRead:(BOOL)markedAsRead {
    if (_markedAsRead != markedAsRead) {
        _markedAsRead = markedAsRead;
        
        CGFloat alpha = markedAsRead ? 0.6 : 1.0;
        self.titleLabel.textColor = [[UIColor textColor] colorWithAlphaComponent:alpha];
    }
}


@end
