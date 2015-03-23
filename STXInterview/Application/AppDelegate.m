//
//  AppDelegate.m
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import "AppDelegate.h"
#import "STStoreManager+FakeCoreData.h"

@implementation AppDelegate

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize database
    [self initDatabase];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveDatabase];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveDatabase];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveDatabase];
}

#pragma mark - Core data

- (void)initDatabase
{
    // Insert fake database entries if it's empty
    [[STStoreManager sharedManager] populateIfEmpty];
}

- (void)saveDatabase
{
    // Save database
    [[STStoreManager sharedManager] saveContext];
}

@end
