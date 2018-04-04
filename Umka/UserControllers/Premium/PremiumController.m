//
//  PremiumController.m
//  Umka
//
//  Created by Ігор on 25.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import "PremiumController.h"

#define kRiseUpProductIdentifier @"city.umka.riseup"
#define kRiseUp3ProductIdentifier @"city.umka.riseup3"
#define kRiseUp5ProductIdentifier @"city.umka.riseup5"

#define kPremiumSubscrIdentifier @"city.umka.premium"
#define kPremium3SubscrIdentifier @"city.umka.premium3"
#define kPremium6SubscrIdentifier @"city.umka.premium6"
#define kPremium12SubscrIdentifier @"city.umka.premium12"

@interface PremiumController ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) NSArray *items;
@end

@implementation PremiumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = NSLocalizedString(@"Премиум функции",@"");
    self.items = @[
                   @{@"section":NSLocalizedString(@"Премиум аккаунт", @""),@"icon":@"payment2",@"descr":NSLocalizedString(@"Ваша анкета будет отображаться в верху списка специалистов для пользователей раз в неделю. Так же вы сможете загрузить до 20 работ в портфолио",@"") ,
                     @"items":@[
                             @{@"title":NSLocalizedString(@"на месяц", @""),@"price":@"299₽"},
                             @{@"title":NSLocalizedString(@"на три месяца", @""),@"price":@"599₽"},
                             @{@"title":NSLocalizedString(@"на пол года", @""),@"price":@"999₽"},
                             @{@"title":NSLocalizedString(@"на год", @""),@"price":@"1490₽"}
                             ]},
                   @{@"section":NSLocalizedString(@"Поднять анкету",@""),@"icon":@"payment1",@"descr":NSLocalizedString(@"Ваша анкета будет отображаться в верху списка специалистов для пользователей",@""),
                     @"items":@[
                             @{@"title":NSLocalizedString(@"один раз", @""),@"price":@"75₽"},
                             @{@"title":NSLocalizedString(@"три раза три дня", @""),@"price":@"149₽"},
                             @{@"title":NSLocalizedString(@"пять раз пять дней", @""),@"price":@"229₽"}
                             ]}
                   ];
   // [self checkPayment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = self.items[section][@"items"];
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *obj = self.items[section];
    static NSString *HeaderCellIdentifier = @"header";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier];
    }
    
    UILabel *title = [cell.contentView viewWithTag:100];
    title.text = obj[@"section"];
    
    UILabel *descr = [cell.contentView viewWithTag:200];
    descr.text = obj[@"descr"];
    
    UIImageView *imgv = [cell.contentView viewWithTag:300];
    imgv.image = [UIImage imageNamed:obj[@"icon"]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *rows = self.items[indexPath.section][@"items"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    UILabel *title = [cell.contentView viewWithTag:100];
    title.text = rows[indexPath.row][@"title"];
    
    UILabel *price = [cell.contentView viewWithTag:200];
    price.text = [NSString stringWithFormat:@"%@ - %@",NSLocalizedString(@"Стоимость услуги", @""),rows[indexPath.row][@"price"]];
    UIButton *buy = [cell.contentView viewWithTag:300];
    [buy setTitle:NSLocalizedString(@"Купить", @"") forState:UIControlStateNormal];
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tapsRemoveAds:indexPath];
}


#define kRemoveAdsProductIdentifier @"put your product id (the one that we just made in iTunesConnect) in here"

- (IBAction)tapsRemoveAds:(NSIndexPath*)ip{
    [SVProgressHUD show];
    NSInteger index = ip.row;
    NSString *key = @"";
    if (ip.section==0)
        key = (index==0)?kPremiumSubscrIdentifier:(index==1)?kPremium3SubscrIdentifier:(index==2)?kPremium6SubscrIdentifier:kPremium12SubscrIdentifier;
    if (ip.section==1)
        key = (index==0)?kRiseUpProductIdentifier:(index==1)?kRiseUp3ProductIdentifier:kRiseUp5ProductIdentifier;
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:key]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        [SVProgressHUD dismiss];
        NSLog(@"User cannot make payments due to parental controls");
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        [SVProgressHUD dismiss];
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                [SVProgressHUD dismiss];
                break;
            case SKPaymentTransactionStatePurchased:
            {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                NSString *receiptStr = [receipt base64EncodedStringWithOptions:0];
                [self verifyPayment:@{@"receipt":receiptStr,
                                      @"platform":@"ios"}];
                [SVProgressHUD dismiss];
            }
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [SVProgressHUD dismiss];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    [SVProgressHUD dismiss];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)verifyPayment:(NSDictionary*)params{
    NSLog(@"%@",params);
    [[ApiManager new] payments:params completition:^(id response, NSError *error) {
        //NSLog(@"%@",response);
    }];
}



@end
