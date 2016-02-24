//
//  JBWebViewController.m
//  JBWebViewController
//
//  Created by Jonas Boserup on 28/10/14.
//  Copyright (c) 2014 Jonas Boserup. All rights reserved.
//

#import "JBWebViewController.h"

@interface JBWebViewController ()

// Private properties
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) BOOL hasExtraButtons;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIPopoverController *popoverShareController;

@end

@implementation JBWebViewController

#pragma mark - "Standards"

- (id)initWithUrl:(NSURL *)url {
    // Set url and init views
    _url = url;
    [self setup];
    
    // Return self
    return self;
}

- (void)viewDidLoad {
    // Standard super class stuff
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Standard super class stuff
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [self hexToColor:0xEFEFEF alpha:1];
    
    // Standard super class stuff
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // Add NJKWebViewProgressView to UINavigationBar
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 2, self.navigationController.navigationBar.frame.size.width, 2)];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    // Standard super class stuff
    [super viewWillDisappear:animated];
    // Remove views
    [_progressView removeFromSuperview];
    [_titleView removeFromSuperview];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Will adjust views in UINavigationBar upon changed interface orientation
    [self adjustNavigationbar];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Update progressBar location
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    [_progressView setFrame:barFrame];
}

#pragma mark - "Setup"

- (void)setup {
    // Default value
    _hasExtraButtons = NO;
    
    // Allows navigationbar to overlap webview
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    // Create title & subtitle labels
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextColor:[self hexToColor:0x4c4c4c alpha:1]];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setText:_loadingString];
    [_titleLabel sizeToFit];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 0, 0)];
    [_subtitleLabel setBackgroundColor:[UIColor clearColor]];
    [_subtitleLabel setTextColor:[self hexToColor:0x4c4c4c alpha:1]];
    [_subtitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [_subtitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_subtitleLabel setText:[self getDomainFromString:[NSString stringWithFormat:@"%@", _url]]];
    [_subtitleLabel sizeToFit];
    
    // Correct frame sizes after sizeToFit
    [self adjustNavigationbar];
    
    // Add new titleview with labels
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, self.view.frame.size.width, 30)];
    [_titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [_titleView addSubview:_titleLabel];
    [_titleView addSubview:_subtitleLabel];
    
    self.navigationItem.titleView = _titleView;
    
    // Inset right buttons
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(0, 0, 32, 44);
    [closeButton setImage:[UIImage imageNamed:@"navbu_close"] forState:UIControlStateNormal];
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    negativeSpacer1.width = -10;
    [self.navigationItem setRightBarButtonItems:@[negativeSpacer1,closeBarButton]];
    
    // Add a webview
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    [self.view addSubview:_webView];
    
    // Configureing NJKWebViewProgress
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    // Navigating to URL
    [self navigateToURL:_url];
}

#pragma mark - "Showing controller"

-(void)setHideAddressBar:(BOOL)hideAdressBar {
    _hideAddressBar = hideAdressBar;
    
    self.subtitleLabel.hidden = hideAdressBar;
    [self adjustNavigationbar];
}

- (void)show {
    // Showing controller with no completion void
    [self showControllerWithCompletion:nil];
}

- (void)showFromController:(UIViewController*)controller
{
    [self showFromController:controller WithCompletion:nil];
    
}

- (void)showControllerWithCompletion:(completion)completion {
    // Creates navigation controller, and presents it
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    
    // Using modalViewController completion void
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:navigationController animated:YES completion:^{
        // Send completion callback
        if (completion) {
            completion(self);
        }
    }];
}
- (void)showFromController:(UIViewController*)controller WithCompletion:(completion)completion
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    [controller presentViewController:navigationController animated:YES completion:^{
        if (completion) {
            completion(self);
        }
    }];
}

#pragma mark - "Navigation"

- (void)navigateToURL:(NSURL *)url {
    // Tell UIWebView to load url
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)reload {
    // Tell UIWebView to reload
    [_webView reload];
}

- (void)navigateBack {
    // Tell UIWebView to go back
    [_webView goBack];
}

- (void)navigateForward {
    // Tell UIWebView to go forward
    [_webView goForward];
}

- (void)loadRequest:(NSURLRequest *)request {
    // Tell UIWebView to load request
    [_webView loadRequest:request];
}

#pragma mark - "Right buttons"

- (void)share {
    
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        // Code
    }];
}

#pragma mark - "Navigationbar"

