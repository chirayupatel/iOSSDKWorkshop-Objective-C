//
//  ZoneListViewController.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-28.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import "ZoneCollectionViewCell.h"
#import "ZoneViewController.h"
#import "ZoneListViewController.h"

@interface ZoneListViewController ()

#pragma mark - IBOutlets
@property (nonatomic) IBOutlet UICollectionView *zonesCollectionView;

// Tutorial Section 2.2 (Zones)

@end

@implementation ZoneListViewController

const NSString * const ZoneCellReuseIdentifier = @"ZoneCollectionViewCell";

#pragma mark - View Lifecycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    // Tutorial Section 7.11 (Push Notifications)

    // Tutorial Section 7.12 (Push Notifications)

    // Tutorial Section 7.13 (Push Notifications)

    // Tutorial Section 7.14 (Push Notifications)

    // Tutorial Section 2.1 (Zones)

    // Tutorial Section 8.2 (Context)
}

- (void)viewDidLayoutSubviews {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)[_zonesCollectionView collectionViewLayout];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, flowLayout.itemSize.height);
}

#pragma mark - Segue Functions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Tutorial Section 3.3 (Selected Zone)
}

#pragma mark - Functions

// Tutorial Section 7.15 (Push Notifications)

#pragma mark - UICollectionViewDataSource Functions
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Tutorial Section 2.3 (Zones)
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZoneCollectionViewCell *cell = (ZoneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ZoneCellReuseIdentifier copy] forIndexPath:indexPath];

    // Tutorial Section 2.4 (Zones)

    return cell;
}

#pragma mark - UICollectionViewDelegate Functions
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Tutorial Section 3.2 (Selected Zone)
    [self performSegueWithIdentifier:@"MomentSegue" sender:nil];
}

#pragma mark - CoreLocationDataProviderDelegate Functions
// Tutorial Section 8.3 (Context)

@end
