//
//  NamedObject.m
//  StudentsTimSort
//
//  Created by Admin on 22.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NamedObject.h"

@interface NamedObject()

@end

@implementation NamedObject

- (id) initWithName : (NSString*) name
{
    self = [super init];
    
    self.name = name;
    
    return self;
}

@end