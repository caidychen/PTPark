//
//  PTConfig.swift
//  PTPark
//
//  Created by soso on 2017/4/12.
//
//

import UIKit

//葡萄商城的配置
struct PTConfig {
    
    // MARK: 接口服务域名
    /*
     文档地址: http://api-doc-common.ptdev.cn/index.php?act=api&tag=16#info_api_85d8ce590ad8981ca2c8286f79f59954
     */
    
    static let baseURL  = PTBaseURL
    static let storeBaseURL = PTStoreBaseURL
    static let accountBaseURL = PTAccountBaseURL
    static let uploadImageURL = PTUploadImageURL
    static let downloadImageURL = PTDownloadImageURL
    static let versionCheckURL = PTVersionCheckURL
    static let bookingBaseURL = PTBookingBaseURL
    static let PointsH5Base = PTPointsH5BaseURL
    static let growTreeBaseURL = PTGrowTreeBaseURL
    
    // MARK: App配置
    static let AppID    = "8110"
    static let AppKey   = "5d3c8eac0b0c40278fa5c18afcb823bU"
   
    // MARK: 分享链接
    static let ShareWebLink = "http://store.putao.com/toys/ptpark"
    
    // MARK: 外部打开连接
    struct Schemes {
        static let h5       = "putaoparkh5://park"  //自家HTML5
        static let alipay   = "alipay"   //支付宝
    }
    
    // MARK: 联系方式
    struct Contact {
        static let wechat   = "taotaomama1"     //微信号
        static let hotLine  = "400-920-6161"    //热线电话
    }
    
    // MARK: 验证码用途
    struct Action {
        static let register = "register"    //注册
        static let forget   = "forget"      //忘记密码
    }
    
    // MARK: 提示延时消失
    struct PTHUD {
        static let delay    = 0.5
    }
    
    struct StatusCode {
        static let success = 200
        static let failure = 600
    }
    
    // MARK: 微信
    struct WeChat {
        static let AppID    = "wxe42eeee5cfdf4058"
    }
    
    // MARK: 友盟统计
    struct Umeng {
        static let AppKey   = "58fdd44207fe654196001588"
        static let Channel  = PTUMChannel
    }
    
    // MARK: App更新
    struct AppVersion{
        static let check = "/upgrade"
    }
    
    // MARK: GPush的配置
    struct GPush {
        static let type     = GPushType
        static let AppID    = "1015"    //应用id
        static let AppKey   = "9abe9ded8dd77ec0ad9a707020438ff6"    //服务端的key
        static let Token    = "01ca1d74a301b0fb1e2a2b0446d7e796"    //服务端的token
    }
    
    // MARK: 产品详情
    struct Product {
        
        static let base         = "/product_detail.html?inapp=1"
        static let videoBase    = "/video.html?vid="
        static let shareBase    = "/wx_product.html?product_id="
        /*  查看产品详情
         */
        static let view = "/product/view"
        /*  获取产品规格
         */
        static let spec = "/product/spec"
        /*  商品详情推荐评价Top1
         */
        static let topComment = "/product/comment/productDetailComment"
        /*  商品推荐10条评论 卡片展示
         */
        static let cycleComment = "/product/comment/productRecommendComment"
        /*  商品所有评价列表
         */
        static let allComment = "/product/comment/lists"
        /*  用户评价列表
         */
        static let userComment = "/product/comment/userCommentList"
        /*  用户评价详情
         */
        static let userCommentInfo = "/product/comment/getCommentInfo"
        /*  商品详情精美图集
         */
        static let productPhoto = "/product/product/productPlatformImage"
        /*  相关产品推荐
         */
        static let productRelation = "/mall/product/relation"
        /*  产品视频
         */
        static let productVideo = "/product/video"
        /*  产品详情页推荐视频
         */
        static let productVideoRecommended = "/product/video/recommend"
        /*  产品测评推荐
         */
        static let productEvaluationRecommended = "/product/evaluation/recommend"
        /*  通过product条形码 获取product_id
         */
        static let productIDByProductNumber = "/product/product/productIdByProductNumber"
    }
    
