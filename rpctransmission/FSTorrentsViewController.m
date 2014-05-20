//
//  FSTorrentsViewController.m
//  rpctransmission
//
//  Created by Florent Segouin on 12/11/13.
//  Copyright (c) 2013 Florent Segouin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTorrentsViewController.h"
#import "Base64.h"
#import "AFHTTPRequestOperationManager.h"
#import "FSNavigationBarWithSegmentedControl.h"
//#import "XMLRPCRequest.h"
//#import "XMLRPCConnectionManager.h"
//#import "XMLRPCResponse.h"
//#import "NSStringAdditions.h"

#define server @"SERVER IP"
#define authorizationValue @"Basic + Base64 encoded credentials"

@interface FSTorrentsViewController () {
    NSString *sessionId;
    BOOL askForSessionId;
    NSMutableArray *activeTorrents;
}

@end

@implementation FSTorrentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSession];
    
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 108);
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All", @"Active"]];
    [_segmentedControl setTintColor:[UIColor redColor]];
    [_segmentedControl setSelectedSegmentIndex:0];
    [self.navigationController.navigationBar addSubview:_segmentedControl];
    
    [_segmentedControl addTarget:self
                         action:@selector(segmentedControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
//    _torrentStatusWanted = @"All";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [(FSNavigationBarWithSegmentedControl *)self.navigationController.navigationBar updateNavBar:fromInterfaceOrientation];
//    [(FSNavigationBarWithSegmentedControl *)self.navigationController.navigationBar setNeedsDisplay];
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.navigationController.navigationBar.frame.size.height);
    // ... SNIP ...
}

#pragma mark - Segmented Control

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    
//    _torrentStatusWanted = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    [self getTorrentsList];
    [self.tableView reloadData];
    
}

#pragma mark - RPC Methods - TEST ONLY FOR NOW
    
- (void)initSession {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:authorizationValue forHTTPHeaderField:@"Authorization"];
    [[manager requestSerializer] setValue:sessionId forHTTPHeaderField:@"X-Transmission-Session-Id"];
    [manager POST:server parameters:@{@"method": @"session-get"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self getTorrentsList];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getTorrentsList) userInfo:nil repeats:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([[[[operation response] allHeaderFields] objectForKey:@"X-Transmission-Session-Id"] length] != 0) {
            sessionId = [[[operation response] allHeaderFields] objectForKey:@"X-Transmission-Session-Id"];
        }
        NSLog(@"Error! New token received : %@", sessionId);
        [self initSession];
    }];
    
}
- (void)getTorrentsList {
    
//    { "method" : "torrent-get", "arguments" : { "fields" : ["id", "name", "status", "sizeWhenDone", "leftUntilDone", "rateDownload", "rateUpload", "totalSize", "status", "seeders", "leechers", "eta", "addedDate", "activityDate"] } }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:authorizationValue forHTTPHeaderField:@"Authorization"];
    [[manager requestSerializer] setValue:sessionId forHTTPHeaderField:@"X-Transmission-Session-Id"];
    
    NSDictionary *parameters = nil;
    
    if ([_segmentedControl selectedSegmentIndex] == 1)
        parameters = @{@"method": @"torrent-get", @"arguments": @{@"fields": @[@"id", @"name", @"status", @"name", @"rateDownload", @"rateUpload", @"seeders", @"leechers", @"activityDate", @"percentDone", @"peersSendingToUs", @"peersGettingFromUs", @"peersConnected", @"eta", @"totalSize", @"sizeWhenDone", @"leftUntilDone", @"uploadedEver", @"uploadRatio"] , @"ids": @"recently-active"}};
    else
        parameters = @{@"method": @"torrent-get", @"arguments": @{@"fields": @[@"id", @"name", @"status", @"name", @"rateDownload", @"rateUpload", @"seeders", @"leechers", @"activityDate", @"percentDone", @"peersSendingToUs", @"peersGettingFromUs", @"peersConnected", @"eta", @"totalSize", @"sizeWhenDone", @"leftUntilDone", @"uploadedEver", @"uploadRatio"]}};

    [manager POST:server parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        , @"ids": @"recently-active"
//        NSLog(@"%@", responseObject);
        _torrentsArray = [NSArray array];
       _torrentsArray = [[responseObject objectForKey:@"arguments"] objectForKey:@"torrents"];
//        NSLog(@"First torrent : %@", [[_torrentsArray firstObject] objectForKey:@"name"]);
        NSLog(@"Get torrents : OK !");
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initSession];
        NSLog(@"Error! New token received : %@", sessionId);
    }];
    
}

- (NSString *)statusStringFromStatusCode:(NSUInteger)statusCode {
    NSString *response = nil;
    switch (statusCode) {
        case 0:
            response = @"Stopped";
            break;
        case 1:
            response = @"Wait to check";
            break;
        case 2:
            response = @"Check";
            break;
        case 3:
            response = @"Queued";
            break;
        case 4:
            response = @"Downloading";
            break;
        case 5:
            response = @"Wait so seed";
            break;
        case 6:
            response = @"Seeding";
            break;
        default:
            break;
    }
    return response;
}

