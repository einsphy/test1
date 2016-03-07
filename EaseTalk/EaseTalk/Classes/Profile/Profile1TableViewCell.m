//
//  Profile1TableViewCell.m
//  EaseTalk
//
//  Created by einsphy on 16/3/8.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "Profile1TableViewCell.h"

@implementation Profile1TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.dogImageView = [[UIImageView alloc]init];
        self.dogImageView.frame  = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
        
        [self addSubview:self.dogImageView];
    }

    return self;

}

@end
