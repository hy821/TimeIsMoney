//
//  Config.h
//  T-REX
//
//  Created by 锐问 on 15/11/17.
//  Copyright © 2015年 cxy. All rights reserved.
//

#ifndef Config_h

//---------------------------------Common----------------------------\\

//------------------------------屏幕宽高--------------
#define ScreenWidth           [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight          [[UIScreen mainScreen]bounds].size.height

//------------------------------正则表达---------------
/** 手机正则 */
#define RegextestMobile       @"^1([3|5|7|8|])[0-9]{9}$"
/** 密码正则 */
#define RegextestPassword     @"^[@A-Za-z0-9!#$%^&*.~_(){},?:;]{6,20}$"
/** 验证码 */
#define kRegexVerCode         @"^[0-9]{6}$"
/** 邮箱 */
#define RegexestEmail         @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}"

//----------------------------SDK相关数据-----------
//---------------MYH-------------------

#import "AppDelegate.h"
#define g_App               ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define SelectVC          (CEBaseNavViewController*)g_App.tabBarVC.selectedViewController
#define NSValueToString(a)  [NSString stringWithFormat:@"%@",a]

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)



#define ContentOffsetInTop   [UIApplication sharedApplication].statusBarFrame.size.height == 44?88.f:64.f
/** appKey  */
#define DIOpenSDKAppID   @"didi496E4C624F6E707967323276544D6541"
#define DIOpenSDKAppSecret   @"656091463c94db82125728ffe70979f5"

#define NIMAppKey @""

#define WXAppID    @"wxf9b07786a850284f"
#define WXAppSecret   @"6252d2b64b24169f856b82ffa30f36b0"

//#define GRAYColor [UIColor colorWithRed:229/255.f green:229/255.f blue:229/255.f alpha:1]
//#define BACKGROUNDCOLOR [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
//#define TETColor [Utils colorConvertFromString:@"#757575"]
//#define PP_GRAY [Utils colorConvertFromString:@"#C3C3D0"]
//#define PP_RED  [Utils colorConvertFromString:@"#FE8787"]
//#define MESS_COLOR [Utils colorConvertFromString:@"#121212"]
//#define Line_COLOR [Utils colorConvertFromString:@"#DBDBEA"]
//#define BackGray [Utils colorConvertFromString:@"#f2f2f2"]

#define GaoDeAppId @"333e1ff23ed4d1bd5a274c0ae57da97a"
#define MENU_COLOR KCOLOR(@"#933BFF")

/**
 * 新定义
 */
#define MainWindow [UIApplication sharedApplication].keyWindow
#define KFONT(size) [UIFont systemFontOfSize:size]
#define kBLOD_FONT(size) [UIFont boldSystemFontOfSize:size]
#define KCOLOR(str) [Utils colorConvertFromString:str]
#define SSCOLOR(str)  [UIColor colorWithHexString:str]
#define KWIDTH(width) [Helper returnUpWidth:width]
#define KHEIGHT(height) [Helper returnUpWidth:height]
#define KURLSTR(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define K_IMG(str) [UIImage imageNamed:str]

//用户管理类
#define IS_LOGIN [[UserManager shareManager]isLogin]
#define USER_MANAGER [UserManager shareManager]


#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]
#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

// 适配
#define DevicesScale ([UIScreen mainScreen].bounds.size.height==480?1.00:[UIScreen mainScreen].bounds.size.height==568?1.00:[UIScreen mainScreen].bounds.size.height==667?1.17:1.29)

