//
//  STPublisher.h
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPublication;

@interface STPublisher : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSSet *publications;
@end

@interface STPublisher (CoreDataGeneratedAccessors)

- (void)addPublicationsObject:(STPublication *)value;
- (void)removePublicationsObject:(STPublication *)value;
- (void)addPublications:(NSSet *)values;
- (void)removePublications:(NSSet *)values;

@end
