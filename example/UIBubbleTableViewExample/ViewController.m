//
//  ViewController.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

// 
// Images used in this example by Petr Kratochvil released into public domain
// http://www.publicdomainpictures.net/view-image.php?image=9806
// http://www.publicdomainpictures.net/view-image.php?image=1358
//

#import "ViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@interface ViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;

    NSMutableArray *bubbleData;
}

@property (nonatomic, weak) IBOutlet UIBubbleTableView *bubbleTable;

- (void)scrollToLastBubbleAnimated:(BOOL)animated;
- (NSIndexPath *)indexPathForLastBubble;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [[UIBubbleTableView appearance] setBackgroundColor:[UIColor lightGrayColor]];

    [super viewDidLoad];
    
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];

    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];

    self.bubbleTable.bubbleDataSource = self;

    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    self.bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)

    self.bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    self.bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    [self.bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDelegate implementation

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)numberOfRowsForBubbleTableView:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - UIScrollView implementation

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.bubbleTable && [textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSInteger options = UIViewAnimationOptionBeginFromCurrentState | animationCurve;

    // TODO: Need to translate the bounds to account for rotation (correct?)
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        CGRect frame = textInputView.frame;
        frame.origin.y -= keyboardHeight;
        textInputView.frame = frame;
        
        frame = self.bubbleTable.frame;
        // TODO: keep the bottom of the visible area of the bubble table in view as the keyboard slides up
        // One solution is to leave the origin unchanged and animate the bubble table height
        // while scrolling in sync.
        // Another option is to animate the origin (subtract). Then, change the origin (add),
        // height (subtract) and scroll position (add) with no animation in the completion block
        // Yet another option is to fix UIBubbleTable to pass along scroll-related messages
        // and then adjust origin.y here and resignFirstResponder as soon as bubbleTable begins scrolling.
        // Finally, one more option: flip the table so that the visible bottom is actually the top
        // in this scenario, we would be able to animate the height and it would shrink upward
        //   https://github.com/StephenAsherson/FlippedTableView
//        frame.size.height -= keyboardHeight;
        frame.origin.y -= keyboardHeight;
        self.bubbleTable.frame = frame;
    } completion:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSInteger options = UIViewAnimationOptionBeginFromCurrentState | animationCurve;

    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        CGRect frame = textInputView.frame;
        frame.origin.y += keyboardHeight;
        textInputView.frame = frame;
        
        frame = self.bubbleTable.frame;
//        frame.size.height += keyboardHeight;
        frame.origin.y += keyboardHeight;
        self.bubbleTable.frame = frame;
    } completion:^(BOOL finished) {
        [self scrollToLastBubbleAnimated:YES];
    }];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    self.bubbleTable.typingBubble = NSBubbleTypingTypeNobody;

    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    [self.bubbleTable reloadData];

    textField.text = @"";
    [textField resignFirstResponder];
}

#pragma mark Helpers

- (void)scrollToLastBubbleAnimated:(BOOL)animated
{
    [self.bubbleTable scrollToRowAtIndexPath:[self indexPathForLastBubble]
                            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:animated];
}

-(NSIndexPath *)indexPathForLastBubble
{
    NSInteger finalSection = [self.bubbleTable numberOfSections] - 1;
    NSInteger finalRow = [self.bubbleTable numberOfRowsInSection:finalSection] - 1;
    return [NSIndexPath indexPathForRow:finalRow inSection:finalSection];
}

@end
