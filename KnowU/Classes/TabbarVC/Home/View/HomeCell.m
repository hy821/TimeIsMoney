//
//  HomeCell.m
//  KnowU
//
//  Created by young He on 2018/4/18.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "HomeCell.h"
#import "UILabel+Category.h"

@interface HomeCell ()

@property (nonatomic,weak) UILabel *titleLab;

@end

@implementation HomeCell

- (void)setModel:(HomeCellModel *)model {
    _model = model;
    self.titleLab.text = model.name;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

- (void)createUI {
    self.contentView.backgroundColor = ThemeColor;
    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = White_Color;
    bg.layer.cornerRadius = 8.f;
    bg.layer.masksToBounds = YES;
    [self.contentView addSubview:bg];
    
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    UILabel *lab = [UILabel labelWithTitle:@"" font:20 textColor:Black_Color textAlignment:0];
    lab.font = Font_Bold(20);
    [bg addSubview:lab];
    self.titleLab = lab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bg);
        make.left.equalTo(bg).offset(20.f);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
