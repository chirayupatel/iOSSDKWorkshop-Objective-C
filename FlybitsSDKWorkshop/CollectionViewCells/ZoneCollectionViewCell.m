//
//  ZoneCollectionViewCell.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-27.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import "ZoneCollectionViewCell.h"

@implementation ZoneCollectionViewCell

- (void)setIsInZone:(BOOL)isInZone {
    _isInZone = isInZone;

    UIColor *color = isInZone ? [UIColor greenColor] : [UIColor darkGrayColor];
    [_insideZoneIcon setBackgroundColor:color];
}

- (void)prepareForReuse {
    _zoneNameLabel.text = @"";
    _zoneDescriptionLabel.text = @"";
    _isInZone = NO;
}

@end
