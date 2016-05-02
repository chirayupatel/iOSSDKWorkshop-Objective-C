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
@property (nonatomic) NSMutableArray<Moment *> *moments;

// Tutorial Section 6.2 (Tags)
@property (nonatomic) NSMutableArray<VisibleTag *> *tags;
@property (nonatomic) NSArray<NSString *> *selectedTagFilter; // A list of Zone Moment Instance IDs
@property (nonatomic) NSMutableArray<NSObject *> *tokens;

@end

@implementation ZoneViewController

#pragma mark - Constants
const NSString * const MomentCellReuseIdentifier = @"MomentCollectionViewCell";

#pragma mark - Properties

// Tutorial Section 3.1b (Selected Zone)
- (void)setSelectedZone:(Zone *)selectedZone {
    _selectedZone = selectedZone;
    self.title = [selectedZone zoneName] ? [selectedZone zoneName] : @"Zone";
}

#pragma mark - View Lifecycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Tutorial Section 7.7 (Push Notifications)
    NSString *enteredTopic = [PushMessage CompleteNotificationType:PushMessageEntityZone action:PushMessageActionEntered rawAction:_selectedZone.identifier];
    NSObject *enteredToken = [[NSNotificationCenter defaultCenter] addObserverForName:enteredTopic object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if([note userInfo] != nil) {
            [self zoneEnteredMessage:[note userInfo]];
        }
    }];
    [_tokens addObject:enteredToken];

    // Tutorial Section 7.8 (Push Notifications)
    NSString *zoneEnteredTopic = [PushMessage CompleteNotificationType:PushMessageEntityMomentInstance action:PushMessageActionZoneEntered rawAction:[_selectedZone identifier]];
    NSObject *token = [[NSNotificationCenter defaultCenter] addObserverForName:zoneEnteredTopic object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self zoneEnteredMessage:[note userInfo]];
    }];
    [_tokens addObject:token];

    // Tutorial Section 3.4 (Selected Zone)
    if(_selectedZone == nil) {
        [self setTitle:@"Zone"];
    } else {
        self.title = [_selectedZone zoneName] ? [_selectedZone zoneName] : @"Zone";
        
        [_zoneImageView setImage:[[_selectedZone image] loadedImage:ImageSize_100 locale:nil]];
        MomentQuery *query = [[MomentQuery alloc] init];
        [query setZoneIDs:@[_selectedZone.identifier]];
        
        [APIManager getMoments:query completion:^(NSArray<Moment *> * _Nonnull moments, Pager * _Nullable pager, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"Encountered error: %@", [error localizedDescription]);
                return;
            }
            _moments = [moments mutableCopy];
            [_momentsCollectionView reloadData];
        }];
    }

    // Tutorial Section 5.1 (Zone Connect / Disconnect - Analytics)
    DeviceQuery *deviceQuery = [DeviceQuery queryForZone:[_selectedZone identifier]];
    [APIManager deviceConnect:deviceQuery withCompletion:^(NSError * _Nullable error) {
        // Check for failure
        if(error != nil) {
            NSLog(@"Encountered error connecting to Zone: %@", [_selectedZone identifier]);
            return;
        }
        [APIManager deviceDisconnect:deviceQuery withCompletion:^(NSError * _Nullable error) {
            // Check for failure
            if(error != nil) {
                NSLog(@"Encountered error disconnecting from Zone: %@", [_selectedZone identifier]);
            }
        }];
    }];

    // Tutorial Section 6.1 (Tags)
    TagQuery *query = [[TagQuery alloc] init];
    [APIManager tagAction:query withCompletion:^(NSArray<Tag *> * _Nullable tags, Pager * _Nullable pager, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Encountered error retrieving tags: %@", [error localizedDescription]);
            return;
        }
        _tags = [tags mutableCopy];
        
        [self toggleFilterButtonDisplay:(_tags == nil)];
    }];
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
- (void)toggleFilterButtonDisplay:(BOOL)isHidden {
    if(isHidden) {
        [[self navigationItem] setRightBarButtonItem:nil];
    } else {
        UIBarButtonItem *filterBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onFilterAction:)];
        [[self navigationItem] setRightBarButtonItem:filterBarButtonItem];
    }
}

// Tutorial Section 6.4 (Tags)
- (void)doMomentQuery {
    MomentQuery *query = [[MomentQuery alloc] init];
    
    [query setZoneIDs:@[_selectedZone.identifier]];
    if(_selectedTagFilter != nil) {
        [query setMomentIDs:_selectedTagFilter];
    }
    
    [APIManager getMoments:query completion:^(NSArray<Moment *> * _Nonnull moments, Pager * _Nullable pager, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Encountered error: %@", [error localizedDescription]);
            return;
        }
        _moments = [moments mutableCopy];
        
        [_momentsCollectionView reloadData];
    }];
}

// Tutorial Section 7.9 (Push Notifications)
- (void)zoneEnteredMessage:(NSDictionary *)userInfo {
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
    if(![[zone identifier] isEqualToString:[_selectedZone identifier]]) {
        // This is not the Zone we're looking for
        return;
    }
    NSLog(@"Entered Zone!");
}

#pragma mark - Segue Functions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Tutorial Section 4.3 (Moments)
    if([sender isKindOfClass:[Moment class]]) {
        MomentViewController *momentViewController = (MomentViewController *)[segue destinationViewController];
        [momentViewController setMoment:sender];
    }
}

#pragma mark - UICollectionViewDataSource Functions
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Tutorial Section 3.6 (Selected Zone)
    return [_moments count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MomentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MomentCellReuseIdentifier copy] forIndexPath:indexPath];

    // Tutorial Section 3.7 (Selected Zone)
    Moment *moment = _moments[[indexPath item]];
    if(moment != nil) {
        [[moment image] loadImage:ImageSize_100 locale:nil withCompletion:^(Image * _Nonnull image, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"Encountered image loading error: %@", [error localizedDescription]);
                return;
            }
            [UIView transitionWithView:[cell momentImageView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [[cell momentImageView] setImage:[image loadedImage:ImageSize_100 locale:nil]];
            } completion:nil];
        }];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate Functions
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Tutorial Section 4.2 (Moments)
    Moment *moment = _moments[[indexPath item]];
    if(moment != nil) {
        [self performSegueWithIdentifier:@"MomentSegue" sender:moment];
    }
}

#pragma mark - IBActions
// Tutorial Section 6.5 (Tags)
- (IBAction)onFilterAction:(UIBarButtonItem *)sender {
    if(_tags == nil) {
        return; // Nothing to show
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Filter By Tag" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    [[alertController popoverPresentationController] setBarButtonItem:sender];
    
    for(Tag *tag in _tags) {
        NSString *actionTitle = [tag tagValue] ? [tag tagValue] : [NSString stringWithFormat:@"Tag %@", [tag identifier]];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _selectedTagFilter = [tag zoneMomentInstanceIDs];
            
            [self doMomentQuery]; // TODO: (TL) Weakself
        }];
        [alertController addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // Do nothing - TODO: (TL) Clear filter
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
