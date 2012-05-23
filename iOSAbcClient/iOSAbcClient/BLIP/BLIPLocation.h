//
//  BLIPTerminal.h
//  TestApp
//
//  Created by Niklas Johansson on 04/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit/RestKit.h"

@interface BLIPLocation : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *locationName;
@property (nonatomic,strong) NSNumber *timestamp;

+(RKObjectMapping *) mappingForBLIPLocation;

-(NSString *) description;

@end
