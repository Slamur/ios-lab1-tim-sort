//
//  Student.h
//  StudentsTimSort
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#ifndef Student_h
#define Student_h


#import "NamedObject.h"
#import "Group.h"
#import "City.h"

#endif /* Student_h */

@interface Student : NamedObject

- (id) initWithName : (NSString*) name
           andGroup : (Group*) group
     andAverageMark : (double) averageMark
             andAge : (NSInteger) age
            andCity : (City*) city;

@property (strong, nonatomic) Group *group;

@property (nonatomic) double averageMark;

@property (nonatomic) NSInteger age;

@property (strong, nonatomic) City *city;

@end