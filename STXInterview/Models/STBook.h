//
//  STBook.h
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STPublication.h"


@interface STBook : STPublication

@property (nonatomic, retain) NSString * cover;

@end
