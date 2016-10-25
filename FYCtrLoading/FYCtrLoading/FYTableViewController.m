//
//  FYTableViewController.m
//  FYCtrLoading
//
//  Created by SimonMiao on 2016/10/24.
//  Copyright © 2016年 yongrun. All rights reserved.
//

#import "FYTableViewController.h"
#import "UIViewController+FYLoading.h"

#import "MBProgressHUD.h"

@interface MBExample : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SEL selector;

@end


@implementation MBExample

+ (instancetype)exampleWithTitle:(NSString *)title selector:(SEL)selector {
    MBExample *example = [[self class] new];
    example.title = title;
    example.selector = selector;
    return example;
}

@end

static NSString *const KCellId = @"KUITableViewCellId";
static NSString *const KHeaderViewId = @"KUITableViewHeaderViewId";

@interface FYTableViewController () <NSURLSessionDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (atomic, assign) BOOL canceled;

@end

@implementation FYTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Controller+Loading";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadDataSource];
}

- (void)loadDataSource {
    
    self.dataSource =
    @[@[[MBExample exampleWithTitle:@"Indeterminate mode" selector:@selector(indeterminateExample)],
        [MBExample exampleWithTitle:@"With label" selector:@selector(labelExample)],
        [MBExample exampleWithTitle:@"With details label" selector:@selector(detailsLabelExample)]],
      @[[MBExample exampleWithTitle:@"Determinate mode" selector:@selector(determinateExample)],
        [MBExample exampleWithTitle:@"Annular determinate mode" selector:@selector(annularDeterminateExample)],
        [MBExample exampleWithTitle:@"Bar determinate mode" selector:@selector(barDeterminateExample)]],
      @[[MBExample exampleWithTitle:@"Text only" selector:@selector(textExample)],
        [MBExample exampleWithTitle:@"Custom view" selector:@selector(customViewExample)],
        [MBExample exampleWithTitle:@"With action button" selector:@selector(cancelationExample)],
        [MBExample exampleWithTitle:@"Mode switching" selector:@selector(modeSwitchingExample)]],
      @[[MBExample exampleWithTitle:@"On window" selector:@selector(indeterminateExample)],
        [MBExample exampleWithTitle:@"NSURLSession" selector:@selector(networkingExample)],
        [MBExample exampleWithTitle:@"Determinate with NSProgress" selector:@selector(determinateNSProgressExample)],
        [MBExample exampleWithTitle:@"Dim background" selector:@selector(dimBackgroundExample)],
        [MBExample exampleWithTitle:@"Colored" selector:@selector(colorExample)]]
      ];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KCellId];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:KHeaderViewId];
}

- (void)indeterminateExample {
    [self fy_postLoadingWithTitle:nil];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)labelExample {
    [self fy_postLoadingWithTitle:@"Loading..."];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)detailsLabelExample {
    [self fy_postLoadingWithTitle:@"Loading..." detail:@"Parsing data\n(1/1)"];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)determinateExample {
    [self fy_postLoadingDeterminateWithTitle:@"Loading..."];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)annularDeterminateExample {
    [self fy_postLoadingAnnularDeterminateWithTitle:@"Loading..."];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)barDeterminateExample {
    [self fy_postLoadingBarDeterminateWithTitle:@"Loading..."];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)textExample {
    [self fy_postMessage:@"Message Here!"];
}

- (void)customViewExample {
    [self fy_postMessage:@"Done" customViewImageName:@"Checkmark"];
}

- (void)cancelationExample {
    [self fy_postLoadingDeterminateWithTitle:NSLocalizedString(@"Loading...", @"HUD loading title") cancelButtonAction:@selector(cancelWork)];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)modeSwitchingExample {
    [self fy_postLoadingWithTitle:@"Preparing..."];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithMixedProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)networkingExample {
    [self fy_postLoadingWithTitle:NSLocalizedString(@"Preparing...", @"HUD preparing title")];
    [self doSomeNetworkWorkWithProgress];
}
- (void)determinateNSProgressExample {
    // Set up NSProgress
    NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
    [self fy_postLoadingDeterminateWithTitle:NSLocalizedString(@"Loading...", @"HUD loading title")
                              progressObject:progressObject
                          cancelButtonAction:@selector(cancel)];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgressObject:progressObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

- (void)dimBackgroundExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    //    hud.bezelView.color = [UIColor orangeColor];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)colorExample {
    UIColor *contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];
    [self fy_postLoadingWithTitle:@"Loading..." contentColor:contentColor];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_hideLoading];
        });
    });
}

#pragma mark - Tasks

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(1.);
}

- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
    // This just increases the progress indicator in a loop.
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) break;
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(50000);
    }
}

- (void)cancelWork {
    self.canceled = YES;
}

- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.05f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [self fy_setDeterminateProgress:progress];
        });
        usleep(50000);
    }
}

- (void)doSomeWorkWithMixedProgress {
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fy_postLoadingDeterminateWithTitle:NSLocalizedString(@"Loading...", @"HUD loading title")];
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.05f;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fy_setDeterminateProgress:progress];
        });
        usleep(50000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fy_postLoadingIndeterminateWithTitle:NSLocalizedString(@"Cleaning up...", @"HUD cleanining up title")];
    });
    sleep(2);
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self fy_postMessage:@"Completed" customViewImageName:NSLocalizedString(@"Completed", @"HUD completed title") isAutoHide:NO];
    });
    sleep(2);
}

- (void)doSomeNetworkWorkWithProgress {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
    [task resume];
}

#pragma mark - UITableViewDelegate DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCellId forIndexPath:indexPath];
    MBExample *example = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [cell.textLabel.textColor colorWithAlphaComponent:0.1f];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MBExample *example = self.dataSource[indexPath.section][indexPath.row];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.selector];
#pragma clang diagnostic pop
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:KHeaderViewId];
    headerView.backgroundColor = [UIColor colorWithRed:240.0 / 250 green:240.0 / 250 blue:240.0 / 250 alpha:1];
    
    return headerView;
}

#pragma mark - NSURLSessionDelegate 

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Do something with the data at location...
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fy_postMessage:NSLocalizedString(@"Completed", @"HUD completed title") customViewImageName:@"Checkmark"];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fy_postLoadingDeterminateWithTitle:nil];
        [self fy_setDeterminateProgress:progress];
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
