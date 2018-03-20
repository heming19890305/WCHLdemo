//
//  KJChangeUserInfoTableViewCell.m
//  XGB
//
//  Created by Yonger on 2017/8/25.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "KJChangeUserInfoTableViewCell.h"

@interface KJChangeUserInfoTableViewCell ()<UITextFieldDelegate>

@property (nonatomic,strong)sureInputContent sureBlcok;

@end
@implementation KJChangeUserInfoTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _midDistance = 0;
        _isWidTitle = NO;
        [self createView];
    }
    return self;
}


- (void)createView{
    
    _view = [[UIView alloc]init];
    _view.backgroundColor = LINECOLOR;
    [self.contentView addSubview:_view];
    _view.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(1);
    
    _view.hidden = YES;
    
    self.contentTex = [[UITextField alloc]init];
    self.contentTex.delegate = self;
    self.contentTex.font = FontWithSize(16);
    self.contentTex.textColor = [ZSColor hexStringToColor:@"292929"];
    [self.contentView addSubview:self.contentTex];
    self.contentTex.sd_layout
    .leftSpaceToView(self.contentView,HEIGHT_PRO(15))
    .rightSpaceToView(self.contentView,HEIGHT_PRO(10))
    .centerYEqualToView(self.contentView)
    .heightIs(HEIGHT_PRO(30));
    
    
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.image = ImageNamed(@"right_t");
    self.rightImage.hidden = YES;
    [self.contentView addSubview:self.rightImage];
    self.rightImage.sd_layout
    .rightSpaceToView(self.contentView,WIDTH_PRO(15))
    .centerYEqualToView(self.contentTex)
    .widthIs(WIDTH_PRO(17.5))
    .heightIs(WIDTH_PRO(17.5));
    
    _rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightbtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_rightbtn];
    _rightbtn.sd_layout
    .rightEqualToView(_rightImage)
    .leftEqualToView(_rightImage)
    .topEqualToView(_rightImage)
    .bottomEqualToView(_rightImage);
    
    CellLine
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(_sureBlcok){
        _sureBlcok(self.contentTex.text);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_sureBlcok){
        _sureBlcok(self.contentTex.text);
    }
    [self endEditing:YES];
    return NO;
}
// ***** 显示右边的图片 *****//
-(void)showRightImage:(BOOL)show{
    self.rightImage.hidden = !show;
    if (show == YES) {
        self.contentTex.sd_layout
        .leftSpaceToView(self.contentView,HEIGHT_PRO(15))
        .rightSpaceToView(self.rightImage,HEIGHT_PRO(11))
        .centerYEqualToView(self.contentView)
        .heightIs(HEIGHT_PRO(30));
        [self.contentTex updateLayout];
    }else{
        self.contentTex.sd_layout
        .leftSpaceToView(self.contentView,HEIGHT_PRO(15))
        .rightSpaceToView(self.contentView,HEIGHT_PRO(15))
        .centerYEqualToView(self.contentView)
        .heightIs(HEIGHT_PRO(30));
        [self.contentTex updateLayout];
    }
    
}

-(void)didEndInput:(sureInputContent)input{
    _sureBlcok = input;
}

-(void)setLeftTitleStr:(NSString *)leftTitleStr{
    _leftTitleStr = leftTitleStr;
    if(leftTitleStr.length == 0){
        self.contentTex.leftView = nil;
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName:FontWithSize(16)};
    CGFloat length = [leftTitleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    
    if (_isWidTitle) {
        _leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH_PRO(90), HEIGHT_PRO(30))];
    }else{
        _leftLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, length+_midDistance, HEIGHT_PRO(30))];
    }
    
    [_leftLable textFont:16 textColor:[ZSColor hexStringToColor:@"292929"] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
    _leftLable.text = leftTitleStr;
    self.contentTex.leftView = _leftLable;
    self.contentTex.leftViewMode = UITextFieldViewModeAlways;
    [self.contentTex updateLayout];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.contentTex && self.maxLenght>0){
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > self.maxLenght) {
            return NO;
        }
    }
    return YES;
}
@end
