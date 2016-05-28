//
//  main.m
//  StudentsTimSort
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "City.h"
#import "Group.h"
#import "Student.h"
#import "Sort.h"

NSInteger (^CompareByName)(Student*, Student*) = ^(Student *left, Student *right) {
    return [left.name compare:right.name];
};

NSInteger (^CompareByAverageMark)(Student*, Student*) = ^(Student *left, Student *right) {
    int result = 0;
    if (left.averageMark < right.averageMark) result = -1;
    if (left.averageMark > right.averageMark) result = 1;
    
    return (NSInteger) result;
};

NSInteger (^CompareByAge)(Student*, Student*) = ^(Student *left, Student *right) {
    return left.age - right.age;
};

void printInputMessageFor(NSString *name) {
    if (name) {
         NSLog(@"Input %@:", name);
    }
}

NSString *readString(NSString *name) {
    @autoreleasepool {
        printInputMessageFor(name);
        
        return [[[NSString alloc] initWithData:[[NSFileHandle fileHandleWithStandardInput] availableData] encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
}

NSString *readName() {
    return readString(@"name");
}

NSInteger readInteger(NSString *name) {
    return [readString(name) integerValue];
}

double readDouble(NSString *name) {
    return [readString(name) doubleValue];
}

NSMutableDictionary *groups;
NSMutableDictionary *cities;

City *readCity() {
    printInputMessageFor(@"city info");
    
    NSString *name = readName();
    
    City *city = [cities valueForKey:name];
    if (!city) {
        NSString *country = readString(@"country");
        city = [[City alloc] initWithName:name andCountry:country];
        
        [cities setObject:city forKey:name];
    }
    
    return city;
}

Group *readGroup() {
    printInputMessageFor(@"group info");
    
    NSString *name = readName();
    
    Group *group = [groups valueForKey:name];
    if (!group) {
        group = [[Group alloc] initWithName:name];
        
        [groups setObject:group forKey:name];
    }
    
    return group;
}

Student *readStudent() {
    printInputMessageFor(@"student info");
    
    NSString *name = readName();
    
    NSInteger age = readInteger(@"age");
    
    City *city = readCity();
    
    Group *group = readGroup();
    
    double averageMark = readDouble(@"average mark");
    
    Student *student = [[Student alloc] initWithName:name andGroup:group andAverageMark:averageMark andAge:age andCity:city];
    
    return student;
}

void printStudent(Student *student) {
    NSLog(@"Name: %@\tAge: %ld\tAverage mark: %f\tGroup: %@\tCity: %@(%@)",
          student.name, student.age, student.averageMark,
          student.group.name, student.city.name, student.city.country
          );
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        groups = [[NSMutableDictionary alloc] init];
        cities = [[NSMutableDictionary alloc] init];
        
        NSInteger numberOfStudents = readInteger(@"number of students");
        NSMutableArray *students = [[NSMutableArray alloc] initWithCapacity: numberOfStudents];
        
        for (int i = 0; i < numberOfStudents; ++i) {
            [students addObject:readStudent()];
        }
        
        NSInteger sortType = readInteger(@"type of sort (1 - name, 2 - age, 3 - average mark, default - name)");
        Comparator comparator;
        
        switch (sortType) {
            case 1:
                comparator = CompareByName;
                break;
            case 2:
                comparator = CompareByAge;
                break;
            case 3:
                comparator = CompareByAverageMark;
                break;
            default:
                comparator = CompareByName;
                break;
        }
        
        NSInteger order = readInteger(@"order of sorting (0 - ascending, other - descending)");
        if (order == 0) {
            order = [SortAlgorithm ascending];
        } else {
            order = [SortAlgorithm descending];
        }
        
        [SortAlgorithm sortArray:students withComparator:comparator withOrder:order];
        
        for (int i = 0; i < numberOfStudents; ++i) {
            printStudent([students objectAtIndex:i]);
        }
    }
    return 0;
}
