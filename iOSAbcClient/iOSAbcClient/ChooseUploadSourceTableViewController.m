//
//  ChooseUploadSourceTableViewController.m
//  iOSAbcClient
//
//  Created by pitlab on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <DropboxSDK/DropboxSDK.h>
#import "ChooseUploadSourceTableViewController.h"
#import "ChooseCategoryTableViewController.h"
#import "DropboxTableViewController.h"
#import "ClientData.h"

@interface ChooseUploadSourceTableViewController()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) DropboxTableViewController *dropbox;
@property (nonatomic, strong) ChooseCategoryTableViewController *categoryTVC;

@property (nonatomic, strong) UIPopoverController *imgPopover;
@property (nonatomic, strong) DBRestClient *dropboxClient;

@property (nonatomic, strong) NSString *chosenCategory;
@property (nonatomic, strong) NSString *dropboxPublicPath;
@property (nonatomic, strong) NSString *localImagePublicPath;
@property (nonatomic, strong) NSString *userId;
@end

@implementation ChooseUploadSourceTableViewController

@synthesize nameTextField = _nameTextField;
@synthesize dropbox = _dropbox;
@synthesize categoryTVC = _categoryTVC;

@synthesize imgPopover = _imgPopover;
@synthesize dropboxClient = _dropboxClient;
@synthesize userId = _userId;

@synthesize chosenCategory = _chosenCategory;
@synthesize dropboxPublicPath = _dropboxPublicPath;
@synthesize localImagePublicPath = _localImagePublicPath;

@synthesize modalViewDelegate = _modalViewDelegate;
@synthesize createResourceDelegate = _createResourceDelegate;

-(DBRestClient *)dropboxClient {
    if (!_dropboxClient) {
        _dropboxClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _dropboxClient.delegate = self;
    }
    return _dropboxClient;
}

- (IBAction)cancelPressed:(id)sender {
    [self.createResourceDelegate canceledCreation:sender];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    self.nameTextField.delegate = self;
    [self.dropboxClient loadAccountInfo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"dropbox"]) {
        
        self.dropbox = segue.destinationViewController;
        self.dropbox.delegate = self;
        self.dropbox.path = @"/";
    
    } else if([segue.identifier isEqualToString:@"showCategories"]) {
    
        self.categoryTVC = segue.destinationViewController;
        self.categoryTVC.categories = [ClientData resourceCategories];
        self.categoryTVC.delegate = self;
        
    }
}

-(void)presentImagePickerPopover {
    if(!self.imgPopover) {
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        mediaUI.allowsEditing = NO;
        mediaUI.delegate = self;
        
        self.imgPopover = [[UIPopoverController alloc] initWithContentViewController:mediaUI];
    }
    if(![self.imgPopover isPopoverVisible]) {
        [self.imgPopover presentPopoverFromRect:CGRectMake(70, 170, 80, 70) inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = delegate;
    
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}



#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark - DBRestClientDelegate

-(void)restClient:(DBRestClient *)client loadedAccountInfo:(DBAccountInfo *)info {
    self.userId = info.userId;
}

-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    
    NSString *path = [[NSString stringWithFormat:@"http://dl.dropbox.com/u/%@/%@", self.userId, metadata.filename] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    Resource *resource = [Resource resourceWithURL:path name:self.nameTextField.text category:self.chosenCategory];
    [self.createResourceDelegate createdResource:resource];
}

-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"Dropbox error");
}

#pragma mark - ChooseCategoryDelegate

-(void)choseCategory:(NSString *)category {
    [self.navigationController popViewControllerAnimated:YES];
    self.chosenCategory = category;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.detailTextLabel.text = category;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if([mediaType isEqualToString:@"public.image"] && originalImage) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"iPadfile.jpg"];
        NSData *data = UIImageJPEGRepresentation(originalImage, 1.0);
        [data writeToFile:path atomically:YES];
        
        [self.dropboxClient uploadFile:@"iPadfile.jpg" toPath:@"/Public/" withParentRev:nil fromPath:path];
        self.nameTextField.enabled = NO;
        
        [self.imgPopover dismissPopoverAnimated:YES];
    } else {
        
    }
}

#pragma mark - DropboxTableViewDelegate

-(void)choseFileWithPublicPath:(NSString *)path {
    [self.navigationController popViewControllerAnimated:YES];
    self.dropboxPublicPath = path;
    self.localImagePublicPath = nil;

    Resource *resource = [Resource resourceWithURL:path name:self.nameTextField.text category:self.chosenCategory];
    [self.createResourceDelegate createdResource:resource];
}

-(void)canceled:(id)sender {
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if((indexPath.section != 0 && indexPath.section != 1) &&
       ([self.nameTextField.text isEqualToString:@""] || !self.chosenCategory)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid input" 
                                                        message:@"Please provide both name and category before you choose the source" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        if(indexPath.section == 2 && indexPath.row == 0) {
            //Image from library
            [self presentImagePickerPopover];
        } else if(indexPath.section == 2 && indexPath.row == 1) {
            //Image from camera
            [self.nameTextField resignFirstResponder];
            [self startCameraControllerFromViewController:self usingDelegate:self];
        } else if(indexPath.section == 2 && indexPath.row == 2) {
            //File from Dropbox
            [self performSegueWithIdentifier:@"dropbox" sender:self];
        }
    }
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [super viewDidUnload];
}
@end
