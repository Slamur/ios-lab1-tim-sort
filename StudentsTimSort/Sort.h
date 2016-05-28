//
//  Sort.h
//  StudentsTimSort
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#ifndef Sort_h
#define Sort_h

#import "Student.h"

#endif /* Sort_h */

typedef NSInteger (^Comparator)(Student *left, Student *right);

@interface SortAlgorithm : NSObject
{
    NSInteger _order;
    Comparator _comparator;
    
    NSInteger _stackSize;
};

@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) NSMutableArray *tmpLeft;
@property (strong, nonatomic) NSMutableArray *tmpRight;

@property (strong, nonatomic) NSMutableArray *runBase;
@property (strong, nonatomic) NSMutableArray *runLen;

+ (NSInteger) ascending;

+ (NSInteger) descending;

+ (void) sortArray : (NSMutableArray*) array
    withComparator : (Comparator) comparator
         withOrder : (NSInteger) order;

@end