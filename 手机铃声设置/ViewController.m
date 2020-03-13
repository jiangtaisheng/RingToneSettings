//
//  ViewController.m
//  手机铃声设置
//
//  Created by jiangtaisheng on 2019/1/25.
//  Copyright © 2019 jiangtaisheng. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import "DisplayController.h"

@interface ViewController ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong)UIDocumentInteractionController * document;

@end

@implementation ViewController
- (IBAction)shareTest1:(id)sender {
    [self test1];
}
- (IBAction)shareTest2:(id)sender {
    [self test2];
}

- (IBAction)nextView:(id)sender {
    
    DisplayController * disVC=[[DisplayController alloc]init];
    [self presentViewController:disVC animated:YES completion:nil];
}


-(BOOL)writeFileContentNsData:(NSString *)fileDir withName:(NSString *)fileName withData:(NSData*)contentData
{
    NSMutableDictionary * atributes=[NSMutableDictionary dictionaryWithCapacity:0];
    [atributes setValue:[NSNumber numberWithInt:0777] forKey:@"NSFilePosixPermissions"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileDir]){
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:atributes error:nil];
    }
    NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSLog(@"---沙盒路径：：：%@-----",filePath);
    BOOL isSucc= [[NSFileManager defaultManager] createFileAtPath:filePath contents:contentData attributes:atributes];
    return isSucc;
}

#pragma mark UIActivityViewController
-(void)test1{
    NSString * dir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES) lastObject];
//    [self writeFileContentNsData:dir withName:@"启动.txt" withData:data3];
//    NSLog(@"=====%@",dir);
    
        NSString * path1=[[NSBundle mainBundle]pathForResource:@"醉仙美.band" ofType:nil];

      NSError * error=nil;
      NSString * path=[NSString stringWithFormat:@"%@/醉仙美.band",dir];
      BOOL isSuc=[[NSFileManager defaultManager] copyItemAtPath:path1 toPath:path error:&error];
    

    //NSData * data3=[NSData dataWithContentsOfFile:path];

    NSURL * url=[NSURL fileURLWithPath:path];
    NSArray *activityItems = @[url];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
    
}








- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark UIDocumentInteractionController
-(void)test2{
    
//    1.获取文件路径
    NSString * fileUrl = [[NSBundle mainBundle] pathForResource:@"醉仙美.band" ofType:nil];
//    2.获取cache路径
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [[paths1 objectAtIndex:0] stringByAppendingPathComponent:fileUrl.lastPathComponent];
//    3.将文件复制到cache中
    NSError*error =nil;
    BOOL isCopySuccess = [[NSFileManager defaultManager] copyItemAtPath:fileUrl toPath:cachesDir error:&error];
//    4.判断如果拷贝成功
    if (isCopySuccess) {
//        初始化_document
        _document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:cachesDir]];
        _document.delegate=self;

        [_document presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];

    } else {
        //        初始化_document
        _document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:cachesDir]];
        _document.delegate=self;

        
        [_document presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
//        给用户提示当前没有其他应用可打开该文档
    }
//    5.执行以上第2条之后的代码。
    

    
}

//    几个代理的使用
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}
//点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)controller {
    NSLog(@"aa");
}
// 文件分享面板弹出的时候调用
- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController*)controller{
    NSLog(@"WillPresentOpenInMenu");
}
// 当选择一个文件分享App的时候调用
- (void)documentInteractionController:(UIDocumentInteractionController*)controller willBeginSendingToApplication:(nullable NSString*)application{
    NSLog(@"begin send : %@", application);
}
// 弹框消失的时候走的方法
-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController*)controller{
    NSLog(@"dissMiss");
}


/**
 SLRemoteComposeViewController: (this may be harmless) viewServiceDidTerminateWithError: Error Domain=_UIViewServiceErrorDomain Code=1 "(null)" UserInfo={Terminated=disconnect method}
 2019-01-25 17:54:00.037934+0800 手机铃声设置[30810:9214972] Status bar could not find cached time string image. Rendering in-process.

 
 
 **/

@end


    
