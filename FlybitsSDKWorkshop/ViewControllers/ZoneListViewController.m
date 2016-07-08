//
//  ZoneListViewController.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-28.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import "CoreLocation/CoreLocation.h"
#import "ZoneCollectionViewCell.h"
#import "ZoneViewController.h"
#import "ZoneListViewController.h"

@interface ZoneListViewController ()

#pragma mark - IBOutlets
@property (nonatomic) IBOutlet UICollectionView *zonesCollectionView;

// Tutorial Section 2.2 (Zones)
@property (nonatomic) NSMutableArray<Zone *> *zones;

@end

@implementation ZoneListViewController

const NSString * const ZoneCellReuseIdentifier = @"ZoneCollectionViewCell";

#pragma mark - View Lifecycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    // Tutorial Section 7.11 (Push Notifications)
    NSString *zoneModifiedTopic = [PushMessage NotificationType:PushMessageEntityZone action:PushMessageActionModified];
    /* NSObject *token = */ [[NSNotificationCenter defaultCenter] addObserverForName:zoneModifiedTopic object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if(note.userInfo != nil) {
            [self updateZoneInfo:note.userInfo];
        }
    }];

    // Tutorial Section 7.12 (Push Notifications)
    NSString *zoneEnteredTopic = [PushMessage NotificationType:PushMessageEntityZone action:PushMessageActionEntered];
    /* NSObject *token = */ [[NSNotificationCenter defaultCenter] addObserverForName:zoneEnteredTopic object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if(note.userInfo != nil) {
            [self updateZoneInfo:note.userInfo];
        }
    }];

    // Tutorial Section 7.13 (Push Notifications)
    NSString *zoneExitedTopic = [PushMessage NotificationType:PushMessageEntityZone action:PushMessageActionExited];
    /* NSObject *token = */ [[NSNotificationCenter defaultCenter] addObserverForName:zoneExitedTopic object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if(note.userInfo != nil) {
            [self updateZoneInfo:note.userInfo];
        }
    }];

    // Tutorial Section 7.14 (Push Notifications)
    /* NSObject *token = */ [[NSNotificationCenter defaultCenter] addObserverForName:[PushManagerConstants PushErrorTopic] object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if(note.userInfo != nil) {
            NSString *errorReason = [note.userInfo objectForKey:[PushManagerConstants PushErrorData]];
            if(errorReason != nil) {
                NSLog(@"Encountered Push Error: %@", errorReason);
            }
        }
    }];

    // Tutorial Section 2.1 (Zones)
    ZonesQuery *query = [[ZonesQuery alloc] init];
    [APIManager zonesQuery:query withCompletion:^(NSArray<Zone *> * _Nullable zones, Pager * _Nullable pager, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Encountered error: %@", error.localizedDescription);
            return;
        }
        _zones = [zones mutableCopy];
        [_zonesCollectionView reloadData];

        [_zones enumerateObjectsUsingBlock:^(Zone * _Nonnull zone, NSUInteger idx, BOOL * _Nonnull stop) {
            [zone subscribeToPush];
            [APIManager favouriteAction:zone favourite:YES withCompletion:^(BOOL success, NSError * _Nullable error) {
                if(error || !success) {
                    NSLog(@"Unable to favourite Zone: %@", [zone identifier]);
                }
            }];
        }];
    }];

    // Tutorial Section 8.2 (Context)
    CoreLocationDataProvider *locationDataProvider = (CoreLocationDataProvider *)[[ContextManager sharedManager] retrieveContextProvider:ContextProviderCoreLocation];
    [locationDataProvider addDelegate:self];
}

- (void)viewDidLayoutSubviews {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)[_zonesCollectionView collectionViewLayout];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, flowLayout.itemSize.height);
}

#pragma mark - Segue Functions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Tutorial Section 3.3 (Selected Zone)
    if([sender isKindOfClass:[Zone class]]) {
        ZoneViewController *zoneViewController = (ZoneViewController *)[segue destinationViewController];
        [zoneViewController setSelectedZone:sender];
    }
}

#pragma mark - Functions

// Tutorial Section 7.15 (Push Notifications)
/* User Info format:
 [
 "com.flybits.push.content"        : PushMessage // A PushMessage object
 "com.flybits.push.source"         : PushSource  // APNS or MQTT
 "com.flybits.push.sourceContent"  : APS Content // This is an optional entry that will contain the APS content of an APNS push message
 "com.flybits.push.fetchedContent" : A Flybits model object // i.e. a Zone or Moment
 
 -- OR --
 
 "com.flybits.push.error.type" : <Error Code>
 ]
 */
- (void)updateZoneInfo:(NSDictionary *)userInfo {
    NSString *error = [userInfo objectForKey:[PushManagerConstants PushErrorType]];
    if(error != nil) {
        NSLog(@"Encountered error: %@", error);
        return;
    }
    Zone *zone = (Zone *)[userInfo objectForKey:PushManagerConstants.PushFetchedContent];
    if(zone == nil) {
        NSLog(@"No Zone fetched.");
        return;
    }
    NSInteger index = [_zones indexOfObject:zone];
    if(index == NSNotFound) {
        // We don't have this Zone right now
        return;
    }
    [_zones setObject:zone atIndexedSubscript:index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_zonesCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    });
}

#pragma mark - UICollectionViewDataSource Functions
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Tutorial Section 2.3 (Zones)
    return [_zones count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZoneCollectionViewCell *cell = (ZoneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ZoneCellReuseIdentifier copy] forIndexPath:indexPath];

    // Tutorial Section 2.4 (Zones)
    Zone *zone = _zones[[indexPath item]];
    if(zone == nil) {
        return cell;
    }
    
    // Tutorial Section 7.16 (Push Notifications)
    [[cell zoneNameLabel] setText:[zone zoneName]];
    [[cell zoneDescriptionLabel] setText:[zone zoneDesc]];
    [[zone image] loadImage:ImageSize_100 locale:nil withCompletion:^(Image * _Nonnull image, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Encountered image loading error: %@", error.localizedDescription);
            return;
        }
        [UIView transitionWithView:[cell zoneImageView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [[cell zoneImageView] setImage:[image loadedImage:ImageSize_100 locale:nil]];
        } completion:nil];
    }];

    return cell;
}

#pragma mark - UICollectionViewDelegate Functions
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Tutorial Section 3.2 (Selected Zone)
    Zone *zone = _zones[[indexPath item]];
    if(zone != nil) {
        [self performSegueWithIdentifier:@"MomentSegue" sender:zone];
    }
}

#pragma mark - CoreLocationDataProviderDelegate Functions
// Tutorial Section 8.3 (Context)
- (void)locationDataProvider:(CoreLocationDataProvider *)dataProvider didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"Location updated: %@", locations);
}

@end