    //MARK: 成长板块
    struct Grow{
        /*  成长首页顶部数据
         */
        static let growingIndex = "/growing/index"
        /*  成长首页推荐产品板块
         */
        static let growingProduct = "/plate/growing"
        /*  专业测评
         */
        static let evaluationIndex = "/evaluation/index"
        /*  自主学习
         */
        static let learningIndex = "/learning/index"
        //文章列表
        static let getArticleList = "/article/list"
        //文章详情
        static let getArticleDetail = "/article/detail"
        //获取标签文章列表
        static let getTagArticle = "/tag/article"
        // 产品攻略---模块跳转文章列表
        static let geTraidersBlock = "/raiders/block/article/list"
    }
    
    //MARK: 优惠券
    struct Coupon {
        /*  我的优惠券
         */
        static let myCoupon = "/card/card/myCard"
        /*  新人礼
         */
        static let couponNewGift = "/user/new/gift"
        /*  领取新人礼
         */
        static let obtainCouponGift = "/user/new/get/gift"
        /*  离线新人礼
         */
        static let offlineCouponGift = "/user/new/offline"
    }
    
    // MARK: 购物车
    struct Cart {
        /*  添加单个商品到购物车
         *  in  :   activity_id : 活动ID
                    sku_id      : SKU ID号
                    quantity    : 数量
         */
        static let add = "/product/cart/addNew"
        
        /*  从购物车中删除单一商铺
         *  in  :   activity_id : 活动ID
                    sku_id : SKU ID号
         */
        static let del = "/product/cart/delNew"
        
        /*  更新购物车
         *  in  :   {"activity_id":1, "sku_id":1, "quantity":1}
         */
        static let update = "/product/cart/editNew"
        
        /*  批量更新购物车
         *  in  :   ["products" :  [{"activity_id":1, "sku_id":1, "quantity":1},
                                    {"activity_id":1, "sku_id":2, "quantity":3}]]
         */
        static let batchUpdate = "/product/cart/batchUpdateNew"
        
        /*  批量更新购物车
         *  in  :   ["products" :  [{"activity_id":1, "sku_id":5, "is_selected":1, "is_delete":0},
                                    {"activity_id":2, "sku_id":3, "is_selected":0, "is_delete":1}]]
         */
        static let batchSelect = "/product/cart/updateSelect"
        
        /*  查看购物车
         *  in  :   none
         */
        static let query = "/product/cart/viewNew"
        
        /*  查询购物车中商品总数量
         *  in  :   none
         */
        static let totalQuantity = "/product/cart/totalQuantityNew"
        
        /*  清空购物车
         *  in  :   none
         */
        static let clean = "/product/cart/cleanNew"
        
        /*  购物车中的猜你喜欢
         *  in  :   none
         */
        static let recommend = "/shop/recommend"
        
        /*  全品加价购产品
         *  in  : none
         */
        static let allIncrease = "/activity/sales/allIncreasePriceSku"
        
    }
    
    // MARK: 收货地址
    struct Address {
        
        /*  收货地址新增
         *  in  :   province_id : 省份id
                    city_id     : 城市id
                    area_id     : 区域id
                    address     : 详细地址
                    mobile      : 手机号
                    tel
                    realname    : 收货人姓名
                    status
         */
        static let add = "/address/add"
        
        /*  收货地址删除
         *  in  :   id  : 收货地址id
         */
        static let del = "/address/del"
        
        /*  收货地址更新
         *  in  :   province_id : 省份id
                    city_id     : 城市id
                    area_id     : 区域id
                    address     : 详细地址
                    mobile      : 手机号
                    tel
                    realname    : 收货人姓名
                    status
         */
        static let update = "/address/update"
        
        /*  用户收货地址列表
         *  in  :   none
         */
        static let query = "/address/lists"
        
        /*  获取默认收货地址
         *  in  :   none
         */
        static let def = "/user/address/getDefaultAddress"
        
    }
    
    // MARK: 订单
    struct Order {
        
        /*  确认订单
         *  in  :   type        :   购买方式 1.立刻购买 2.购物车购买
         buy_content :   购买的json 数组
         [{"act_id":0,"act_type":0,"sku_list":[{"sku_id":191,"quantity":1}]},
         {"act_id":96,"act_type":6,"sku_list":[{"sku_id":190,"quantity":1}]}]
         */
        static let confirm = "/order/confirmNew"
        
