//
//  ZoneCollectionViewCell.h
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-27.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoneCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *zoneImageView;
@property (nonatomic) IBOutlet UILabel *zoneNameLabel;
@property (nonatomic) IBOutlet UILabel *zoneDescriptionLabel;
@property (nonatomic) IBOutlet UIView *insideZoneIcon;
@property (nonatomic) BOOL isInZone;

@end
