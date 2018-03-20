//
//  HttpHandler.m
//  StreetShopping
//
//  Created by 赵升 on 2016/12/1.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import "HttpHandler.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HttpHandler

#pragma mark *********************************登录注册*****************************
//字符串MD5加密
+(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return [result lowercaseString];
}
#pragma mark *********************************登录注册**************************

#pragma mark - 获取验证码
/*+ (void)getVerifyCodePartParams:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * str = [df stringFromDate:[NSDate date]];
    [dic setValue:str forKey:@"timestamp"];
    
    NSString * ciphertext = [NSString stringWithFormat:@"%@cec850b593ea422b87e4781afd8ddb2%@",dict[@"account"],str];

    [dic setValue:[HttpHandler md5:ciphertext] forKey:@"ciphertext"];
    
    [self appendUrl:@"userApi/sendMsgCode.app" success:success failed:failed postDict:dic];
}*/


#pragma mark - (有图片)
/*+(void)getImgsaveFeedback:(NSDictionary *)dic imageArray:(NSArray *)imageArray imageKeyArray:(NSArray *)imageKeyArray success:(SuccessBlock)success failed:(FailedBlock)failed{
    [ZSHttpTool uploadImageWithPath:@"feedbackApi/saveFeedback.app" params:dic thumbNames:imageKeyArray images:imageArray success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (error) {
            failed(error);
        }
    } progress:^(CGFloat progress) {
        
    }];
}*/

#pragma mark - 上传图片
+(void)getuploadImage:(NSDictionary *)dic imageArray:(NSArray *)imageArray imageKeyArray:(NSArray *)imageKeyArray success:(SuccessBlock)success failed:(FailedBlock)failed{
    [ZSHttpTool uploadImageWithPath:@"/api/v1/uploadImage" params:dic thumbNames:imageKeyArray images:imageArray success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (error) {
            failed(error);
        }
    } progress:^(CGFloat progress) {
        
    }];
}



#pragma mark - 获取系统参数
+(void)getSysConfig:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getSysConfig" success:success failed:failed postDict:dict];
}

#pragma mark - 发送验证码
+(void)getsendSmsValidCode:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/sendSmsValidCode" success:success failed:failed postDict:dict];
}

#pragma mark - 获得文章详情
+(void)getArticleInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getArticleInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 注册
+(void)getregister:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/register" success:success failed:failed postDict:dict];
}

#pragma mark - 登录
+(void)getlogin:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/login" success:success failed:failed postDict:dict];
}

#pragma mark - 重置密码
+(void)getchangePassword:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/changePassword" success:success failed:failed postDict:dict];
}

#pragma mark - 绑定支付宝
+(void)getbindAliPay:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/bindAliPay" success:success failed:failed postDict:dict];
}

#pragma mark - 获得用户个人信息
+(void)getCurrentUser:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getCurrentUser" success:success failed:failed postDict:dict];
}

#pragma mark - 获得我的工分信息
+(void)getMyWorkpoints:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/workpoints/v1/getMyWorkpoints" success:success failed:failed postDict:dict];
}

#pragma mark - 修改个人信息
+(void)getchangeUserInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/changeUserInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 修改绑定手机
+(void)getchangePhone:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/changePhone" success:success failed:failed postDict:dict];
}

#pragma mark - 查询字典数据
+(void)getDictInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getDictInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 绑定银行卡
+(void)getaddBankCard:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/addBankCard" success:success failed:failed postDict:dict];
}

#pragma mark - 实名认证
+(void)getsaveIdCard:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/saveIdCard" success:success failed:failed postDict:dict];
}

#pragma mark - 消息列表
+(void)getMessageList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getMessageList" success:success failed:failed postDict:dict];
}

#pragma mark - 消息详情
+(void)getMessageInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getMessageInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 购买记录
+(void)getC2FbuyRecord:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/c2f/v1/getC2FbuyRecord" success:success failed:failed postDict:dict];
}

#pragma mark - 购买详情
+(void)getWineHid:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/c2f/v1/getWineHide" success:success failed:failed postDict:dict];
}

#pragma mark - 首页数据
+(void)getHome:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getHome" success:success failed:failed postDict:dict];
}

#pragma mark - 轮播图信息
+(void)getSliderImages:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getSliderImages" success:success failed:failed postDict:dict];
}

#pragma mark - 商品分类
+(void)getGoodsType:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/goods/v1/getGoodsType" success:success failed:failed postDict:dict];
}

#pragma mark - 商品列表
+(void)getGoodsList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/goods/v1/getGoodsList" success:success failed:failed postDict:dict];
}

