//
//  City.h
//  StudentsTimSort
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#ifndef City_h
#define City_h

#import "NamedObject.h"

#endif /* City_h */

@interface City : NamedObject

- (id) initWithName : (NSString*) name
         andCountry :(NSString*) country;

@property (strong, nonatomic) NSString *country;

@end

