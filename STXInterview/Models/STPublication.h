//
//  STPublication.h
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPage, STPublisher;

@interface STPublication : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) STPublisher *publisher;
@property (nonatomic, retain) NSSet *pages;
@end

@interface STPublication (CoreDataGeneratedAccessors)

- (void)addPagesObject:(STPage *)value;
- (void)removePagesObject:(STPage *)value;
- (void)addPages:(NSSet *)values;
- (void)removePages:(NSSet *)values;

@end
