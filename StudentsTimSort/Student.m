//
//  Student.m
//  StudentsTimSort
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Student.h"

@interface Student ()

@end

@implementation Student

- (id) initWithName:(NSString *)name
andGroup:(Group *)group
andAverageMark:(double)averageMark
andAge:(NSInteger)age
andCity:(City *)city
{
    self = [super initWithName: name];
    
    self.group = group;
    self.averageMark = averageMark;
    self.age = age;
    self.city = city;
    
    return self;
}

@end