//
//  WebMoment.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-29.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

#import "WebMoment.h"

// Tutorial Section 4.6b (Moments) - Helper Classes
@implementation WebData

#pragma mark - Properties

- (NSURL *)URL {
    if(_URLString != nil) {
        return [NSURL URLWithString:_URLString];
    }
    return nil;
}

#pragma mark - Lifecycle Functions
- (instancetype)initWithLocale:(NSString *)locale andDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _summary = [dictionary objectForKey:@"description"];
        _title = [dictionary objectForKey:@"title"];
        _URLString = [dictionary objectForKey:@"url"];
    }
    return self;
}

@end

@implementation WebMomentData

#pragma mark - Lifecycle Functions
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _websites = [[NSMutableArray alloc] init];
        
        for(NSString *locale in [dictionary allKeys]) {
            NSArray *webs = [dictionary[locale] objectForKey:@"websites"];
            for(NSDictionary *data in webs) {
                WebData *item = [[WebData alloc] initWithLocale:locale andDictionary:data];
                [_websites addObject:item];
            }
        }
    }
    return self;
}

@end