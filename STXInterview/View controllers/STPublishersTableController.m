//
//  STPublishersTableController.m
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import "STPublishersTableController.h"
#import "STPublicationsTableController.h"

static NSString* kCoreDataFetchCachePublishers = @"kCoreDataFetchCachePublishers";

@interface STPublishersTableController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation STPublishersTableController

#pragma mark - View controller cycle and transitions

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSError *error;
    
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[STPublicationsTableController class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        STPublisher* selectedPublisher = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        STPublicationsTableController* controller = (STPublicationsTableController*)segue.destinationViewController;
        controller.publisher = selectedPublisher;
    }
}

#pragma mark - Fetched results controller

- (NSManagedObjectContext*)managedObjectContext
{
    return [[STStoreManager sharedManager] managedObjectContext];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([STPublisher class]) inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:[self managedObjectContext]
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:kCoreDataFetchCachePublishers];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(STPublisherTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    STPublisher *publisher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = publisher.name;
    cell.addressLabel.text = publisher.address;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = NSStringFromClass([STPublisherTableCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:(id)cell atIndexPath:indexPath];
    
    return cell;
}

@end
