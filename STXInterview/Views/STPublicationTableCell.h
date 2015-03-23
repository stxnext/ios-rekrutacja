//
//  STPublicationTableCell.h
//  STXInterview
//
//  Created by Dawid Żakowski on 19/02/2015.
//  Copyright (c) 2015 STX Next. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPublicationTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pagesCountLabel;

@end
