//
//  UserChatController.m
//  Umka
//
//  Created by Igor Zalisky on 12/11/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserChatController.h"
#import "ChatCell.h"
#import "ZHCMessagesEmojiView.h"
#import "AppDelegate.h"
#import "UIImage+ZHCMessages.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

#define K_TEXTFIELD_PLACEHOLDER NSLocalizedString(@"Введите сообщение",@"")

@interface UserChatController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZHCEmojiViewDelegate,MWPhotoBrowserDelegate>
{
    NSMutableArray *photos;
    CGFloat _currentKeyboardHeight;
    BOOL needShowEmoji;
    BOOL needScrollToBottom;
}
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSMutableArray *sortedDays;
@property (strong, nonatomic) NSMutableArray *allMessages;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@property (strong, nonatomic) IBOutlet UIView *chatBar;
@property (strong, nonatomic) IBOutlet UITextView *chatField;
@property (strong, nonatomic) IBOutlet UIButton *smileBtn;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger allMessageLoaded;
@property (strong, nonatomic) ZHCMessagesEmojiView *messageEmojiView;
@end

@implementation UserChatController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChat) name:@"K_RELOAD_CHAT_NAME" object:nil];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    needScrollToBottom = NO;
    self.chatField.text = K_TEXTFIELD_PLACEHOLDER;
    _currentKeyboardHeight = 0.0;
    self.chatField.delegate = self;
    self.page = 1;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.title = NSLocalizedString(@"Чат",@"");
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getNextPage)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView reloadData];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    [self loadMessages:@"1"];
    
    UITableViewCell *cell  = [[self.tableView visibleCells] lastObject];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 30, 44)];
    [editBtn setImage:[UIImage imageNamed:@"ic_navbar_call"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)reloadChat{
    needScrollToBottom =YES;
    [self loadMessages:@"1"];
}

- (void)callAction
{
    /*[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.user.phone]]];*/
}

- (void)dismissKeyboard
{
    if (_currentKeyboardHeight>0)
    {
         [UIView setAnimationsEnabled:YES];
        if (_currentKeyboardHeight==210)[self hiddenEmojiView:NO];
        else [self.chatField resignFirstResponder];
    }
}

-(void)initialSubViews
{
    if (!_messageEmojiView) {
        self.messageEmojiView.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 210);
        [self.navigationController.view addSubview:self.messageEmojiView];
    }
}

- (void)loadMessages:(NSString*)page
{
    [[ApiManager new] getMessages:self.dialog.id completition:^(id response, NSError *error) {
                                        if (!self.allMessages)self.allMessages = [[NSMutableArray alloc] init];
        [self.allMessages removeAllObjects];
                                        for (NSDictionary *dict in response[@"messages"]){
                                            Message *model = [[Message alloc] initWithDictionary:dict];
                                            [self addModel:model];
                                        }
                                        
                                        [self reloadMessages:self.allMessages];
                                        [self.refreshControl endRefreshing];
                                    }];
}

- (void)addModel:(Message*)model
{
    Message *replaceModel = nil;
    for (Message *oldModel in self.allMessages){
        if (oldModel.id.integerValue==model.id.integerValue)
        {
            replaceModel = oldModel;
            break;
        }
    }
    if (replaceModel!=nil)[self.allMessages removeObject:replaceModel];
    [self.allMessages addObject:model];
}

