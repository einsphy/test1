//
//  HXAlert.h
//  EaseTalk
//
//  Created by einsphy on 16/3/1.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXAlert : NSObject

+ (void)showAlertViewAtViewController:(UIViewController *)viewController withTitle:(NSString *)title message:(NSString *)message confirmMessage:(NSString *)confirmMessahe confirmStyle:(UIAlertActionStyle)confirmStyle confirmHandler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))confirmHandler cancelMessage:(NSString *)cancelMessage cancelStyle:(UIAlertActionStyle)cancelStyle cancleHandler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))cancleHandler;

@end
