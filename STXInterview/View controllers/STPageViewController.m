//
//  STPageViewController.m
//  STXInterview
//
//  Created by Dawid Żakowski on 23/03/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import "STPageViewController.h"

@interface STPageViewController ()

@property (nonatomic, strong) IBOutlet UITextView* textView;

@end

@implementation STPageViewController

#pragma mark - View controller cycle and transitions

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textView.text = self.page.content;
    self.textView.contentOffset = CGPointZero;
}

@end