- (void)reloadMessages:(NSArray *)allMessages
{
    self.sortedDays = [[NSMutableArray alloc] init];
    [self.sortedDays removeAllObjects];
    
    self.sections = [NSMutableDictionary dictionary];
    for (Message *event in allMessages)
    {
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.date];
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        [eventsOnThisDay addObject:event];
    }
    
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [[unsortedDays sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    if (self.allMessages.count>0 && needScrollToBottom ==YES)
    {
        [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.001];
        needScrollToBottom = YES;
       // [[self tableView] reloadData];
    }
    else [self scrollToBottomWithoutAnimation];
}

- (void)scrollToBottom
{
    [[self tableView] reloadData];
    NSDate *dateRepresentingThisDay = [self.sortedDays lastObject];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:eventsOnThisDay.count-1 inSection:self.sortedDays.count-1];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollToBottomWithoutAnimation
{
    if (self.allMessages.count>0)
    {
        [[self tableView] reloadData];
    NSDate *dateRepresentingThisDay = [self.sortedDays lastObject];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:eventsOnThisDay.count-1 inSection:self.sortedDays.count-1];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialSubViews];
    self.chatBar.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
    self.chatBar.alpha = 0.0;
    [self.navigationController.view addSubview:self.chatBar];
    [UIView animateWithDuration:0.33 animations:^{
        self.chatBar.alpha = 1.0;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [UIView setAnimationsEnabled:YES];
    [self.chatBar removeFromSuperview];
    [self.messageEmojiView removeFromSuperview];
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}

- (void)getSectionsFromAllMessages:(NSArray*)messages
{
    
}

- (void)getNextPage
{
    needScrollToBottom = NO;
    self.page = self.allMessages.count/20+1;
    [self loadMessages:[NSString stringWithFormat:@"%ld",self.page]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.allMessages.count==0 ||!self.allMessages)return 1;
    else
    {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allMessages.count==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"EmptyCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if (!self.allMessages)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"LoadingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = NSLocalizedString(@"Загрузка...",@"");
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
    else if (self.sortedDays>0)
    {
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedEventsOnThisDay = [eventsOnThisDay sortedArrayUsingDescriptors:sortDescriptors];
        
        
        Message *model = [sortedEventsOnThisDay objectAtIndex:indexPath.row];
        NSString *iden = (model.isSelf)?@"UserChatCell":@"ChatCell";
        if (model.pic.length>0) iden = (model.isSelf)?@"UserChatCell1":@"ChatCell1";
        ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:iden];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dialog = self.dialog;
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"EmptyCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 20.0)];
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    lbl.text = [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    lbl.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    return lbl;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _currentKeyboardHeight = kbSize.height;
    
    [UIView animateWithDuration:0.33 animations:^{
        self.chatBar.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height-44-_currentKeyboardHeight, [UIScreen mainScreen].bounds.size.width, 44);
    }completion:^(BOOL finished) {
        [self scrollToBottomWithoutAnimation];
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _currentKeyboardHeight = 0.0f;
    [UIView animateWithDuration:0.33 animations:^{
        self.chatBar.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height-44-_currentKeyboardHeight, [UIScreen mainScreen].bounds.size.width, 44);
    }completion:^(BOOL finished) {
        if(needShowEmoji)[self showEmojiViewAnimation];
    }];
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [UIView setAnimationsEnabled:NO];
    if ([textView.text isEqualToString:K_TEXTFIELD_PLACEHOLDER])
        textView.text = @"";
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length==0)
    {
        textView.text=K_TEXTFIELD_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self sendMessage:textView.text];
        textView.text = @"";        
        return NO;
    }
    
    return YES;
}


- (void)sendMessage:(NSString*)text
{
    
   // text = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    needScrollToBottom =YES;
    self.chatField.text = @"";
    BOOL ce = [self stringContainsEmoji:text];
    if (ce){
    NSData *data = [text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    [[ApiManager new] sendMessage:@{@"chat":self.dialog.id,@"text":text} image:nil completition:^(id response, NSError *error) {
        Message *model = [[Message alloc] initWithDictionary:response];
        model.pic = nil;
        if (response){
            [self.allMessages addObject:model];
            [self reloadMessages:self.allMessages];
        }
         [SVProgressHUD dismiss];
    }];
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

-(IBAction)chooseFile:(id)sender
{
    [self.view endEditing:YES];
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Прикрепить файл",@"")
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    view.popoverPresentationController.sourceView = self.view;
    view.popoverPresentationController.sourceRect = self.view.bounds;
    
    UIAlertAction* gallery = [UIAlertAction
                              actionWithTitle:NSLocalizedString(@"Фотогалерея",@"")
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self selectFile:NO];
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
    [view addAction:gallery];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction* camera = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Камера",@"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self selectFile:YES];
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [view addAction:camera];
    }
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Отмена",@"")
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)selectFile:(BOOL)camera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = (camera)?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self sendImage:image];
    
}

- (void)sendImage:(UIImage*)image
{
    needScrollToBottom =YES;
    [[ApiManager new] sendMessage:@{@"text":@"",@"chat":self.dialog.id} image:image completition:^(id response, NSError *error) {
            Message *model = [[Message alloc] initWithDictionary:response];
            if (response){
                
                [self.allMessages addObject:model];
                [self performSelector:@selector(imageDidLoad) withObject:nil afterDelay:2.0];
               
            }
        
    }];
}

- (void)imageDidLoad{
     [SVProgressHUD dismiss];
     [self reloadMessages:self.allMessages];
}


#pragma mark - ZHCEmojiViewDelegate

-(IBAction)showEmojiView
{
    if (self.messageEmojiView.frame.origin.y == [UIScreen mainScreen].bounds.size.height)
    {
        needShowEmoji = YES;
        [self.smileBtn setImage:[UIImage zhc_defaultKeyboardImage] forState:UIControlStateNormal];
        [self.chatField resignFirstResponder];
        if (_currentKeyboardHeight==0)[self showEmojiViewAnimation];
    }
    else [self hiddenEmojiView:YES];
}

- (void)showEmojiViewAnimation
{
    needShowEmoji = NO;
    self.chatField.userInteractionEnabled = NO;
    _currentKeyboardHeight = 210.0f;
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.chatBar.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height-44-_currentKeyboardHeight, [UIScreen mainScreen].bounds.size.width, 44);
                         self.messageEmojiView.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height-_currentKeyboardHeight, [UIScreen mainScreen].bounds.size.width, 210);
                         self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, _currentKeyboardHeight+10, 0.0);
                     }
                     completion:^(BOOL finished){
                         self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, _currentKeyboardHeight+10, 0.0);
                         [self scrollToBottomWithoutAnimation];
                         [UIView setAnimationsEnabled:NO];
                     }];
}

