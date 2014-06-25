//
//  ViewController.m
//  TitansProject
//
//  Created by desmond on 6/20/14.
//  Copyright (c) 2014 Phoenix. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIDevice+Common.h>
#import "WeiboApi.h"
#import "WXApi.h"

static NSString *WechatTimelineTitle = @"微信朋友圈分享";
static NSString *WechatSessionTitle  = @"微信好友分享";

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //new add
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnShare:(id)sender {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}


- (IBAction)btnWeixinShare:(id)sender {
    {
        if (![WXApi isWXAppInstalled]) {
            UIAlertView *view =
            [[UIAlertView alloc] initWithTitle:@"提示"
                                       message:@"不能在模拟器上或没有安装微信的设备上正确运行！"
                                      delegate:nil
                             cancelButtonTitle:@"知道了"
                             otherButtonTitles: nil];
            [view show];
            return;
        }
        
        UIButton *button = (UIButton*)sender;
        ShareType shareType =
        ([button.titleLabel.text compare:WechatTimelineTitle] == NSOrderedSame)?
        ShareTypeWeixiTimeline : ShareTypeWeixiSession;
        
        id<ISSContent> publishContent = nil;
        
        NSString *contentString = @"使用 ShareSDK 分享到微信很容易！";
        NSString *titleString   = @"微信分享集成测试";
        NSString *urlString     = @"http://www.ShareSDK.cn";
        NSString *description   = @"Sample";
        
        //TODO: 4. 正确选择分享内容的 mediaType 以及填写参数，就能分享到微信
        publishContent = [ShareSDK content:contentString
                            defaultContent:@""
                                     image:nil
                                     title:titleString
                                       url:urlString
                               description:description
                                 mediaType:SSPublishContentMediaTypeText];
        
        [ShareSDK shareContent:publishContent
                          type:shareType
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:NO
                        result:^(ShareType type,
                                 SSResponseState state,
                                 id<ISSPlatformShareInfo> statusInfo,
                                 id<ICMErrorInfo> error,
                                 BOOL end)
         {
             NSString *name = nil;
             switch (type)
             {
                 case ShareTypeWeixiSession:
                     name = @"微信好友";
                     break;
                 case ShareTypeWeixiTimeline:
                     name = @"微信朋友圈";
                     break;
                 default:
                     name = @"某个平台";
                     break;
             }
             
             NSString *notice = nil;
             if (state == SSPublishContentStateSuccess)
             {
                 notice = [NSString stringWithFormat:@"分享到%@成功！", name];
                 NSLog(@"%@",notice);
                 
                 UIAlertView *view =
                 [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:notice
                                           delegate:nil
                                  cancelButtonTitle:@"知道了"
                                  otherButtonTitles: nil];
                 [view show];
             }
             else if (state == SSPublishContentStateFail)
             {
                 notice = [NSString stringWithFormat:@"分享到%@失败,错误码:%d,错误描述:%@", name, [error errorCode], [error errorDescription]];
                 NSLog(@"%@",notice);
                 
                 UIAlertView *view =
                 [[UIAlertView alloc] initWithTitle:@"提示"
                                            message:notice
                                           delegate:nil
                                  cancelButtonTitle:@"知道了"
                                  otherButtonTitles: nil];
                 [view show];
             }
         }];
    }
    
}

- (IBAction)btnSimple:(id)sender {
    
//    id<ISSShareOptions> simpleShareOptions =
//    [ShareSDK simpleShareOptionsWithTitle:@"内容分享"
//                        shareViewDelegate:nil ];
//    
//    
//    [ShareSDK showShareViewWithType:myShareType
//                          container:myContainer
//                            content:CONTENT
//                      statusBarTips:NO
//                        authOptions:nil
//                       shareOptions:simpleShareOptions
//                             result:nil];
}

/*
- (IBAction)btnOneKeyShare:(id)sender {
    
    NSArray *oneKeyShareList = [ShareSDK getShareListWithType:
                                ShareTypeSinaWeibo,
                                ShareTypeTencentWeibo,
                                nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil      //分享视图标题
                                                              oneKeyShareList:oneKeyShareList           //一键分享菜单
                                                               qqButtonHidden:NO                               //QQ分享按钮是否隐藏
                                                        wxSessionButtonHidden:NO                   //微信好友分享按钮是否隐藏
                                                       wxTimelineButtonHidden:NO                 //微信朋友圈分享按钮是否隐藏
                                                         showKeyboardOnAppear:NO                  //是否显示键盘
                                                            shareViewDelegate:nil                            //分享视图委托
                                                          friendsViewDelegate:nil                          //好友视图委托
                                                        picViewerViewDelegate:nil];                    //图片浏览视图委托
    
    NSString *CONTENT = @"使用 ShareSDK 分享到微信很容易！";

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:CONTENT
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:nil]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions                    //传入分享选项对象
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    
}
*/

@end