#define weakify(...) \
ext_keywordify \
metamacro_foreach_cxt(ext_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \
ext_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(ext_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

/** 人物头像默认图 */
#define normal_icon [UIImage imageNamed:@"normal"]

/** 商家相关默认图 */
#define normal_goods [UIImage imageNamed:@"normal_goods"]


/** 图片占位图  */
#define normal_photo [UIImage imageNamed:@"normal_back"]

//设备型号
#define MOBILE_TYPE  [[[UIDevice currentDevice] identifierForVendor] UUIDString]


//------------------------------------------UtilsMacro-------------------------------------------\\

// 打印

#ifdef DEBUG
# define SSLog(fmt, ...) NSLog((@"📍[函数名:%s]" "🎈[行号:%d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define SSLog(...)
#endif

#define WSOther(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/**
 *  设置常用设备型号
 *
 *  @return 设备型号
 */
/** iPad */
#define IS_IPad               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** iPhone */
#define IS_IPhone             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** iPhone4 */
#define IS_IPhone4            ([[UIScreen mainScreen] bounds].size.height == 480)
/** iPhone5 */
#define IS_IPhone5            ([[UIScreen mainScreen] bounds].size.height == 568)
/** iPhone6 */
#define IS_IPhone6            ([[UIScreen mainScreen] bounds].size.width == 375)
/** iPhonePlus */
#define IS_IPhonePlus         ([[UIScreen mainScreen] bounds].size.width == 414)

/** 获取设备ID */
#define DEVICE_ID             [[UIDevice currentDevice].identifierForVendor UUIDString]
/** 获取类名 */
#define ClassString NSStringFromClass([self class])


/** 获取系统版本 */
#define SYSTEM_VERSION        [UIDevice currentDevice].systemVersion.floatValue
/** 判断当前iOS系统是否高于iOS7 */
#define IS_IOS7               (SYSTEM_VERSION >= 7.0)
#define IS_IOS8               (SYSTEM_VERSION >= 8.0)

/** 通知中心 */
#define NOTIFICATION          [NSNotificationCenter defaultCenter]
/** NsUserDefault替换 */
#define USERDEFAULTS          [NSUserDefaults standardUserDefaults]
/** 应用程序 */
#define APPLICATION           [UIApplication sharedApplication]
/** URL */
#define URL(url)              [NSURL URLWithString:url]
/** NSInteger 转 NSString */
#define String_Integer(x)     [NSString stringWithFormat:@"%ld",(long)x]
/** [UIImage imageNamed:Description] */
#define Image_Named(str)      [UIImage imageNamed:str]

/** 常用颜色 */
#define Black_Color           [UIColor blackColor]
#define Blue_Color            [UIColor blueColor]
#define Brown_Color           [UIColor brownColor]
#define Clear_Color           [UIColor clearColor]
#define DarkGray_Color        [UIColor darkGrayColor]
#define DarkText_Color        [UIColor darkTextColor]
#define White_Color           [UIColor whiteColor]
#define Yellow_Color          [UIColor yellowColor]
#define Red_Color             [UIColor redColor]
#define Orange_Color          [UIColor orangeColor]
#define Purple_Color          [UIColor purpleColor]
#define LightText_Color       [UIColor lightTextColor]
#define LightGray_Color       [UIColor lightGrayColor]
#define Green_Color           [UIColor greenColor]
#define Gray_Color            [UIColor grayColor]
#define Magenta_Color         [UIColor magentaColor]
#define ThemeColor                    KCOLOR(@"#ffcc00")  //主题颜色


/** 动态设定字体大小 */
#define Get_Size(x)           IS_IPhonePlus ? ((x) + 1) : IS_IPhone6 ? (x) : (x) - 1

#define Font_Size(x)          [UIFont systemFontOfSize:Get_Size(x)]
#define Font_Bold(y)          [UIFont boldSystemFontOfSize:Get_Size(y)]
#define Font_Slim(y)          [UIFont fontWithName:@"STHeitiTC-Light" size:Get_Size(y)]
#define Font_Name(x,y)        [UIFont fontWithName:(x) size:(y)];


/** 字号设置字号：36pt 30pt 24pt */
#define TitleFont             [UIFont systemFontOfSize:Get_Size(18.0f)]
#define NormalFont            [UIFont systemFontOfSize:Get_Size(15.0f)]
#define ContentFont           [UIFont systemFontOfSize:Get_Size(12.0f)]
#define WS() typeof(self) __weak weakSelf = self;
#define SS() typeof(weakSelf) __strong strongSelf = weakSelf;



#define MWeakSelf(type)  __weak typeof(type) weak##type = type;
#define MStrongSelf(type)  __strong typeof(type) type = weak##type;
// 过期提醒
#define HZAddititonsDeprecated(instead) NS_DEPRECATED(1_0, 1_0, 2_0, 2_0, instead)
/** 定位---省 */
#define LocationProvince      @"locationProvince"
/** 定位---市 */
#define LocationCity          @"locationCity"
/** 定位---城市编码*/
#define LocationCityCode    @"locationCityCode"
/** 定位---区 */
#define LocationDistrict      @"locationDistrict"
/** 定位---乡镇街道 */
#define LocationTownShip      @"locationTownShip"
/** 定位--建筑 */
#define LocationBuilding      @"locationBuilding"
/** 定位---经度 */
#define LocationLongitude     @"locationLongitude"
/** 定位---纬度 */
#define LocationLatitude      @"locationLatitude"
/** 定位---兴趣点类型 */
#define LocationType      @"locationType"
/** 定位---poid */
#define LocationPoIID     @"locationPoIId"
/** MYH 定位---基础位置 */
#define LocationAddressMess   @"locdtionAddressMess"
//----------------------------------------APPMarco----------------------------------------\\

// -------------------------------- 用户 ---------------------------------\\
/** 用户id */
#define NowUserID                    @"userid"
/** 用户token */
#define UserToken                    @"token"
/** 用户头像 */
#define UserHeaderImg                @"headerImg"
/** 用户名 */
#define UserNickName                 @"userNickName"
/* 实名认证 */
#define RealName                    @"bcertid"

/** 更新地理位置 */
#define UpdateUserLocation           @"updateUserLocation"

#define SSUpdateUserLocation          @"ssupdateUserLocation"
//余额支付
#define PaySuccessNoti                @"paySuccessNoti"
/** 三方支付完成 */
#define ThirdPayComplete            @"thirdPayComplete"
/** 充值完成 */
#define TopUpComplete               @"thirdPayCompleteTopUp"
//键盘弹起来通知
#define KEYBOARD_SHOW @"keyboard_show"
//token过期
#define OverDateToken @"outDate_token"
//选择地址
#define CheckPlace @"checkPlace"
//数据处理码
#define ErrorCode @"errCode"
#define ErrorMsg  @"errMsg"
#define Succeed   @"succeed"

#define FIRST_IN_KEY            @"FIRST_IN_KEY"
//定位失败的通知
#define ErrorPlace              @"ERROR_PLACE"



//Temple

#define URLStr @"https://ylm.yejingying.com/asset/img/avatar.jpg"

#define defaultURL @"https://ylm.yejingying.com/asset/img/avatar.jpg"

//商铺订单销毁通知
#define OrderDeleteNoti          @"orderDeleteNoti"
//商品订单增加
#define OrderNumRefresh         @"orderNumRefresh"

#define HomeListEndRefresh   @"homeEndRefresh"

#define TabBarRefresh  @"tabBarRefresh"

#define MessageRefresh @"messageRefresh"

#define WebMessageRefresh @"webMessageRefresh"


#define AddIMFriend @"addImFriend"
//数据请求, 每次返回的条数
#define EveryPageCount 10
#define NearbyPeoplePageCount 15

//红包状态 1打开 2过期
#define redPacketState @"redPacketState"
#define WeChatPayCancel @"WeChatPayCancel"


#define   H5_URL_ADD    @"#app"

#define PublishURLKey @"PublishURLKey"
#define DownAppUrl   @"DownLoadUrl"
#define DownLoadContent @"DownLoadContent"
#define HomeNetErrorRefresh @"HomeNetErrorRefresh"

#define RefunceNoti  @"RefunceNoti" //立即退款
#define CancelOrderNoti  @"CancelOrderNoti" //取消订单

#define SettingModelNoti  @"SettingNoti"

#define SearchResultGetPoiSearchResult @"SearchResultGetPoiSearchResult"
#define SearchResultsControllerDidSelectRow @"SearchResultsControllerDidSelectRow"


#define SelectNearbyPeople  @"SelectNearbyPeople"
#define CEAppVersion @"CEAppVersion"

#define BuglyAppKey @"791fa0f631"

#define PlaceUploadSuccess @"PlaceUploadSuccess"

#define UploadTeamNavHiddenType @"UploadTeamNavHiddenType"


#define MessageTableviewReload  @"reloadMessageData"

//展示过的消费奖励红包id字符串
#define ShowedExpensiveRedPacketsIDStr   @"ShowedExpensiveRedPacketsIDStr"

#define SendSelectSearchMessage  @"SendSelectSearchMessage"

#define FirstLaunchNetError @"firstLaunchError"

#define ShowFindBandCardAlert_Key @"ShowFindBandCardAlert_Key"


typedef NS_ENUM(NSUInteger, WebType) {
    /**
     *  webview
     */
    NormalType       = 0,
    /**
     *  wkWebView
     */
    WKType             = 1,
};

#endif


