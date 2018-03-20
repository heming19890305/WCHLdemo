//
//  KJUserInfoOneTableViewCell.m
//  LookPicture
//
//  Created by Yonger on 2017/8/30.
//  Copyright © 2017年 胡青月. All rights reserved.
//

#import "KJUserInfoOneTableViewCell.h"

@implementation KJUserInfoOneTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createView];
    }
    return self;
}

-(void)createView{
    
    self.leftImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.leftImage];
    self.leftImage.sd_layout
    .leftSpaceToView(self.contentView, WIDTH_PRO(10))
    .heightRatioToView(self.contentView, 0.5)
    .widthEqualToHeight()
    .centerYEqualToView(self.contentView);
    
    self.callB = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.callB];
    self.callB.sd_layout
    .rightSpaceToView(self.contentView, WIDTH_PRO(15))
    .widthIs(WIDTH_PRO(17.5))
    .heightIs(HEIGHT_PRO(17.5))
    .centerYEqualToView(self.contentView);
    
    self.inputTex = [[UITextField alloc]init];
    self.inputTex.delegate = self;
    self.inputTex.font = [UIFont fontWithPx:30];//FontWithSize(WIDTH_PRO(15));
    self.inputTex.textColor = [ZSColor hexStringToColor:@"646363"];
    [self.contentView addSubview:self.inputTex ];
    self.inputTex.sd_layout
    .leftSpaceToView(self.leftImage, WIDTH_PRO(9.5))
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.callB, WIDTH_PRO(5))
    .heightIs(HEIGHT_PRO(30));
    
    self.clickBtn = [[UIButton alloc]init];
    self.clickBtn.hidden = YES;
    self.clickBtn.backgroundColor = [UIColor clearColor];
    [self.clickBtn addTarget:self action:@selector(inputClickAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.contentView addSubview:self.clickBtn];
    self.clickBtn.sd_layout
    .leftEqualToView(self.inputTex)
    .rightEqualToView(self.inputTex)
    .topEqualToView(self.inputTex)
    .bottomEqualToView(self.inputTex);
    
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = BACKCOLOR;
    [self.contentView addSubview:self.lineView];
    self.lineView.sd_layout
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(1);
}

-(void)showLeftImage:(BOOL)show{
    self.leftImage.hidden = !show;
    if(show){
        self.lineView.sd_layout
        .leftEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .heightIs(1);
    }else{
        self.lineView.sd_layout
        .leftEqualToView(self.inputTex)
        .bottomEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .heightIs(1);
    }
    [self.lineView updateLayout];
}

-(void)setImage:(NSString *)image{
    _image = image;
    self.leftImage.image = ImageNamed(image);
}

-(void)setTitle:(NSString *)title{
    _title = title;
    if(title.length>0){
        NSDictionary *attributes = @{NSFontAttributeName:FontWithSize(16)};
        CGFloat length = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH + WIDTH_PRO(100), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        UILabel * lable = [[UILabel alloc]init];
        if (self.isesmitWid == YES) {
            lable.frame = CGRectMake(0, 0, length + WIDTH_PRO(20), 30);
        }else{
            lable.frame = CGRectMake(0, 0,WIDTH_PRO(80), 30);
        }
        [lable textFont:15 textColor:[ZSColor hexStringToColor:@"292929"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
        lable.text = title;
        self.inputTex.leftView = lable;
        self.inputTex.leftViewMode = UITextFieldViewModeAlways;
    }else{
        self.inputTex.leftView = nil;
        self.inputTex.leftViewMode = UITextFieldViewModeNever;
    }
}

-(void)setPlace:(NSString *)place{
    _place = place;
    self.inputTex.placeholder = place;
}

-(void)setInputTexCanInput:(BOOL)inputTexCanInput{
    _inputTexCanInput  = inputTexCanInput;
    if(inputTexCanInput){
        self.clickBtn.hidden = YES;
    }else{
        self.clickBtn.hidden = NO;
    }
}

-(void)inputClickAction{
    if(!self.inputTexCanInput){
        if(_clickAction){
            _clickAction();
        }
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.inputTex && self.maxLenght != -1){
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > self.maxLenght) {
            return NO;
        }
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(_sureInput && self.inputTexCanInput){
        _sureInput(textField.text);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_sureInput && self.inputTexCanInput){
        _sureInput(textField.text);
    }
    [self endEditing:YES];
    return NO;
}
@end
