//
//  KJChooseImagesView.m
//  KPH
//
//  Created by Yonger on 2017/7/24.
//  Copyright © 2017年 ZS. All rights reserved.
//

#import "KJChooseImagesView.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"


@interface KJChooseImagesView ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (nonatomic,strong)UIView *imagesView;

@property (nonatomic,strong) UIButton * chooseImageBtn;
@property (nonatomic,strong) UILabel * msgLable;//提示lable
@property (nonatomic,strong)chooseImageHeightIsChnage changeBclok;
@property (weak, nonatomic) IBOutlet UIView *titleLineView;

@property (nonatomic,strong) NSString * addBtnImage;
@end


@implementation KJChooseImagesView

-(void)viewheightIsChanged:(chooseImageHeightIsChnage)change addimage:(NSString *)image{
    _changeBclok = change;
    _addBtnImage = image;
    self.imagesArry = [NSMutableArray array];
    _selectedPhotos = [[NSMutableArray alloc]init];
    _selectedAssets = [[NSMutableArray alloc]init];
    
    
    self.titleLable.text = self.titleStr;
    if(self.numberOfLine == 0){
        self.numberOfLine = 3;
    }
    if(self.titleStr.length == 0){//不要标题
        self.titleLineView.hidden = YES;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/self.numberOfLine);
        self.imagesView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH/self.numberOfLine)];
    }else{
        self.titleLineView.hidden = NO;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/self.numberOfLine+51);
        self.imagesView = [[UIView alloc]initWithFrame:CGRectMake(0,51, SCREEN_WIDTH, SCREEN_WIDTH/self.numberOfLine)];
    }
    [self addSubview:self.imagesView];
    [self.imagesView addSubview:self.chooseImageBtn];
}


-(void)loadImagsWithImageUrlArry:(NSArray *)arry{
    for (NSString * url in arry) {
        NSData * imagedata = [self synchronousDownLoadFromUrl:[NSString stringWithFormat:@"%@%@",SERVER_HOST,url]];
        UIImage * image = [UIImage imageWithData:imagedata];
        if(image){
            [self.imagesArry addObject:image];
        }else{//没加载到图片显示默认
            [self.imagesArry addObject:ImageNamed(DefautImageName)];
        }
        if(self.imagesArry.count == arry.count){
            [self updateImagesView];
            self.hasChooseImage = NO;//没改变状态
        }
    }
}

//同步下载
-(NSData *)synchronousDownLoadFromUrl:(NSString *)url
{
    NSURL *netUrl = [[NSURL alloc]initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:netUrl];
    NSError *err = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err ];
    return data;
}

-(void)updateImagesView{
    self.hasChooseImage = YES;//改变了图片状态
    [self.imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat with = (SCREEN_WIDTH-WIDTH_PRO(10))/self.numberOfLine;
    
    CGFloat heighttemp = 118 * SCREEN_WIDTH/2 / 166;
    CGFloat height = self.numberOfLine>2?with : HEIGHT_PRO(heighttemp);
    for (int i =0 ; i<= self.imagesArry.count; i++) {
        if(i!= self.imagesArry.count){
            UIButton * btn  = [[UIButton alloc]initWithFrame:CGRectMake((i%self.numberOfLine)*with, (i/self.numberOfLine)*height, with, height)];
            [btn addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            
            UIImageView * addimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_PRO(10),0,with-WIDTH_PRO(10),height-WIDTH_PRO(10))];
            addimage.image = self.imagesArry[i];
            [btn addSubview:addimage];
            
            UIButton * deleteBtn = [[UIButton alloc]init];
            [deleteBtn setBackgroundImage:ImageNamed(@"photo_delete") forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteImagesAction:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.tag = i;
            [btn addSubview:deleteBtn];
            deleteBtn.sd_layout
            .rightSpaceToView(btn, 0)
            .topSpaceToView(btn, 0)
            .widthIs(WIDTH_PRO(28))
            .heightIs(WIDTH_PRO(28));
            [self.imagesView addSubview:btn];
        }else{
            int j = 0;
            if(self.imagesArry.count == self.maxImagesNumber){
                self.chooseImageBtn.hidden = YES;
                j = i;
            }else{
                j = i+1;
                self.chooseImageBtn.hidden = NO;
                self.chooseImageBtn.frame = CGRectMake((i%self.numberOfLine)*with, (i/self.numberOfLine)*with, with, with);
                [self.imagesView addSubview:self.chooseImageBtn];
            }
            CGFloat height = (j/self.numberOfLine)*with;
            if( j % self.numberOfLine >0){
                height += with;
            }
            if(self.imagesView.height != height){
                if(_changeBclok){
                    self.imagesView.height  = height;
                    if(self.titleStr.length == 0){
                        _changeBclok(height);
                    }else{
                        _changeBclok(height+51);
                    }
                }
            }
        }
    }
}

-(UIButton *)chooseImageBtn{
    if(!_chooseImageBtn){
        CGFloat with = (SCREEN_WIDTH-WIDTH_PRO(10))/self.numberOfLine;
        CGFloat heighttemp = 118 * SCREEN_WIDTH/2 / 166;
        CGFloat height = self.numberOfLine>2?with : HEIGHT_PRO(heighttemp);
        _chooseImageBtn  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,with, height)];
        
        [_chooseImageBtn addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
        _chooseImageBtn.tag = -1;
        UIImageView * addimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_PRO(10),0,with-WIDTH_PRO(10),height-WIDTH_PRO(10))];
        addimage.image = ImageNamed(_addBtnImage);
        [_chooseImageBtn addSubview:addimage];
        
    }
    return _chooseImageBtn;
}


-(void)chooseImageAction:(UIButton *)sender{

    UIAlertController *switchAlertController = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *photoesAction =[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self pushImagePickerController];
    }];
    [switchAlertController addAction:cancelAction];
    if(self.imagesArry.count < self.maxImagesNumber){
        UIAlertAction *xiangJiAction =[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //相机
            [self takePhoto];
        }];
        [switchAlertController addAction:xiangJiAction];
    }
    [switchAlertController addAction:photoesAction];
    [self.window.rootViewController presentViewController:switchAlertController animated:YES completion:nil];
    return;
}




- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    self.imagesArry = [_selectedPhotos mutableCopy];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self updateImagesView];
    
}


-(void)deleteImagesAction:(UIButton *)sender{
    if(_selectedAssets.count > sender.tag){
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
    }
    [self.imagesArry removeObjectAtIndex:sender.tag];
    [self updateImagesView];
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImagesNumber columnNumber:self.numberOfLine delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //不允许内部拍照
    imagePickerVc.allowTakePicture = NO;
    //允许选择原图
    imagePickerVc.allowPickingOriginalPhoto = YES;
    //不允许选择视频
    imagePickerVc.allowPickingVideo = NO;
    //允许选择照片
    imagePickerVc.allowPickingImage = YES;
    // 目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets;
    
    //不按时间排序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    }];
    
    [self.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        
    } else if ([[TZImageManager manager] authorizationStatus] == 2) {         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) {         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        return [self takePhoto];
    });
    } else {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self.window.rootViewController presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImagesNumber delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = NO;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        self.imagesArry = [_selectedPhotos mutableCopy];
                        [self updateImagesView];
                    }];
                }];
            }
        }];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

@end
