//
//  UIBubbleTypingTableCell.m
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import "SGBubbleTableViewTypingCell.h"

static int const kSGBubbleTableViewTypingCellOffsetY = 4;
static int const kSGBubbleTableViewTypingCellWidth = 73;
static int const kSGBubbleTableViewTypingCellHeight = 31;

@interface SGBubbleTableViewTypingCell ()

@property (nonatomic, retain) UIImageView *typingImageView;

@end

@implementation SGBubbleTableViewTypingCell

@synthesize typingImageView = _typingImageView;
@synthesize showAvatar = _showAvatar;

+ (SGBubbleTableViewTypingCell *)cellWithDirection:(SGBubbleTypingDirection)direction reuseIdentifier:(NSString *)reuseIdentifier
{
    SGBubbleTableViewTypingCell *cell = nil;

    switch (direction) {
        case SGBubbleTypingDirectionLeft:
            cell = [[SGBubbleTableViewTypingLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            break;
            
        case SGBubbleTypingDirectionRight:
            cell = [[SGBubbleTableViewTypingRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            break;
            
        default:
            break;
    }

    return cell;
}

+ (CGFloat)height
{
    return 40.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.typingImageView = [[UIImageView alloc] init];
        [self addSubview:self.typingImageView];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//- (void)setType:(SGBubbleTypingDirection)value
//{
//    if (!self.typingImageView)
//    {
//        self.typingImageView = [[UIImageView alloc] init];
//        [self addSubview:self.typingImageView];
//    }
//    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    UIImage *bubbleImage = nil;
//    CGFloat x = 0;
//    
//    if (value == SGBubbleTypingDirectionRight)
//    {
//        bubbleImage = [UIImage imageNamed:@"typingMine.png"]; 
//        x = self.frame.size.width - bubbleImage.size.width;
//    }
//    else
//    {
//        bubbleImage = [UIImage imageNamed:@"typingSomeone.png"]; 
//        x = 0;
//    }
//
//    self.typingImageView.image = bubbleImage;
//    self.typingImageView.frame = CGRectMake(x,
//                                            kSGBubbleTableViewTypingCellOffsetY,
//                                            kSGBubbleTableViewTypingCellWidth,
//                                            kSGBubbleTableViewTypingCellHeight);
//}

@end

@implementation SGBubbleTableViewTypingLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        UIImage *bubbleImage = [UIImage imageNamed:@"typingSomeone.png"];
        CGFloat x = 0;

        self.typingImageView.image = bubbleImage;
        self.typingImageView.frame = CGRectMake(x,
                                                kSGBubbleTableViewTypingCellOffsetY,
                                                kSGBubbleTableViewTypingCellWidth,
                                                kSGBubbleTableViewTypingCellHeight);
    }

    return self;
}

@end


@implementation SGBubbleTableViewTypingRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UIImage *bubbleImage = [UIImage imageNamed:@"typingMine.png"];
        CGFloat x = self.frame.size.width - bubbleImage.size.width;
        
        self.typingImageView.image = bubbleImage;
        self.typingImageView.frame = CGRectMake(x,
                                                kSGBubbleTableViewTypingCellOffsetY,
                                                kSGBubbleTableViewTypingCellWidth,
                                                kSGBubbleTableViewTypingCellHeight);
    }
    
    return self;
}

@end
