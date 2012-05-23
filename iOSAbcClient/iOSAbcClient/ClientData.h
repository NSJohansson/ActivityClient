//
//  ClientData.h
//  iOSAbcClient
//
//  Created by pitlab on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"

@interface ClientData : NSObject
+(NSString*)categoryForActivity:(Activity*)activity;
+(NSString*)categoryForResource:(Resource*)resource;

+(NSArray*)activityCategories;
+(NSArray*)resourceCategories;
+(NSArray*)bluetoothZones;
+(NSDictionary*)bluetoothZoneDictionaryByZoneName;

+(void)mapCategory:(NSString*)category toResource:(Resource*)resource;
+(void)mapCategory:(NSString*)category toActivity:(Activity*)activity;

+(void)mapBluetoothTag:(NSString*)zoneName toActivity:(Activity*)activity;
+(NSArray*)ActivityIdsForZoneId:(NSString*)zoneId;
@end
