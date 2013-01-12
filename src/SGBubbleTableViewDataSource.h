//
//  SGBubbleTableViewDataSource.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <Foundation/Foundation.h>

@class SGBubbleData;
@class SGBubbleTableView;
@protocol SGBubbleTableViewDataSource <NSObject>

@optional

@required

- (NSInteger)numberOfRowsForBubbleTableView:(SGBubbleTableView *)tableView;
- (SGBubbleData *)bubbleTableView:(SGBubbleTableView *)tableView dataForRow:(NSInteger)row;

@end
