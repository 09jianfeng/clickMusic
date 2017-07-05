//
//  DetailViewController.m
//  LiuHeCaiBaoDian
//
//  Created by JFChen on 17/1/12.
//  Copyright © 2017年 陈建峰. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
//新葡京
@property(strong, nonatomic) UIWebView *webView;
@property(strong, nonatomic) UIActivityIndicatorView *indicator;
@property(strong, nonatomic) UILabel *tips;
@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //新葡京
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://2ewkfnkengkrjttnerkdowod319d30mdqwklmkl.com/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [_webView loadRequest:request];
}


#pragma mark - 新葡京

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_indicator) {
        return;
    }
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"game_init.jpg"];
    [self.view addSubview:_imageView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.backgroundColor = [UIColor grayColor];
    _indicator.frame = CGRectMake(0, 0, 50, 50);
    _indicator.layer.cornerRadius = 10.0;
        [self.view addSubview:_indicator];
    [_indicator startAnimating];
    _indicator.center = self.view.center;
    
    _tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _tips.text = @"loading...";
    _tips.textColor = [UIColor blackColor];
    _tips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tips];
    _tips.center = CGPointMake(_indicator.center.x, _indicator.center.y + 100);
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finish");
    [_indicator stopAnimating];
    _tips.hidden = YES;
    _imageView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_indicator stopAnimating];
    _tips.text = @"请检查网络或手机时间，重启应用";
}

@end
