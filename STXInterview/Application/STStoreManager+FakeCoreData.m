//
//  STStoreManager+FakeCoreData.m
//  STXInterview
//
//  Created by Dawid Żakowski on 23/03/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import "STStoreManager+FakeCoreData.h"

@implementation STStoreManager (FakeCoreData)

#pragma mark - Helpers

+ (NSSet*)fakePagesWithCount:(NSUInteger)count inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSMutableSet* pages = [NSMutableSet set];
    
    for (NSInteger i = 0; i < count; i++)
    {
        // Insert page with number based on iteration and some fake content
        STPage* page = (STPage*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STPage class]) inManagedObjectContext:context];
        page.number = @( i + 1 );
        page.content = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla non felis eu orci scelerisque egestas. Quisque interdum nulla vel venenatis varius. Morbi malesuada nibh id elit egestas varius. Quisque lacinia, augue et laoreet fermentum, orci turpis vehicula nulla, et sodales purus eros nec ante. Etiam nec lectus pharetra, dapibus nulla et, euismod velit. Praesent laoreet eu enim eget posuere. Vestibulum placerat lacus ut ornare malesuada. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis convallis bibendum purus, vel iaculis ligula euismod vitae. Duis cursus, diam a dignissim vehicula, nisl elit bibendum magna, nec venenatis tellus magna et mauris. Curabitur at dolor a purus tempor mollis. Fusce auctor enim vel velit euismod porttitor. Curabitur consequat sapien eu ipsum mattis, et tristique augue pulvinar. Ut et augue eu ante commodo viverra. Etiam consectetur sapien risus, a facilisis tellus vehicula ut. Donec nisl lorem, finibus at scelerisque non, luctus eu libero. Aliquam erat volutpat. Nam ante ex, laoreet et lectus eu, iaculis egestas elit. Aenean eleifend massa eu nulla viverra maximus. Phasellus urna ligula, cursus sed elementum eget, ornare id eros. Nam id metus nibh. Etiam eget urna maximus, suscipit ante quis, gravida tortor. Sed dignissim est eu sem dapibus vehicula. Aenean sit amet nunc risus. Morbi tellus nunc, aliquam id ornare ut, bibendum sit amet ex. Vestibulum efficitur risus ac lobortis feugiat. Vivamus eleifend velit et sem ultrices tempus. Nam pulvinar tristique sodales. Aliquam tincidunt sodales risus, vitae venenatis quam rhoncus non. Phasellus elementum ac nunc at pretium. Vivamus nec lobortis metus, non blandit tellus. Sed venenatis lacus quis rutrum dictum. Nam ut mi lacinia, posuere magna a, tincidunt quam. Quisque venenatis arcu nunc, sed consectetur est volutpat a. Nullam iaculis sit amet arcu eu euismod. Suspendisse id neque tincidunt, vestibulum justo sit amet, luctus justo. Aenean hendrerit dolor at lacinia tristique. Aliquam nec magna nec tortor sollicitudin luctus ut eu tortor. Quisque eget euismod ex. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Integer sed elit vel mauris imperdiet pellentesque non varius justo. Maecenas pellentesque lorem a sapien eleifend, eu euismod sem tristique. Ut porttitor ullamcorper enim ut ultrices. Praesent dictum mi euismod dolor ornare pellentesque. Cras dignissim ligula eu quam elementum, sit amet viverra mi maximus. Morbi ac nibh ex. Aenean molestie tellus non ante vehicula pharetra quis ac ante. Proin iaculis massa eget tellus porta, eget mollis ex gravida. Donec accumsan risus nec lacus accumsan, non tincidunt nisi ultricies. Integer nec molestie mauris. Donec egestas placerat nisi id aliquam. Donec accumsan, elit nec pellentesque eleifend, lacus ex scelerisque nisi, ultrices commodo metus odio non sapien. Nam eu quam tellus. In non tellus sit amet est euismod consequat. Mauris interdum, purus id tempor elementum, nunc purus tincidunt dui, eget dignissim metus libero vel augue.";
        
        [pages addObject:page];
    }
    
    return pages;
}

