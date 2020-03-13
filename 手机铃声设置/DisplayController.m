//
//  DisplayController.m
//  手机铃声设置
//
//  Created by jiangtaisheng on 2019/1/29.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "DisplayController.h"
#import "AFNetworking.h"
#import <QuickLook/QuickLook.h>

@interface DisplayController ()<UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource>
@property (nonatomic, strong) UIDocumentInteractionController *DIController;
@property (nonatomic, strong) QLPreviewController *QLController;
@end

@implementation DisplayController
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)displayAction:(id)sender {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf";
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //判断是否存在
    if ([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        [self presentViewController:self.QLController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.QLController refreshCurrentPreviewItem];
    } else {
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [self presentViewController:self.QLController animated:YES completion:nil];
            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
            [self.QLController refreshCurrentPreviewItem];
        }];
        [downloadTask resume];
    }
}


/**
 判断文件是否已经在沙盒中存在
 
 @param fileName 文件名
 @return 1:存在 0:不存在
 */
- (BOOL)isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
