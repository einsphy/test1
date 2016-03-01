//
//  HXAlert.m
//  EaseTalk
//
//  Created by einsphy on 16/3/1.
//  Copyright © 2016年 einsphy. All rights reserved.
//

#import "HXAlert.h"

@implementation HXAlert
+ (void)showAlertViewAtViewController:(UIViewController *)viewController withTitle:(NSString *)title message:(NSString *)message confirmMessage:(NSString *)confirmMessahe confirmStyle:(UIAlertActionStyle)confirmStyle confirmHandler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))confirmHandler cancelMessage:(NSString *)cancelMessage cancelStyle:(UIAlertActionStyle)cancelStyle cancleHandler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))cancleHandler
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    
    UIAlertAction *warningAction = [UIAlertAction actionWithTitle:confirmMessahe style:(UIAlertActionStyleDefault) handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelMessage style:cancelStyle handler:nil];
    
    [alertVC addAction:warningAction];
    [alertVC addAction:cancelAction];
    
    
    [viewController presentViewController:alertVC animated:YES completion:nil];


}
@end