-(void)hiddenEmojiView:(BOOL)showKeyboard
{
    self.chatField.userInteractionEnabled = YES;
     [self.smileBtn setImage:[UIImage imageNamed:@"smile_ico"] forState:UIControlStateNormal];
    _currentKeyboardHeight = 0.0f;
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.chatBar.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height-44-_currentKeyboardHeight, [UIScreen mainScreen].bounds.size.width, 44);
                         self.messageEmojiView.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 210);
                         [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 10, 0.0)];
                     }
                     completion:^(BOOL finished){
                         if (showKeyboard)[self.chatField becomeFirstResponder];
                     }];

}

-(ZHCMessagesEmojiView *)messageEmojiView
{
    if (!_messageEmojiView) {
        _messageEmojiView = [[ZHCMessagesEmojiView alloc]init];
        _messageEmojiView.delegate = self;
    }
    return _messageEmojiView;
}

-(void)emojiView:(ZHCMessagesEmojiView *)emojiView didSelectEmoji:(NSString *)emoji
{
    if ([self.chatField.text isEqualToString:K_TEXTFIELD_PLACEHOLDER])self.chatField.text = @"";
    self.chatField.textColor = [UIColor blackColor];
    
    self.chatField.text = [self.chatField.text stringByAppendingString:emoji];
}


-(void)emojiView:(ZHCMessagesEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton
{
    if (self.chatField.text.length > 0) {
        NSRange lastRange = [self.chatField.text rangeOfComposedCharacterSequenceAtIndex:(self.chatField.text.length-1)];
        self.chatField.text = [self.chatField.text substringToIndex:lastRange.location];
    }
    
}

-(void)emojiView:(ZHCMessagesEmojiView *)emojiView didPressSendButton:(UIButton *)sendButton
{
   if (self.chatField.text.length>0)[self sendMessage:self.chatField.text];
}



#pragma mark Photo Browser

- (void)setupPhotoBrouser:(NSString*)url{
    photos = [NSMutableArray array];
    NSInteger index = 0;
    for (Message *message in self.allMessages){
        if (message.pic.length>0)
        {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:message.pic]]];
            if ([message.pic isEqualToString:url]) index = [photos count]-1;
        }
        
    }
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    
    // Present
    [[self navigationController] pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:index];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count) {
        return [photos objectAtIndex:index];
    }
    return nil;
}


@end