- (void)adjustNavigationbar {
    // Width of buttons in UINavigationBar
    float buttonsWidth;
    
    if(_hasExtraButtons) {
        buttonsWidth = self.view.frame.size.width - (160 - 12 - 16)/2;
    } else {
        buttonsWidth = self.view.frame.size.width - 160 - 12 - 16;
    }
    
    // Setting frames on title & subtitle labels
    if (_hideAddressBar) {
        [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x, _titleView.frame.size.height/2-_titleLabel.frame.size.height/2, MIN(_titleLabel.frame.size.width, self.view.frame.size.width - buttonsWidth), _titleLabel.frame.size.height)];
    } else {
        [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _titleView.frame.size.width, _titleLabel.frame.size.height)];
    }
    [_subtitleLabel setFrame:CGRectMake(_subtitleLabel.frame.origin.x, _subtitleLabel.frame.origin.y,_titleView.frame.size.width, _subtitleLabel.frame.size.height)];
    
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    if ([_webView canGoBack] || [_webView canGoForward]) {
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
}

- (void)addNavigationButtonsButtons {
    // Creating buttons
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 32, 44);
    [backButton setImage:[UIImage imageNamed:@"navbu_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton addTarget:self action:@selector(navigateForward) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(0, 0, 32, 44);
    [nextButton setImage:[UIImage imageNamed:@"navbu_next"] forState:UIControlStateNormal];
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc]initWithCustomView:nextButton];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    negativeSpacer1.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer1,backBarButton,nextBarButton]];
    
    
    // Remember that we have extra buttons now
    _hasExtraButtons = YES;
    
    // And finally adjust NavigationBar
    [self adjustNavigationbar];
}

- (void)updateNavigationButtons {
    // If no left buttons are present and webView can go back, then add buttons
    if(!self.navigationItem.leftBarButtonItems.count && [_webView canGoBack]) {
        [self addNavigationButtonsButtons];
    }
    
    // If we can go back, enable back button
    if([_webView canGoBack]) {
        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[1]).enabled = YES;
    } else {
        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[1]).enabled = NO;
    }
    
    // If we can go forward, enable forward button
    if([_webView canGoForward]) {
        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[2]).enabled = YES;
    } else {
        ((UIBarButtonItem *)self.navigationItem.leftBarButtonItems[2]).enabled = NO;
    }
}

#pragma mark - "Titles & subtitles"

- (void)setWebTitle:(NSString *)title {
    // Set title & update frame
    [_titleLabel setText:title];
    [_titleLabel sizeToFit];
    CGRect frame = _titleLabel.frame;
    frame.size.width = _titleView.frame.size.width;
    _titleLabel.frame = frame;
    [self adjustNavigationbar];
}

- (void)setWebSubtitle:(NSString *)subtitle {
    // Set subtitle & update frame
    [_subtitleLabel setText:subtitle];
    [_subtitleLabel sizeToFit];
    CGRect frame = _subtitleLabel.frame;
    frame.size.width = _titleView.frame.size.width;
    _subtitleLabel.frame = frame;
    [self adjustNavigationbar];
}

// Get title
- (NSString *)getWebTitle {
    return _titleLabel.text;
}

// Get subtitle
- (NSString *)getWebSubtitle {
    return _subtitleLabel.text;
}

#pragma mark - "Helpers"

- (NSString *)getDomainFromString:(NSString*)string
{
    // Split url into components
    NSArray *components = [string componentsSeparatedByString:@"/"];
    for (NSString *match in components) {
        // If component has range of ".", return match
        if ([match rangeOfString:@"."].location != NSNotFound){
            return match;
        }
    }
    return nil;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Update title when page is loaded
    NSString *title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    NSString *subtitle = [webView stringByEvaluatingJavaScriptFromString:@"document.domain"];
    
    [self setWebTitle:title];
    [self setWebSubtitle:subtitle];
    
    [self updateNavigationButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Log error
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    // Update NJKWebViewProgressView
    [_progressView setProgress:progress animated:YES];
    
    // Update title
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    
    // If no title is found, set it to "Loading.."
    if(title.length == 0) {
        [self setWebTitle:_loadingString];
    } else {
        [self setWebTitle:title];
    }
}

- (UIColor *)hexToColor:(int)hexValue alpha:(CGFloat)alpha
{
    NSNumber* red = [NSNumber numberWithInt:(hexValue >> 16)];
    NSNumber* green = [NSNumber numberWithInt:((hexValue >> 8) & 0xFF)];
    NSNumber* blue = [NSNumber numberWithInt:(hexValue & 0xFF)];
    
    CGFloat fAlpha = (alpha)? alpha : 1.0f;
    UIColor* color = [UIColor colorWithRed:[red floatValue]/255.0f green:[green floatValue]/255.0f blue:[blue floatValue]/255.0f alpha:fAlpha];
    
    return color;
}

@end
