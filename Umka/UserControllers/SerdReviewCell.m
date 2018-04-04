//
//  SerdReviewCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "SerdReviewCell.h"
#import "ApiManager.h"
#import "SendReviewController.h"
#import "ReviewModel.h"

@implementation SerdReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textFieldBG.layer.cornerRadius = 35.0/2.0;
    self.textFieldBG.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1.0].CGColor;
    self.textFieldBG.layer.borderWidth = 1.0;
    self.textField.placeholder = NSLocalizedString(@"Ваш отзыв", @"");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReview:(ReviewModel *)review{
    if (self.review!=review){
        _review = review;
        self.textField.text = review.review_message;
        self.ratingView.value = review.review_rating.floatValue;
    }
}

- (IBAction)sendReview:(id)sender
{
    if (self.ratingView.value==0)
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                              message:NSLocalizedString(@"Укажите количество звезд",@"")
                                              preferredStyle:UIAlertControllerStyleAlert];

        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:okAction];
        [self.delegate presentViewController:alertController animated:YES completion:nil];
    }
    else if (self.textField.text.length==0)
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                              message:NSLocalizedString(@"Отзыв не может быть пустым",@"")
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
         [alertController addAction:okAction];
        [self.delegate presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        if (self.review)[self updateReview:@{@"rating":[NSString stringWithFormat:@"%.0f.0",self.ratingView.value],
                                             @"text":self.textField.text} reviewID:self.review.review_id];
        else [self sendReviewRequest];
    }
}

- (void)sendReviewRequest
{
    NSDictionary *params = @{@"writter":[NSNumber numberWithInteger:[UmkaUser userID]],
                             @"master":self.order.master.id,
                             @"rating":[NSString stringWithFormat:@"%.0f.0",self.ratingView.value],
                             @"text":self.textField.text};
    [[ApiManager new] sendReview:params completition:^(id response, NSError *error) {
        NSLog(@"%@",response);
                                       if ([response[@"message"] isEqualToString:@"recall exist, you may update it"])
                                           [self updateAlert:response andParams:params];
                                       else {
                                           [self.delegate loadReviews];
                                           [self successAlert:NSLocalizedString(@"Отзыв успешно отправлен", @"")];
                                       }
        
    }];
}

- (void)updateReview:(NSDictionary*)params reviewID:(NSString*)reviewID{
    [[ApiManager new] updateReview:params reviewID:reviewID completition:^(id response, NSError *error) {
        [self.delegate loadReviews];
        [self successAlert:NSLocalizedString(@"Отзыв успешно обновлен", @"")];
    }];
}

- (void)updateAlert:(id)response andParams:(NSDictionary*)params{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                          message:NSLocalizedString(@"Вы уже писали отзыв об этом специалисте. Хотите изменить его?",@"")
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    UIAlertAction *changeAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Изменить", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self updateReview:params reviewID:response[@"id"]];
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:changeAction];
    [self.delegate presentViewController:alertController animated:YES completion:nil];
}

- (void)successAlert:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    [alertController addAction:okAction];
    [self.delegate presentViewController:alertController animated:YES completion:nil];
    [self.textField resignFirstResponder];
}

@end
