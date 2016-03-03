//
//  DialogBoxView.h
//  EaseTalk
//
//  Created by einsphy on 16/3/3.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonClicked)(NSString *draftText);
@interface DialogBoxView : UIView

@property (nonatomic, copy)ButtonClicked buttonClickd;

@end
