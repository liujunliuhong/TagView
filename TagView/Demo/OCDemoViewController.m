//
//  OCDemoViewController.m
//  TagView
//
//  Created by galaxy on 2020/10/24.
//

#import "OCDemoViewController.h"
#import "TagView-Swift.h"
#import <Masonry/Masonry.h>

@interface OCDemoViewController ()
@property (nonatomic, strong) GLTagView *tagView;
@end

@implementation OCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"OC Demo";
    
    CGFloat topHeight = [UIApplication sharedApplication].statusBarFrame.size.height + 80;
    CGFloat left = 25.0;
    
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(left);
        make.right.equalTo(self.view).mas_offset(-left);
        make.top.equalTo(self.view).mas_offset(topHeight);
    }];
    
    NSMutableArray<GLTagItem *> *items = [NSMutableArray array];
    
    CGFloat itemHeight = 35.0;
    NSArray<NSNumber *> *widths = @[@(30), @(40), @(50), @(60)];
    for (int i = 0; i < 20; i ++) {
        int index = arc4random() % widths.count;
        CGFloat itemWidth = [widths[index] floatValue];
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        label.text = [NSString stringWithFormat:@"%d", i];
        
        GLTagItem *item = [[GLTagItem alloc] initWithView:label width:itemWidth height:itemHeight];
        [items addObject:item];
    }
    
    [self.tagView addWithItems:items];
}

- (GLTagView *)tagView {
    if (!_tagView) {
        _tagView = [[GLTagView alloc] init];
        _tagView.inset = UIEdgeInsetsMake(10, 10, 10, 10);
        _tagView.lineSpacing = 15.0;
        _tagView.interitemSpacing = 30.0;
        _tagView.backgroundColor = [UIColor purpleColor];
    }
    return _tagView;
}

@end
