//
//  DropboxTableViewController.m
//  iOSAbcClient
//
//  Created by pitlab on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <DropboxSDK/DropboxSDK.h>
#import "DropboxTableViewController.h"

@interface DropboxTableViewController()
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) NSString *userId;
@end

@implementation DropboxTableViewController
@synthesize restClient = _restClient;
@synthesize files = _files;
@synthesize delegate = _delegate;
@synthesize path = _path;
@synthesize userId = _userId;

-(DBRestClient*)restClient {
    if (!_restClient) {
        _restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    return _restClient;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.restClient loadAccountInfo];
    
    self.files = [NSMutableArray array];
    [[self restClient] loadMetadata:self.path];
}

-(void)restClient:(DBRestClient *)client loadedAccountInfo:(DBAccountInfo *)info {
    self.userId = info.userId;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)cancelPressed:(id)sender {
    [self.delegate canceled:self];
}

#pragma mark - Dropbox delegate methods

-(void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if(metadata.isDirectory) {
        for (DBMetadata *meta in metadata.contents) {
            [self.files addObject:meta];
        }
        [self.tableView reloadData];
    }
}

-(void)restClient:(DBRestClient *)client movedPath:(NSString *)from_path to:(DBMetadata *)result {
    NSString *path = [[NSString stringWithFormat:@"http://dl.dropbox.com/u/%@/%@", self.userId, result.filename] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [self.delegate choseFileWithPublicPath:path];
}

-(void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"DROPBOX ERROR!!");  
}

-(void)restClient:(DBRestClient *)restClient loadedSharableLink:(NSString *)link forFile:(NSString *)path {
    [self.delegate choseFileWithPublicPath:link];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dropboxCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    DBMetadata *metaData = [self.files objectAtIndex:indexPath.row];        
    cell.textLabel.text = metaData.filename;
    
    if(metaData.isDirectory) {
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *extension = [metaData.filename pathExtension];
        
        if([extension isEqualToString:@"pdf"] ||
           [extension isEqualToString:@"docx"] ||
           [extension isEqualToString:@"doc"] ||
           [extension isEqualToString:@"png"]) {
            NSString *iconName = [NSString stringWithFormat:@"%@.%@", extension, @"png"];
            
            cell.imageView.image = [UIImage imageNamed:iconName];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"file.png"];
        }
    }
    
    return cell;
}
	
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DBMetadata *metaData = [self.files objectAtIndex:indexPath.row];
    
    NSString *format = [self.path isEqualToString:@"/"] ? @"%@%@" : @"%@/%@";
    
    if(metaData.isDirectory) {
        DropboxTableViewController *dtvc = [[DropboxTableViewController alloc] init];
        dtvc.path = [NSString stringWithFormat:format, self.path, metaData.filename];
        dtvc.title = metaData.filename;
        dtvc.delegate = self.delegate;
        NSLog(@"Delegate: %@", self.delegate);
        [self.navigationController pushViewController:dtvc animated:YES];   
    } else {
        NSString *fromPath = [NSString stringWithFormat:format, self.path, metaData.filename];
        NSString *toPath = [@"/Public/" stringByAppendingFormat:metaData.filename];
        [self.restClient moveFrom:fromPath toPath:toPath];
    }
}

@end
