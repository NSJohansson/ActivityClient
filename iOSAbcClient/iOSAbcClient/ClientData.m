//
//  ClientData.m
//  iOSAbcClient
//
//  Created by pitlab on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClientData.h"

@implementation ClientData

#define ACTIVITY_CATEGORIES @"activityCategories"
#define RESOURCE_CATEGORIES @"resourceCategories"
#define BLUETOOTH_MAPPING @"bluetoothMapping"

+(NSMutableDictionary*)dictionaryWithActivityCategoryById {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[defaults objectForKey:ACTIVITY_CATEGORIES] mutableCopy];
    if(!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
        [defaults setObject:dictionary forKey:ACTIVITY_CATEGORIES];
    }
    return dictionary;
}

+(NSMutableDictionary*)dictionaryWithResourceCategoryById {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[defaults objectForKey:RESOURCE_CATEGORIES] mutableCopy];
    if(!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
        [defaults setObject:dictionary forKey:RESOURCE_CATEGORIES];
    }
    return dictionary;
}



+(void)mapCategory:(NSString*)category toResource:(Resource*)resource {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[defaults objectForKey:RESOURCE_CATEGORIES] mutableCopy];
    if(!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:category forKey:resource.identity.ID];
    [defaults setObject:dictionary forKey:RESOURCE_CATEGORIES];
}

+(void)mapCategory:(NSString*)category toActivity:(Activity*)activity {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[defaults objectForKey:ACTIVITY_CATEGORIES] mutableCopy];
    if(!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }        
    [dictionary setObject:category forKey:activity.identity.ID];
    [defaults setObject:dictionary forKey:ACTIVITY_CATEGORIES];
}







+(NSString*)categoryForActivity:(Activity*)activity {
    return [[self dictionaryWithActivityCategoryById] objectForKey:[activity.identity.ID uppercaseString]];
}

+(NSString*)categoryForResource:(Resource*)resource {
    return [[self dictionaryWithResourceCategoryById] objectForKey:[resource.identity.ID uppercaseString]];
}



+(NSArray*)activityCategories {
    return [NSArray arrayWithObjects:
            @"Conference", @"Exercise", @"Lecture", 
            @"Meeting", @"Preparation", @"Workshop", nil];
}

+(NSArray*)resourceCategories {
    return [NSArray arrayWithObjects:
            @"Google Doc", @"HTML page", @"PDF", 
            @"Image", nil];
}

+(NSArray*)bluetoothZones {
    return [NSArray arrayWithObjects:@"2C", @"2E", @"3B", @"3D", @"4C", @"4E", nil];
}

+(NSDictionary*)bluetoothZoneDictionaryByZoneName {
    NSArray *values = [NSArray arrayWithObjects:@"itu.zone2.zone2c", @"itu.zone2.zone2e", @"itu.zone3.zone3b", @"itu.zone3.zone3d", @"itu.zone4.zone4c", @"itu.zone4.zone4e" , nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:[self bluetoothZones]];
    return dictionary;
}

+(void)mapBluetoothTag:(NSString*)zoneName toActivity:(Activity*)activity {
    NSString *zoneId = [[ClientData bluetoothZoneDictionaryByZoneName] objectForKey:zoneName];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary = [[defaults objectForKey:BLUETOOTH_MAPPING] mutableCopy];
    if(!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }     
    NSMutableArray *activityIds = [[dictionary objectForKey:zoneId] mutableCopy];
    if(!activityIds) {
        activityIds = [NSMutableArray array];
    }
    NSLog(@"Activity ID: %@", activity.identity.ID);
    [activityIds addObject:activity.identity.ID];
    [dictionary setObject:activityIds forKey:zoneId];
    
    [defaults setObject:dictionary forKey:BLUETOOTH_MAPPING];
}

+(NSArray*)ActivityIdsForZoneId:(NSString*)zoneId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:BLUETOOTH_MAPPING] objectForKey:zoneId];
}
    
@end
