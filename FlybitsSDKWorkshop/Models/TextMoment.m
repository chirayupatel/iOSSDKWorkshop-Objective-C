//
//  TextMomentData.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-29.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import "TextMoment.h"

@implementation TextData

- (instancetype)initWithIdentifier:(NSInteger)identifier andDictionary:(NSDictionary<NSString *, NSString *> *)dictionary {
    self = [super init];
    if(self) {
        _identifier = identifier;
        _summary = [dictionary valueForKey:@"description"];
        _title = [dictionary valueForKey:@"title"];
    }
    return self;
}

@end

@implementation TextMomentData

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _texts = [[NSMutableDictionary alloc] init];

        NSArray<NSDictionary<NSString *, NSObject *> *> *textsData = [dictionary valueForKey:@"texts"];
        for(NSDictionary<NSString *, id> *itemDict in textsData) {
            NSInteger identifier = [[itemDict objectForKey:@"id"] integerValue];
            NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *locales = [itemDict objectForKey:@"locales"];
            [locales enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull lang, NSDictionary<NSString *, NSString *> * _Nonnull dictionary, BOOL * _Nonnull stop) {
                TextData *item = [[TextData alloc] initWithIdentifier: identifier andDictionary:dictionary];
                [_texts setObject:item forKey:lang];
            }];
        }
    }
    return self;
}

@end
