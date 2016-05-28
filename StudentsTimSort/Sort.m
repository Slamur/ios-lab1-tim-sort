//
//  Sort.m
//  StudentsTimSort
//
//  Created by Admin on 21.05.16.
//  Copyright © 2016 SSAU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sort.h"
#import "Student.h"

@implementation SortAlgorithm

+ (NSInteger) ascending {
    return (NSInteger)1;
}

+ (NSInteger) descending {
    return (NSInteger)-1;
}

- (id) initWithArray:(NSMutableArray *)array withComparator:(Comparator)comparator withOrder:(NSInteger)order {
    
    self = [super init];
    
    self.array = array;
    
    _comparator = comparator;
    _order = order;
    
    NSInteger length = [array count];
    
    NSInteger initTmpStorageLength = 256;
    
    self.tmpLeft = [[NSMutableArray alloc] initWithCapacity: (length < 2 * initTmpStorageLength
                                                          ? (length >> 1) + 1
                                                          : initTmpStorageLength)
                    ];
                    
    self.tmpRight = [[NSMutableArray alloc] initWithCapacity: (length < 2 * initTmpStorageLength
                                                                ? (length - (length >> 1)) + 1
                                                                : initTmpStorageLength)
                ];
    
    NSInteger stackLen = (length <    120  ?  5 :
                    length <   1542  ? 10 :
                    length < 119151  ? 19 : 40);
    
    self.runBase = [[NSMutableArray alloc] initWithCapacity:stackLen];
    self.runLen = [[NSMutableArray alloc] initWithCapacity:stackLen];
    
    _stackSize = 0;
    
    return self;
}

+ (void) reverseRangeWithArray: (NSMutableArray*)a withLeft: (NSInteger) lo withRight: (NSInteger)hi {
    hi--;
    while (lo < hi) {
        NamedObject *t = a[lo];
        a[lo++] = a[hi];
        a[hi--] = t;
    }
}

+ (NSInteger) countRunAndMakeAscendingArray:(NSMutableArray *)array withComparator:(Comparator)comparator withOrder:(NSInteger)order withLeft:(NSInteger) lo withRight: (NSInteger) hi {
    NSInteger runHi = lo + 1;
    if (runHi == hi)
        return 1;
    
    // Find end of run, and reverse range if descending
    if (comparator(array[runHi++], array[lo]) * order < 0) { // Descending
        while(runHi < hi && comparator(array[runHi], array[runHi - 1]) * order < 0)
            runHi++;
        [SortAlgorithm reverseRangeWithArray: array withLeft: lo withRight: runHi];
    } else {                              // Ascending
        while (runHi < hi && comparator(array[runHi], array[runHi - 1]) * order >= 0)
            runHi++;
    }
    
    return runHi - lo;
}

+ (void) shiftArray: (NSMutableArray*) array withStart: (NSInteger) start withLength: (NSInteger) length {
    for (NSInteger i = start + length; i > start; --i) {
        array[i] = array[i - 1];
    }
}

+ (void) binarySortArray:(NSMutableArray *)a withComparator:(Comparator)comparator withOrder:(NSInteger)order withLeft:(NSInteger) lo withRight: (NSInteger) hi withStart: (NSInteger)start {
    if (start == lo)
        start++;
    for ( ; start < hi; start++) {
        Student *pivot = a[start];
        
        // Set left (and right) to the index where a[start] (pivot) belongs
        NSInteger left = lo;
        NSInteger right = start;
        /*
         * Invariants:
         *   pivot >= all in [lo, left).
         *   pivot <  all in [right, start).
         */
        while (left < right) {
            NSInteger mid = ((left + right) >> 1);
            if (comparator(pivot, a[mid]) * order < 0)
                right = mid;
            else
                left = mid + 1;
        }
        
        /*
         * The invariants still hold: pivot >= all in [lo, left) and
         * pivot < all in [left, start), so pivot belongs at left.  Note
         * that if there are elements equal to pivot, left points to the
         * first slot after them -- that's why this sort is stable.
         * Slide elements over to make room to make room for pivot.
         */
        NSInteger n = start - left;  // The number of elements to move
        // Switch is just an optimization for arraycopy in default case
        switch(n) {
            case 2:  a[left + 2] = a[left + 1];
            case 1:  a[left + 1] = a[left];
                break;
            default: [SortAlgorithm shiftArray:a withStart:left withLength:n];
        }
        a[left] = pivot;
    }
}

NSInteger minMerge = 32;

+ (NSInteger) minRunLengthWithSize: (NSInteger) n {
    NSInteger r = 0;      // Becomes 1 if any 1 bits are shifted off
    while (n >= minMerge) {
        r |= (n & 1);
        n >>= 1;
    }
    return n + r;
}

+ (void) sortArray:(NSMutableArray *)array withComparator:(Comparator)comparator withOrder:(NSInteger)order {
    [SortAlgorithm sortArrayWithLimits:array withComparator:comparator withOrder:order withLeft:0 withRight:[array count]];
}

