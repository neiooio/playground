//
//  HXTriggeredWebViewController.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/24.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXTriggeredWebViewController.h"
#import "FlatButton.h"

@interface HXTriggeredWebViewController ()
@property (strong, nonatomic) NSString *webUrl;
@property (strong, nonatomic) FlatButton *closeButton;
@end

@implementation HXTriggeredWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - Init

- (id)initWithWebUrl:(NSString *)webUrl
{
    self = [super init];
    if (self) {
        _webUrl = webUrl;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];

    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_webUrl]];
    [webView loadRequest:urlRequest];
    
    
    webView.clipsToBounds = YES;
    
    [self.view addSubview:webView];
    
    self.closeButton = [FlatButton button];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setImage:[UIImage imageNamed:@"bu_close"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"bu_close"] forState:UIControlStateHighlighted];
    self.closeButton.frame = CGRectMake(0, 0, 44.f, 44.f);
    [self.view addSubview:self.closeButton];
}

#pragma mark - Listener

- (void)closeButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
