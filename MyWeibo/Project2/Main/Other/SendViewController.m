//
//  SendViewController.m
//  Project2
//
//  Created by Fxxx on 16/8/11.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeButton.h"
#import "Common.h"
#import "UIViewExt.h"
#import "MMDrawerController.h"
#import "LocationViewController.h"
#import "BaseNavigationController.h"
#import "DataService.h"
#import "MBProgressHUD.h"
#import "FacePanel.h"
#import "FaceView.h"

@interface SendViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,FaceViewDelegate>

@end

@implementation SendViewController{
    //1.编辑输入框
    UITextView * _textView;
    //2.工具栏
    UIView * _editorBar;
    
    UILabel * _locationLabel;
    
    UIImageView * _imgView;
    
    FacePanel * _facepanel;
}

- (FacePanel *)facepanel{
    if (_facepanel == nil) {
        _facepanel = [[FacePanel alloc] initWithFrame:CGRectMake(0, kScreenHeight, 0, 0)];
        _facepanel.faceView.delegate = self;
        [self.view addSubview:_facepanel];
    }
    return  _facepanel;
}

- (UIImageView *)imgView{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.backgroundColor = [UIColor clearColor];
        _imgView.bottom = _editorBar.top;
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

-(UILabel *)locationLable{
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 30)];
        [_editorBar addSubview:_locationLabel];
    }
    return _locationLabel;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createNav];
    [self _loadEditorBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
    
}

-(void)_createNav{
    
    ThemeButton * closeBut = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeBut.imgName = @"button_icon_close.png";
    [closeBut addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeBut];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    ThemeButton * sendBut = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendBut.imgName = @"button_icon_ok.png";
    [sendBut addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    self.navigationItem.rightBarButtonItem = sendItem;
    
}



- (void)_loadEditorBar{
    
    //1.创建输入框视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;
    [self.view addSubview:_textView];
    
    //2.创建编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 55)];
    
    _editorBar.backgroundColor = [UIColor clearColor
                                  ];
    [self.view addSubview:_editorBar];
    
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        button.imgName = imgName;
        [_editorBar addSubview:button];
    }
}

- (void)showKeyBoard:(NSNotification *)notification{
    _textView.height = kScreenHeight - _editorBar.height - [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    _editorBar.top = _textView.bottom;
    self.imgView.bottom = _editorBar.top;
}
- (void)hiddenKeyBoard:(NSNotification *)notification{
    _editorBar.bottom = self.view.bottom;
    self.imgView.bottom = _editorBar.top;
}

- (void)closeAction:(ThemeButton *)but{
    [_textView resignFirstResponder];
    MMDrawerController * mmDrawCtr = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [mmDrawCtr closeDrawerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendAction:(ThemeButton *)but{
    
    if (_textView.text.length <= 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"内容不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if (_textView.text.length > 140){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"不能超过140个字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    NSDictionary * dataDic = nil;
    NSString * url = [NSString string];
    if (self.imgView.image) {
        dataDic = @{@"pic":UIImageJPEGRepresentation(self.imgView.image, 1)};
        url = @"statuses/upload.json";
        
    }else{
        url = @"statuses/update.json";
        
    };
    [DataService requestWithUrl:url mathod:@"POST" params:@{@"status" : _textView.text} data:dataDic success:^(id result) {
        NSLog(@"发送成功");
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        hud.labelText = @"发送成功";
        [hud hide:YES afterDelay:2];
    } failure:^(NSError *error) {
        NSLog(@"发送失败");
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error.jpg"]];
        hud.labelText = @"发送失败";
        [hud hide:YES afterDelay:2];
    }];
    [self closeAction:nil];
}



- (void)clickAction:(UIButton *)btn{
    
    if (btn.tag == 13) {
        LocationViewController * locationView = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"locationView"];
        locationView.location= ^(NSString * address){
            [self locationLable].text = address;
        };
        
        
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:locationView];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (btn.tag == 10){
        
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"打开相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
        [_textView resignFirstResponder];
        
    }else if (btn.tag == 14){
        self.facepanel.faceFileArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"]];
        if ([_textView isFirstResponder]) {
            [_textView resignFirstResponder];
            [UIView animateWithDuration:.3 animations:^{
                self.facepanel.transform = CGAffineTransformMakeTranslation(0, -self.facepanel.height);
            }];
            _editorBar.bottom = self.facepanel.top;
        }else{
            [_textView becomeFirstResponder];
            [UIView animateWithDuration:.3 animations:^{
                self.facepanel.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

#pragma mark ActionSheetDElegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIImagePickerController * imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }else{
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

#pragma mark ImgPickerDelegate----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;{
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage * img = info[UIImagePickerControllerOriginalImage];
        self.imgView.image = img;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//取消按钮的代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) selectFaceChs:(NSString *)faceName;{
    _textView.text = [_textView.text stringByAppendingString:faceName];
}



@end