#pragma mark - 公告详情
+(void)getNotic:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getNotice" success:success failed:failed postDict:dict];
}

#pragma mark - 评价列表
+(void)getCommentList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/goods/v1/getCommentList" success:success failed:failed postDict:dict];
}

#pragma mark - 反馈
+(void)getaddFeedback:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/mcenter/v1/addFeedback" success:success failed:failed postDict:dict];
}

#pragma mark - 收藏列表
+(void)getMyCollection:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/goods/v1/getMyCollection" success:success failed:failed postDict:dict];
}

#pragma mark - 编辑列表
+(void)getdelConllection:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/goods/v1/delConllection" success:success failed:failed postDict:dict];
}

#pragma mark - 收藏商品
+(void)getaddCollection:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/goods/v1/addCollection" success:success failed:failed postDict:dict];
}

#pragma mark - 工分列表
+(void)getWorkpointsList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/workpoints/v1/getWorkpointsList" success:success failed:failed postDict:dict];
}

#pragma mark - 工分列表明细详情
+(void)getWorkpointsDetail:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/workpoints/v1/getWorkpointsDetail" success:success failed:failed postDict:dict];
}

#pragma mark - 钱包详情
+(void)getWalletInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/paycenter/v1/getWalletInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 余额明细列表
+(void)getBalanceList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/paycenter/v1/getBalanceList" success:success failed:failed postDict:dict];
}

#pragma mark - 余额充值明细列表
+(void)getRechargeDetail:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/paycenter/v1/getRechargeDetail" success:success failed:failed postDict:dict];
}

#pragma mark - 提货券明细列表
+(void)getCouponList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/paycenter/v1/getCouponList" success:success failed:failed postDict:dict];
}

#pragma mark - 余额充值
+(void)getwalletRecharge:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/paycenter/v1/walletRecharge" success:success failed:failed postDict:dict];
}

#pragma mark - 提货券充值
+(void)getrechargeCoupon:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/paycenter/v1/rechargeCoupon" success:success failed:failed postDict:dict];
}

#pragma mark - 获取解绑银行卡信息
+(void)getBindBankCard:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getBindBankCard" success:success failed:failed postDict:dict];
}

#pragma mark - 获取商品信息
+(void)getGoodInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/goods/v1/getGoodInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 加入商脉圈
+(void)getaddVencircle:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/area/v1/addVencircle" success:success failed:failed postDict:dict];
}

#pragma mark - 获取所有的商脉圈
+(void)getAllVencircle:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/area/v1/getAllVencircle" success:success failed:failed postDict:dict];
}

#pragma mark - 获取我的商脉圈
+(void)getMyVencircle:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/area/v1/getMyVencircle" success:success failed:failed postDict:dict];
}

#pragma mark - 获取我的商圈成员
+(void)getMyVencircleMember:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/area/v1/getMyVencircleMember" success:success failed:failed postDict:dict];
}

#pragma mark - 获取我的商圈关系
+(void)getMyVencircleRelation:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/area/v1/getMyVencircleRelation" success:success failed:failed postDict:dict];
}

#pragma mark - 检查短信验证码是否正确
+(void)getcheckSmsValidCode:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/checkSmsValidCode" success:success failed:failed postDict:dict];
}

#pragma mark - 修改支付密码
+(void)getchangePayPassword:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/changePayPassword" success:success failed:failed postDict:dict];
}

#pragma mark - 加入购物车
+(void)getaddShopCar:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/goods/v1/add" success:success failed:failed postDict:dict];
}

#pragma mark - 地区信息
+(void)getLocation:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getLocation" success:success failed:failed postDict:dict];
}

#pragma mark - 收货地址列表信息
+(void)getConsignees:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/mcenter/v1/getConsignees" success:success failed:failed postDict:dict];
}

#pragma mark - 添加收货人信息
+(void)getaddConsignees:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/mcenter/v1/addConsignee" success:success failed:failed postDict:dict];
}

#pragma mark - 设置默认收货地址
+(void)getsetDefaultAddress:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/mcenter/v1/setDefaultAddress" success:success failed:failed postDict:dict];
}

#pragma mark - 收货地址删除
+(void)getdelConsignee:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/mcenter/v1/delConsignee" success:success failed:failed postDict:dict];
}

#pragma mark - 获取收货人信息
+(void)getConsigneeInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/mcenter/v1/getConsigneeInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 获取收货人信息
+(void)getupdateAddress:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/mcenter/v1/updateAddress" success:success failed:failed postDict:dict];
}

