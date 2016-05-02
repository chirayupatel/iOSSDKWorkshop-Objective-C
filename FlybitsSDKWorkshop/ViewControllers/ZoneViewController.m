//
//  ZoneViewController.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-28.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import "MomentCollectionViewCell.h"
#import "MomentViewController.h"
#import "ZoneViewController.h"

@interface ZoneViewController ()

#pragma mark - IBOutlets
@property (nonatomic) IBOutlet UICollectionView *momentsCollectionView;
@property (nonatomic) IBOutlet UIImageView *zoneImageView;

#pragma mark - Properties

// Tutorial Section 3.5 (Selected Zone)

// Tutorial Section 6.2 (Tags)

@property (nonatomic) NSMutableArray<NSObject *> *tokens;

@end

@implementation ZoneViewController

#pragma mark - Constants
const NSString * const MomentCellReuseIdentifier = @"MomentCollectionViewCell";

#pragma mark - Properties

// Tutorial Section 3.1b (Selected Zone)

#pragma mark - View Lifecycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Tutorial Section 7.7 (Push Notifications)

    // Tutorial Section 7.8 (Push Notifications)

    // Tutorial Section 3.4 (Selected Zone)
    [self setTitle:@"Zone"];

    // Tutorial Section 5.1 (Zone Connect / Disconnect - Analytics)

    // Tutorial Section 6.1 (Tags)
}

- (void)viewDidLayoutSubviews {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)[_momentsCollectionView collectionViewLayout];
    
    // Fit 3 on a screen at a time with a tiny amount of padding
    CGFloat size = floor(self.view.frame.size.width / 3) - 5;
    CGFloat spacing = (int)self.view.frame.size.width % 3;

    [flowLayout setItemSize:CGSizeMake(size, size)];
    [flowLayout setMinimumInteritemSpacing:spacing];
    [flowLayout setMinimumLineSpacing:spacing + 5];

    UIEdgeInsets insets = UIEdgeInsetsMake(_zoneImageView.frame.size.height + self.topLayoutGuide.length + 10, flowLayout.sectionInset.left, flowLayout.sectionInset.bottom, flowLayout.sectionInset.right);
    [flowLayout setSectionInset:insets];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    for(NSObject *token in _tokens) {
        [[NSNotificationCenter defaultCenter] removeObserver:token];
    }
    [_tokens removeAllObjects];
}

#pragma mark - Helper Functions
// Tutorial Section 6.3 (Tags)

// Tutorial Section 6.4 (Tags)

// Tutorial Section 7.9 (Push Notifications)

#pragma mark - Segue Functions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Tutorial Section 4.3 (Moments)
}

#pragma mark - UICollectionViewDataSource Functions
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Tutorial Section 3.6 (Selected Zone)
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MomentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MomentCellReuseIdentifier copy] forIndexPath:indexPath];

    // Tutorial Section 3.7 (Selected Zone)

    return cell;
}

#pragma mark - UICollectionViewDelegate Functions
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Tutorial Section 4.2 (Moments)
    [self performSegueWithIdentifier:@"MomentSegue" sender:nil];
}

#pragma mark - IBActions
// Tutorial Section 6.5 (Tags)

@end
