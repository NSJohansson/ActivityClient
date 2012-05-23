//
//  ChooseCategoryTableViewController.m
//  iOSAbcClient
//
//  Created by pitlab on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseCategoryTableViewController.h"
#import "ClientData.h"

@implementation ChooseCategoryTableViewController
@synthesize delegate = _delegate;
@synthesize categories = _categories;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"optionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *iconPath = [NSString stringWithFormat:@"%@.png", [self.categories objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:iconPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate choseCategory:[self.categories objectAtIndex:indexPath.row]];
}

@end