        /*  订单保存
         *  in  :   type        :   购买方式 1.立刻购买 2.购物车购买
         buy_content :   购买的json 数组
         [{"act_id":0,"act_type":0,"sku_list":[{"sku_id":191,"quantity":1}]},
         {"act_id":96,"act_type":6,"sku_list":[{"sku_id":190,"quantity":1}]}]
         */
        static let save = "/order/saveNew"
        
        /*  订单列表
         *  in  :   type : 1待付款, 2待发货, 3待收货, 4已完成
                    page : 分页数
         */
        static let list = "/order/order/lists"
        
        /*  订单详情
         *  in  :   id : 订单ID号
         */
        static let detail = "/order/order/detail"
        
        /*  订单支付
         *  in  :   order_id        :   订单ID,
                    payment_type    :   支付宝 ALI_APP,微信 WX_APP
         */
        static let pay = "/pay/mobile/toPay"
        
        /*  取消订单
         *  in  :
         */
        static let cancel = "/order/order/cancel"
        
        /*  订单物流
         *  in  :
         */
        static let orderExpress = "/order/express/orderExpress"
        
        /** 评价 */
        static let createComment = "/product/comment/createComment"
        
        /** 更新评价 */
        static let updateComment = "/product/comment/updateComment"
        
        /** 晒图 */
        static let commentUploadImg = "/product/comment/commentUploadImg"
    }
    
    // MARK: 首页商城
    struct Mall {
        /** 商城头部 */
        static let mall = "/mall"
        /** 商城首页产品列表 */
        static let list = "/plate/list"
        /** 商城分页产品 */
        static let product = "/mall/product/all"
    }
    
    // MARK: 账户相关
    struct Account {
        
        static let Version      = "1.0"
        static let ClientType   = "1"
        static let PlatformId   = "1"
        
        /** 获取验证码 */
        static let message = "/send/message"
        /** 校验验证码 */
        static let checkMessage = "/check/message"
        /** 注册 */
        static let register = "/user/register"
        /** 登录 */
        static let login = "/user/login"
        /** 登录背景图 */
        static let signImage = "/sign/image"
        /** 登出 */
        static let logout = "/user/logout"
        /** 签到 */
        static let signdaily = "/member/signdaily"
        /** 获取上传图片的token */
        static let uploadToken = "/get/upload/token"
        /** 设置头像 */
        static let avatar = "/set/avatar"
        /** 设置昵称 */
        static let nickname = "/set/nickname"
        /** 修改密码 */
        static let setPassword = "/set/password"
        /** 忘记密码 */
        static let forgetPassword = "/forget/password"
        /** 获取会员基本信息 */
        static let getMemberInfo = "/member/getuserinfo"
        /** 查询家长孩子信息 */
        static let getMemberChilds = "/member/getchilds"
        /** 获取会员、孩子信息 */
        static let setInfo = "/member/setinfo"
        /** 获取积分历史查询 */
        static let pointsDetail = "/member/pointsdetail"
        
        //成长历史
        static let growDetail = "/member/growdetail"
        
        //消息中心列表
        static let messageCenter = "/message/center"
        
        //订单数量
        static let userOrderCount = "/user/user/userOrderCount"
    }
    
    struct Booking {
        //品牌门店
        static let getStore = "/get/store"
        //可预约产品
        static let getStoreProduct = "/get/store/product"
        //预约日期列表
        static let getStoreBookingdate = "/get/store/bookingdate"
        //指定日期预约时间列表
        static let getStoreBookingtime = "/get/store/bookingtime"
        //创建预约
        static let addBooking = "/add/booking"
        //获取预约列表
        static let getBookingList = "/get/booking/list"
        //取消预约
        static let cancelBooking = "/cancel/booking"
        //全景图片
        static let panorama = "http://test.fe.ptdev.cn/ptpark/v1.2.0/360.html?inapp=1"
    }
    
    struct Strategy {
        
        //攻略首页
        static let index    = "/product/raiders/index"
        
        //单个产品攻略的头部数据
        static let header   = "/product/raiders/list"
        
        //单个产品攻略
        static let single   = "/product/raiders/article"
        
    }
}