#pragma mark - 获取购物车列表
+(void)getShoppingCartList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/goods/v1/getShoppingCartList" success:success failed:failed postDict:dict];
}

#pragma mark - 删除购物车商品
+(void)getdelShoppingCartGoods:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/goods/v1/delShoppingCartGoods" success:success failed:failed postDict:dict];
}

#pragma mark - 修改购物车商品数量
+(void)getchangeNum:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/goods/v1/changeNum" success:success failed:failed postDict:dict];
}

#pragma mark - 获取订单列表
+(void)getOrder:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/order/v1/getOrder" success:success failed:failed postDict:dict];
}

#pragma mark - 获取K线图数据
+(void)getKlineData:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/statistic/v1/getKlineData" success:success failed:failed postDict:dict];
}

#pragma mark - 发表评论
+(void)getaddComment:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/goods/v1/addComment" success:success failed:failed postDict:dict];
}

#pragma mark - 确认收货
+(void)getconfirmReceipt:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/order/v1/confirmReceipt" success:success failed:failed postDict:dict];
}

#pragma mark - 取消订单
+(void)getcancelOrder:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/order/v1/cancelOrder" success:success failed:failed postDict:dict];
}

#pragma mark - 获取物流信息
+(void)getlogisticsInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/order/v1/getlogisticsInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 订单详情
+(void)getOrderDetail:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/order/v1/getOrderDetail" success:success failed:failed postDict:dict];
}

#pragma mark - 删除订单
+(void)getdelOrder:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/order/v1/delOrder" success:success failed:failed postDict:dict];
}

#pragma mark - 订单支付接口
+(void)getorderPay:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/order/v1/orderPay" success:success failed:failed postDict:dict];
}

#pragma mark - 解绑银行卡
+(void)getunBindBankCard:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/v1/unBindBankCard" success:success failed:failed postDict:dict];
}

#pragma mark - 获取默认地址
+(void)getDefaultAddress:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/mcenter/v1/getDefaultAddress" success:success failed:failed postDict:dict];
}

#pragma mark - 获取邮费信息
+(void)getPostage:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/order/v1/getPostage" success:success failed:failed postDict:dict];
}

#pragma mark - 提交订单信息
+(void)getsubmitOrder:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/order/v1/submitOrder" success:success failed:failed postDict:dict];
}

#pragma mark - C2F立即购买
+(void)getC2fInfo:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/c2f/v1/getC2fInfo" success:success failed:failed postDict:dict];
}

#pragma mark - 获得K线图天数
+(void)getSelectDay:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/statistic/v1/getSelectDay" success:success failed:failed postDict:dict];
}

#pragma mark - 获得工分统计信息
+(void)getCurWorkPoints:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/statistic/v1/getCurWorkPoints" success:success failed:failed postDict:dict];
}

#pragma mark - 获得系统订单信息
+(void)getCurOrderStatistics:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/statistic/v1/getCurOrderStatistics" success:success failed:failed postDict:dict];
}

#pragma mark - 获取提现手续费
+(void)getRate:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/v1/getRate" success:success failed:failed postDict:dict];
}

#pragma mark - 申请提现
+(void)getsponsorWithdrawDeposit:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendPostUrl:@"/api/paycenter/v1/sponsorWithdrawDeposit" success:success failed:failed postDict:dict];
}

#pragma mark - 消费记录明细
+(void)getWithdrawDepositRecordList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/paycenter/v1/getWithdrawDepositRecordList" success:success failed:failed postDict:dict];
}

#pragma mark - 消费记录
+(void)getConsumptionList:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/paycenter/v1/getConsumptionList" success:success failed:failed postDict:dict];
}

#pragma mark - 消费记录明细
+(void)getConsumptionDetail:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/paycenter/v1/getConsumptionDetail" success:success failed:failed postDict:dict];
}

#pragma mark - 获取不同状态下的订单数量
+(void)getOrderStatusNum:(NSDictionary *)dict Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [self appendGetUrl:@"/api/order/v1/getOrderStatusNum" success:success failed:failed postDict:dict];
}


+ (void)appendPostUrl:(NSString *)appendUrl success:(SuccessBlock)success failed:(FailedBlock)failed postDict:(NSDictionary *)postDict{
    [ZSHttpTool postWithPath:appendUrl params:postDict success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (error) {
            failed(error);
        }
    }];
}

+ (void)appendGetUrl:(NSString *)appendUrl success:(SuccessBlock)success failed:(FailedBlock)failed postDict:(NSDictionary *)postDict{
    [ZSHttpTool getWithPath:appendUrl params:postDict success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (error) {
            failed(error);
        }
    }];
}




@end