+ (void) sortArrayWithLimits:(NSMutableArray *)array withComparator:(Comparator)comparator withOrder:(NSInteger)order withLeft:(NSInteger) lo withRight: (NSInteger) hi {
    
    NSInteger nRemaining  = hi - lo;
    if (nRemaining < 2)
        return;  // Arrays of size 0 and 1 are always sorted
    
    // If array is small, do a "mini-TimSort" with no merges
    if (nRemaining < minMerge) {
        NSInteger initRunLen = [SortAlgorithm countRunAndMakeAscendingArray:array withComparator:comparator withOrder: order withLeft:lo withRight:hi];
        [SortAlgorithm binarySortArray: array withComparator: comparator withOrder: order withLeft: lo withRight: hi withStart: lo + initRunLen];
        return;
    }
    
    /**
     * March over the array once, left to right, finding natural runs,
     * extending short natural runs to minRun elements, and merging runs
     * to maintain stack invariant.
     */
    SortAlgorithm *ts = [[SortAlgorithm alloc] initWithArray:array withComparator:comparator withOrder:order];
    NSInteger minRun = [SortAlgorithm minRunLengthWithSize:nRemaining];
    do {
        // Identify next run
        NSInteger runLen = [SortAlgorithm countRunAndMakeAscendingArray:array withComparator:comparator withOrder:order withLeft:lo withRight:hi];
        
        // If run is short, extend to min(minRun, nRemaining)
        if (runLen < minRun) {
            NSInteger force = nRemaining <= minRun ? nRemaining : minRun;
            [SortAlgorithm binarySortArray:array withComparator:comparator withOrder:order withLeft:lo withRight:hi withStart:lo + runLen];
            runLen = force;
        }
        
        [ts pushRunWithRunBase: lo withRunLen: runLen];
        [ts mergeCollapse];
        
        // Advance to find next run
        lo += runLen;
        nRemaining -= runLen;
    } while (nRemaining != 0);
    
    // Merge all remaining runs to complete sort
    //[ts mergeForgeCollapse];
}

- (void) pushRunWithRunBase:(NSInteger) runBase withRunLen : (NSInteger)runLen {
    [self.runBase setObject:[NSNumber numberWithInteger:runBase] atIndexedSubscript:_stackSize];
    [self.runLen setObject:[NSNumber numberWithInteger:runLen] atIndexedSubscript:_stackSize];
    _stackSize++;
}

- (void) mergeCollapse {
    while (_stackSize > 1) {
        NSInteger n = _stackSize - 2;
        if (   (n >= 1 && [self.runLen[n-1] integerValue] <= [self.runLen[n] integerValue] + [self.runLen[n+1] integerValue])
            || (n >= 2 && [self.runLen[n-2] integerValue] <= [self.runLen[n] integerValue] + [self.runLen[n-1] integerValue])) {
            if ([self.runLen[n - 1] integerValue] < [self.runLen[n + 1] integerValue])
                n--;
        } else if ([self.runLen[n] integerValue] > [self.runLen[n + 1] integerValue]) {
            break; // Инвариант установлен
        }
        
        [self mergeAt: n];
    }
}

- (void) mergeAt: (NSInteger) i {
    NSInteger base1 = [self.runBase[i] integerValue];
    NSInteger len1 = [self.runLen[i] integerValue];
    NSInteger base2 = [self.runBase[i + 1] integerValue];
    NSInteger len2 = [self.runLen[i + 1] integerValue];
    
    /*
     * Record the length of the combined runs; if i is the 3rd-last
     * run now, also slide over the last run (which isn't involved
     * in this merge).  The current run (i+1) goes away in any case.
     */
    self.runLen[i] = [NSNumber numberWithInteger:len1 + len2];
    if (i == _stackSize - 3) {
        self.runBase[i + 1] = self.runBase[i + 2];
        self.runLen[i + 1] = self.runLen[i + 2];
    }
    _stackSize--;
    
    [self mergeWithLeftStart : base1 withLeftLen : len1 withRightStart : base2 withRightLen : len2];
}

- (void) mergeWithLeftStart : (NSInteger) leftStart withLeftLen : (NSInteger) leftLen withRightStart : (NSInteger) rightStart withRightLen : (NSInteger) rightLen {
    for (int i = 0; i < leftLen; ++i) {
        self.tmpLeft[i] = self.array[i + leftStart];
    }
    
    for (int i = 0; i < rightLen; ++i) {
        self.tmpRight[i] = self.array[i + rightStart];
    }
    
    for (NSInteger left = 0, right = 0, i = leftStart; left < leftLen || right < rightLen; ++i) {
        if (left == leftLen) {
            self.array[i] = self.tmpRight[right];
            ++right;
        } else if (right == rightLen) {
            self.array[i] = self.tmpLeft[left];
            ++left;
        } else if (_comparator(self.tmpLeft[left], self.tmpRight[right]) * _order <= 0) {
            self.array[i] = self.tmpLeft[left];
            ++left;
        } else {
            self.array[i] = self.tmpRight[right];
            ++right;
        }
    }
}

@end