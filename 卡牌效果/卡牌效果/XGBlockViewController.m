//
//  XGBlockViewController.m
//  卡牌效果
//
//  Created by 小果 on 16/9/26.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGBlockViewController.h"

@interface XGBlockViewController ()

@property (nonatomic, assign) CGFloat imgs;
@property (nonatomic, weak) UIScrollView *scroll;

/**
 *  按钮的状态
 */
@property (nonatomic, assign) BOOL isSelected;
/**
 *  最大Y值
 */
@property (nonatomic, assign) CGFloat maxY;

@end

@implementation XGBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgs = 16;
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.bounces = NO;
    scroll.showsVerticalScrollIndicator = YES;
    scroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;

    [scroll flashScrollIndicators];
    [self.view addSubview:scroll];
    self.scroll = scroll;
    [self xg_createImage];
    
    
}

#pragma mark - 添加图片
-(void)xg_createImage{
    for (int i = 0; i < self.imgs; i++) {
        UIButton *imgBtn = [[UIButton alloc] init];
        imgBtn.layer.cornerRadius = 15;
        imgBtn.layer.borderWidth = 2;
        imgBtn.layer.borderColor = i % 2 ? [UIColor yellowColor].CGColor : [UIColor redColor].CGColor;
        imgBtn.layer.masksToBounds = YES;
        imgBtn.tag = 1000 + i;
        NSString *path = [NSString stringWithFormat:@"%zd.jpg",i];
        NSURL *url = [[NSBundle mainBundle] URLForResource:path withExtension:nil];
        [imgBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placehold.jpg"]];
        CGFloat btnW = 200;
        CGFloat btnH = 150;
        CGFloat btnX = (screenW - btnW) * 0.5;
        CGFloat btnY = TopMargin + btnH * 0.5 * i;
        imgBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [imgBtn addTarget:self action:@selector(xg_imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:imgBtn];
        if (i == self.imgs - 1){
            self.maxY = CGRectGetMaxY(imgBtn.frame);
            self.scroll.contentSize = CGSizeMake(0, self.maxY);
        }
    }
}

#pragma mark -  图片的点击事件
-(void)xg_imageBtnClick:(UIButton *)sender{
    CGFloat btnY = CGRectGetMaxY(sender.frame);
    if (btnY > screenH) {
        [UIView animateWithDuration:0.6 animations:^{
            self.scroll.contentOffset = CGPointMake(0, 0);
        }];
    }
    if (self.isSelected) {
        for (int i = 0; i < self.imgs; i++) {
            UIButton *selectBtn = self.scroll.subviews[i];
            CGRect btnF = selectBtn.frame;
            btnF.origin.y = TopMargin + (btnF.size.height * 0.5) * i;
            [UIView animateWithDuration:0.8 animations:^{
                selectBtn.frame = btnF;
            }];
        }
    }else{
        
        for (int i = 0; i < self.imgs; i++) {
            UIButton *selectBtn = self.scroll.subviews[i];
            CGRect btnF = selectBtn.frame;
            if (selectBtn.tag <= sender.tag) {
                
                btnF.origin.y = TopMargin;
                [UIView animateWithDuration:3.0 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    selectBtn.frame = btnF;
                }completion:^(BOOL finished) {
                    
                }];
            }else{
                
                btnF.origin.y = self.maxY;
                [UIView animateWithDuration:0.3 animations:^{
                    selectBtn.frame = btnF;
                }];
            }
        }
    }
    self.isSelected = !self.isSelected;
}

#pragma mark - 修改状态栏的样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews{
    //设置滚动条的颜色
    for (UIView* subview in [self.scroll subviews])
    {
        if([subview isKindOfClass:[UIImageView class]])
        {
            UIImageView *img=(UIImageView*)subview;
            img.backgroundColor = [UIColor redColor];
        }
    }
    [super viewDidLayoutSubviews];
    
}
@end
