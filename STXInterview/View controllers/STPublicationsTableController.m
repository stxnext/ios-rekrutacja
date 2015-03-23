//
//  STPublicationsTableController.m
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import "STPublicationsTableController.h"
#import "STPublicationPageController.h"

@interface STPublicationsTableController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation STPublicationsTableController

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
    if ([segue.destinationViewController isKindOfClass:[STPublicationPageController class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        STPublication* selectedPublication = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        STPublicationPageController* controller = (STPublicationPageController*)segue.destinationViewController;
        controller.publication = selectedPublication;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([STPublication class]) inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"publisher = %@", self.publisher];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:[self managedObjectContext]
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:self.publisher.objectID.URIRepresentation.absoluteString];
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

- (void)configureCell:(STPublicationTableCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    STPublication *publication = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = publication.name;
    cell.dateLabel.text = [NSDateFormatter localizedStringFromDate:publication.date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
    cell.pagesCountLabel.text = [NSString stringWithFormat:@"%d page(s)", (int)publication.pages.count];
    
    if ([publication isKindOfClass:[STMagazine class]])
    {
        STMagazine* mappedPublication = (STMagazine*)publication;
        STMagazineTableCell* mappedCell = (STMagazineTableCell*)cell;
        mappedCell.frequencyLabel.text = [NSString stringWithFormat:@"each %@ days", mappedPublication.frequency];
    }
    else if ([publication isKindOfClass:[STBook class]])
    {
        STBook* mappedPublication = (STBook*)publication;
        STBookTableCell* mappedCell = (STBookTableCell*)cell;
        mappedCell.coverLabel.text = [NSString stringWithFormat:@"%@ cover", mappedPublication.cover];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    STPublication *publication = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([publication isKindOfClass:[STMagazine class]])
    {
        cellIdentifier = NSStringFromClass([STMagazineTableCell class]);
    }
    else if ([publication isKindOfClass:[STBook class]])
    {
        cellIdentifier = NSStringFromClass([STBookTableCell class]);
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:(id)cell atIndexPath:indexPath];
    
    return cell;
}

@end