//- (void)filterTorrents {
//    
//    if (activeTorrents == nil)
//        activeTorrents = [NSMutableArray array];
//    else
//        [activeTorrents removeAllObjects];
//    
//    for (NSDictionary *object in _torrentsArray) {
//        int torrentStatus = [[object objectForKey:@"status"] intValue];
//        if (torrentStatus == 1)
//            [activeTorrents addObject:object];
//    }
//    
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_torrentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    Status Codes :
//    
//    TR_STATUS_STOPPED        = 0, /* Torrent is stopped */
//    TR_STATUS_CHECK_WAIT     = 1, /* Queued to check files */
//    TR_STATUS_CHECK          = 2, /* Checking files */
//    TR_STATUS_DOWNLOAD_WAIT  = 3, /* Queued to download */
//    TR_STATUS_DOWNLOAD       = 4, /* Downloading */
//    TR_STATUS_SEED_WAIT      = 5, /* Queued to seed */
//    TR_STATUS_SEED           = 6  /* Seeding */
    

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *torrent = [_torrentsArray objectAtIndex:indexPath.row];
    
    NSString *status = [self statusStringFromStatusCode:[[torrent objectForKey:@"status"] intValue]];
    NSString *etaString = [[self formatter] stringFromDate:[torrent objectForKey:@"eta"]];
    
    UILabel *torrentName = (UILabel *)[cell viewWithTag:1];
    torrentName.text = [torrent objectForKey:@"name"];
    
    UILabel *torrentDesc = (UILabel *)[cell viewWithTag:2];
    if ([status isEqualToString:@"Downloading"])
        torrentDesc.text = [NSString stringWithFormat:@"%@ from %@ of %@ peers - ▼ %d KB/s ▲ %d KB/s", status, [torrent objectForKey:@"peersSendingToUs"], [torrent objectForKey:@"peersConnected"], [[torrent objectForKey:@"rateDownload"] intValue]/1000, [[torrent objectForKey:@"rateUpload"] intValue]/1000];
    else if ([status isEqualToString:@"Seeding"])
        torrentDesc.text = [NSString stringWithFormat:@"%@ from %@ of %@ peers - ▼ %d KB/s ▲ %d KB/s", status, [torrent objectForKey:@"peersGettingFromUs"], [torrent objectForKey:@"peersConnected"], [[torrent objectForKey:@"rateDownload"] intValue]/1000, [[torrent objectForKey:@"rateUpload"] intValue]/1000];
    
    UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:3];
    float completed = [[torrent objectForKey:@"percentDone"] floatValue];
//    NSLog(@"Completed : %f", completed);
    [progressView setProgress:completed animated:YES];
//    [progressView setFrame:CGRectMake(progressView.frame.origin.x, progressView.frame.origin.y, progressView.frame.size.width, 20)];
    
    if (![status isEqualToString:@"Downloading"])
        [progressView setProgressTintColor:[UIColor colorWithRed:57/255.f green:196/255.f blue:59/255.f alpha:1]];
    else
        [progressView setProgressTintColor:[UIColor colorWithRed:66/255.f green:167/255.f blue:249/255.f alpha:1]];
//
//    [progressView setNeedsDisplay];
    
    UILabel *statsDesc = (UILabel *)[cell viewWithTag:4];
    float totalSize = [[torrent objectForKey:@"totalSize"] floatValue];
    float totalSizeDisplayed = totalSize / 1000000000;
    
    if ([status isEqualToString:@"Seeding"]) {
        float uploadedEver = [[torrent objectForKey:@"uploadedEver"] floatValue];
        float uploadedEverDisplayed = uploadedEver / 1000000000;
            statsDesc.text = [NSString stringWithFormat:@"%.2f", totalSizeDisplayed];
        if (totalSize > 1000000000)
            statsDesc.text = [statsDesc.text stringByAppendingString:@"GB, uploaded "];
        else
            statsDesc.text = [statsDesc.text stringByAppendingString:@"MB, uploaded "];
        statsDesc.text = [statsDesc.text stringByAppendingString:[NSString stringWithFormat:@"%.2f", uploadedEverDisplayed]];
        if (uploadedEver > 1000000000)
            statsDesc.text = [statsDesc.text stringByAppendingString:@"GB "];
        else
            statsDesc.text = [statsDesc.text stringByAppendingString:@"MB "];
        statsDesc.text = [statsDesc.text stringByAppendingString:[NSString stringWithFormat:@"(Ratio %.2f)", [[torrent objectForKey:@"uploadRatio"] floatValue]]];
    }
    
    else if ([status isEqualToString:@"Downloading"]) {
        float leftUntilDone = [[torrent objectForKey:@"totalSize"] floatValue] - [[torrent objectForKey:@"leftUntilDone"] floatValue];
        float leftUntilDoneDisplayed = leftUntilDone / 1000000000;
        statsDesc.text = [NSString stringWithFormat:@"%.2f", leftUntilDoneDisplayed];
        if (leftUntilDone > 1000000000)
            statsDesc.text = [statsDesc.text stringByAppendingString:@"GB "];
        else
            statsDesc.text = [statsDesc.text stringByAppendingString:@"MB "];
        [statsDesc.text stringByAppendingString:[NSString stringWithFormat:@"of %.2f", totalSizeDisplayed]];
        if (totalSize > 1000000000)
            statsDesc.text = [statsDesc.text stringByAppendingString:@"GB "];
        else
            statsDesc.text = [statsDesc.text stringByAppendingString:@"MB "];
        statsDesc.text = [statsDesc.text stringByAppendingString:[NSString stringWithFormat:@"(%.2f%%)", [[torrent objectForKey:@"percentDone"] floatValue]*100]];
        if (etaString != nil)
            statsDesc.text = [statsDesc.text stringByAppendingString:[NSString stringWithFormat:@" - %@", etaString]];
        else
            statsDesc.text = [statsDesc.text stringByAppendingString:@" - remaining time unknown"];
    }
    
    return cell;
}

- (NSDateFormatter *)formatter { // Used to avoid wasting memory by creating multiple instances of NSDateFormatter (which is very slow to initialize)
    if (! _formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [_formatter setDateFormat:@"HH:mm"];
    }
    return _formatter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
