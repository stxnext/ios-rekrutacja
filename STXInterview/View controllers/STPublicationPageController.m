//
//  STPublicationPageController.m
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import "STPublicationPageController.h"
#import "STPageViewController.h"

@interface STPublicationPageController () <UIPageViewControllerDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation STPublicationPageController

#pragma mark - View controller cycle and transitions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSError *error;
    
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    STPageViewController* firstPageController = [self pageControllerAtIndex:0];
    [self setViewControllers:@[ firstPageController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Data source

- (STPageViewController*)pageControllerAtIndex:(NSInteger)index
{
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections.firstObject;
    NSUInteger pagesCount = section.numberOfObjects;
    
    if (index < 0 || index >= pagesCount)
    {
        return nil;
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    STPage* page = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    STPageViewController* pageController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([STPageViewController class])];
    pageController.page = page;
    
    [self addChildViewController:pageController];
    
    [pageController.view setNeedsLayout];
    [pageController.view layoutIfNeeded];
    
    return pageController;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([STPage class]) inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"publication = %@", self.publication];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:[self managedObjectContext]
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:self.publication.objectID.URIRepresentation.absoluteString];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(STPageViewController *)viewController
{
    NSUInteger oldPageIndex = [self.fetchedResultsController indexPathForObject:viewController.page].item;
    STPageViewController* newPageController = [self pageControllerAtIndex:oldPageIndex - 1];
    
    return newPageController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(STPageViewController *)viewController
{
    NSUInteger oldPageIndex = [self.fetchedResultsController indexPathForObject:viewController.page].item;
    STPageViewController* newPageController = [self pageControllerAtIndex:oldPageIndex + 1];
    
    return newPageController;
}

@end