#pragma mark - Data population

- (void)populateIfEmpty
{
    // Count existing database publishers
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([STPublisher class])];
    NSManagedObjectContext* context = [self managedObjectContext];
    
    NSError* error;
    NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // If database doesn't contain any publisher, insert some fake data
    if (count == 0)
    {
        [self populate];
    }
}

- (void)populate
{
    // Create child adding context for inserting
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [addingContext setParentContext:self.managedObjectContext];
    
    // Create fake data
    STMagazine* magazine1 = (STMagazine*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STMagazine class]) inManagedObjectContext:addingContext];
    magazine1.name = @"Facebook daily";
    magazine1.date = [NSDate dateWithTimeIntervalSince1970:1423526400];
    magazine1.frequency = @"14";
    [magazine1 addPages:[self.class fakePagesWithCount:5 inManagedObjectContext:addingContext]];
    
    STMagazine* magazine2 = (STMagazine*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STMagazine class]) inManagedObjectContext:addingContext];
    magazine2.name = @"Twitter news";
    magazine2.date = [NSDate dateWithTimeIntervalSince1970:1423094400];
    magazine2.frequency = @"1";
    [magazine2 addPages:[self.class fakePagesWithCount:2 inManagedObjectContext:addingContext]];
    
    STMagazine* magazine3 = (STMagazine*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STMagazine class]) inManagedObjectContext:addingContext];
    magazine3.name = @"PC for elders";
    magazine3.date = [NSDate dateWithTimeIntervalSince1970:1422748800];
    magazine3.frequency = @"30";
    [magazine3 addPages:[self.class fakePagesWithCount:10 inManagedObjectContext:addingContext]];
    
    STBook* book1 = (STBook*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STBook class]) inManagedObjectContext:addingContext];
    book1.name = @"Dev docs";
    book1.date = [NSDate dateWithTimeIntervalSince1970:1423526400];
    book1.cover = @"Hard";
    [book1 addPages:[self.class fakePagesWithCount:3 inManagedObjectContext:addingContext]];
    
    STBook* book2 = (STBook*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STBook class]) inManagedObjectContext:addingContext];
    book2.name = @"iOS bible";
    book2.date = [NSDate dateWithTimeIntervalSince1970:1423094400];
    book2.cover = @"Hard";
    [book2 addPages:[self.class fakePagesWithCount:100 inManagedObjectContext:addingContext]];
    
    STBook* book3 = (STBook*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STBook class]) inManagedObjectContext:addingContext];
    book3.name = @"Android for the poor";
    book3.date = [NSDate dateWithTimeIntervalSince1970:1423094400];
    book3.cover = @"Soft";
    [book3 addPages:[self.class fakePagesWithCount:50 inManagedObjectContext:addingContext]];
    
    STPublisher* publisher1 = (STPublisher*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STPublisher class]) inManagedObjectContext:addingContext];
    publisher1.name = @"TechCrunch";
    publisher1.address = @"USA";
    [publisher1 addPublicationsObject:magazine1];
    [publisher1 addPublicationsObject:magazine2];
    
    STPublisher* publisher2 = (STPublisher*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STPublisher class]) inManagedObjectContext:addingContext];
    publisher2.name = @"IJReview";
    publisher2.address = @"USA";
    
    STPublisher* publisher3 = (STPublisher*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([STPublisher class]) inManagedObjectContext:addingContext];
    publisher3.name = @"Axel Springer";
    publisher3.address = @"Europe";
    [publisher3 addPublicationsObject:magazine3];
    [publisher3 addPublicationsObject:book1];
    [publisher3 addPublicationsObject:book2];
    [publisher3 addPublicationsObject:book3];
    
    // Save the main context
    [self saveContext];
}

@end
