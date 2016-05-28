//
//  City.m
//  StudentsTimSort
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface City ()

@end

@implementation City

- (id) initWithName : (NSString*) name
andCountry :(NSString*) country
{
    self = [super initWithName : name];
    
    self.country = country;
    
    return self;
}

@end