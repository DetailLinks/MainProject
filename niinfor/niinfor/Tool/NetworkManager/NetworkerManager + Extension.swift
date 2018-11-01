//
//  NetworkerManager + Extension.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/27.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import Foundation
import AFNetworking
import SVProgressHUD

extension NetworkerManager{
    
    /// 登录接口 : 通过密码
    ///
    /// - Parameters:
    ///   - dict: 密码和用户名
    ///   - complict: 返回的请求数据
    func loginRequest(UsernameAndPassword dict : [String : String] , complict : @escaping ( _ isSuccess : Bool , _ code : Int )->() ) {
        
        request(method: .POST, urlString: "login", parameters: dict as [String : AnyObject]) { (json, isSuccess) in
            
            let jon = json as? [String : AnyObject]
            
            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            
            
            complict(isSuccess ,jon?["code"] as? Int ?? -2)
        }
        
    }
    
    /// 登录接口 ：通过验证码
    ///
    /// - Parameters:
    ///   - dict: 验证码和用户名
    ///   - complict: 返回的请求数据
    func captchaLogin(userNameAndCode dict : [String : String] , complict : @escaping ( _ isSuccess : Bool ,_ code : Int)->() ) {
        
        request(method: .POST, urlString: "v1/captchaLogin", parameters: dict as [String : AnyObject]) { (json, isSuccess) in
            
            let jon = json as? [String : AnyObject]
            
            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            
            
            complict(isSuccess ,jon?["code"] as? Int ?? -2)
        }
        
    }

    /// 登录接口 ：通过userid
    ///
    /// - Parameters:
    ///   - dict: userid
    ///   - complict: 返回的请求数据
    func getUserByLogin(_ userid : String , complict : @escaping ( _ isSuccess : Bool )->() ) {
        
        request(method: .POST, urlString: "v1/getUserByLogin", parameters: ["userId" : userid ] as [String : AnyObject]) { (json, isSuccess) in
            
            let jon = json as? [String : AnyObject]
            
            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            
            
            complict(isSuccess)
        }
        
    }

    
    ///获取登录验证码
    func getCaptchaByLogin(_ code : String , complict : @escaping ( _ isSuccess : Bool )->() ) {

        request(method: .POST, urlString: "v1/getCaptchaByLogin", parameters: [ "phoneno" : code as AnyObject ]) { (json , isSuccess) in
            
            return complict(isSuccess)
            
        }
    }

    
    
    
    ///获取学历
    func getEducations(complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "getEducations", parameters: [:]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFEducationModel])
            
        }
    }

    ///获取职称列表
    func getTitles(complict : @escaping ( _ isSuccess : Bool,_ code : WFRankModel)->() ) {
        
        request(urlString: "getTitles", parameters: [:]) { (json , isSuccess) in
            
            let json = json as? [String : AnyObject]
            
            let model = WFRankModel()
                model.yy_modelSet(with:json?["data"] as! [AnyHashable : Any] ?? [:])
            
            return complict(isSuccess,model)
            
        }
    }

    ///获取科室
    func getHospdepts(complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "getHospdepts", parameters: [:]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFEducationModel])
            
        }
    }

    ///获取单位
    func searchHospital(_ dict : [String : String], complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "searchHospital", parameters: dict as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] ) as? [WFEducationModel]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }

    ///获取亚专业
    func getSpecialities(_ dict : [String : String], complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "getSpecialities", parameters: dict as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] ) as? [WFEducationModel]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }
    

    ///获取快速注册手机验证码
    func getFastRegisterSign(_ dict : [String : String], complict : @escaping ( _ isSuccess : Bool)->() ) {
        
        request(method: .POST,urlString: "getFastRegisterSign", parameters: dict as [String : AnyObject]) { (json , isSuccess) in
            
            return complict(isSuccess)
            
        }
    }
    
    ///获取忘记密码手机验证码
    func getUpdatePasswordSign(_ dict : [String : String], complict : @escaping ( _ isSuccess : Bool)->() ) {
        
        request(method: .POST,urlString: "getUpdatePasswordSign", parameters: dict as [String : AnyObject]) { (json , isSuccess) in
            
            return complict(isSuccess)
            
        }
    }

    ///忘记密码之后获取验证码之后的修改密码
    func forgetPassword(_ dict : [String : String], complict : @escaping ( _ isSuccess : Bool)->() ) {
        
        request(method: .POST,urlString: "forgetPassword", parameters: dict as [String : AnyObject]) { (json , isSuccess) in
            
            return complict(isSuccess)
            
        }
    }
    
    ///获取快速注册
    func fastRegister(_ dict : [String : String], complict : @escaping ( _ isSuccess : Bool)->() ) {
        
        request(method: .POST,urlString: "fastRegister", parameters: dict as [String : AnyObject]) { (json , isSuccess) in
            
            let json = json as? [String : AnyObject]
            
            self.userCount.yy_modelSet(with: json?["data"] as? [AnyHashable : Any] ??  [:]  )

            return complict(isSuccess)
            
        }
    }
    
    ///获取用户信息接口
    
    func getUser(complict : @escaping ( _ isSuccess : Bool, _ model : WFUserAccount )->() ) {
        
        request(method: .POST, urlString: "getUser", parameters: ["userId" : NetworkerManager.shared.userCount.id ?? ""] as [String : AnyObject]) { (json, isSuccess) in
            
            let json = json as? [String : AnyObject]
            
            let model  = WFUserAccount()
            model.yy_modelSet(with: json?["data"] as? [AnyHashable : Any] ??  [:]  )
            
            return complict(isSuccess,model)
        }
    }
    
    ///上传头像接口uploadAvatar
    func uploadAvatar(_ images : [UIImage] ,complict : @escaping ( _ isSuccess : Bool, _ model : [ String : AnyObject] )->() ) {
        request(method: .Construct, images: images, pictureName: "avatar", urlString: "uploadAvatar", parameters: ["userId" : NetworkerManager.shared.userCount.id ?? ""] as [String : AnyObject]) { (json, isSuccess) in

              let json = json as? [String : AnyObject]
            
            complict(isSuccess, json?["data"] as? [String : AnyObject] ?? [:])
        }
    }
    
    ///上传头像接口uploadAvatar
    func uploadEmpcard(_ images : [UIImage] ,complict : @escaping ( _ isSuccess : Bool, _ model : [ String : String] )->() ) {
        request(method: .Construct, images: images, pictureName: "empcard", urlString: "uploadEmpcard", parameters: ["userId" : NetworkerManager.shared.userCount.id ?? ""] as [String : AnyObject]) { (json, isSuccess) in
            
            let json = json as? [String : AnyObject]
            
            complict(isSuccess, json?["data"] as? [String : String] ?? [:])
        }
    }

    ///获取资讯会议收藏列表
    func collectList(_ type : Int , _ page : String, complict : @escaping ( _ isSuccess : Bool,_ code : [WFMeetingModel])->() ) {
        
        request(urlString: "member/collectList", parameters: ["userid" : NetworkerManager.shared.userCount.id ?? "","type": type , "pageNo" : page , "pageSize" : "10"] as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFMeetingModel.self  , json: json?["list"]  ?? [] ) as? [WFMeetingModel]
            
            return complict(isSuccess,modelArray ?? [] )
        }
    }
    
   ///获取资讯视频列表
    func collectListInfor(_ type : Int , _ page : String, complict : @escaping ( _ isSuccess : Bool,_ code : [WFCollectionModel])->() ) {
        
        request(urlString: "member/collectList", parameters: ["userid" : NetworkerManager.shared.userCount.id ?? "","type": type , "pageNo" : page , "pageSize" : "10"] as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFCollectionModel.self  , json: json?["list"]  ?? [] ) as? [WFCollectionModel]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }

    
    //getAppAdSolts

    ///获取资讯广告收藏列表
    func getAppAdSolts(complict : @escaping ( _ isSuccess : Bool,_ code : [WFAdModel])->() ) {
        
        request(urlString: "getAppAdSolts", parameters: ["appType": 1] as [String : AnyObject]) { (json , isSuccess) in
            
            
            let modelArray  = NSArray.yy_modelArray(with: WFAdModel.self , json: json?["list"]  ?? [] ) as? [WFAdModel]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }

    ///更新密码
    func updatePassword(_ oldpassword : String,_ newpassword : String ,complict : @escaping ( _ isSuccess : Bool)->() ) {
        
        request(method : .POST,urlString: "updatePassword", parameters: ["userId": NetworkerManager.shared.userCount.id ?? "","oldpassword": oldpassword , "newpassword" : newpassword  ] as [String : AnyObject]) { (json , isSuccess) in
            
      // let modelArray  = NSArray.yy_modelArray(with: WFMeetingModel.self , json: json?["list"]  ?? [] ) as? [WFMeetingModel]
            
            return complict(isSuccess)
        }
    }

    
    ///获取首页资讯列表
    func getHomePageInfo(_ page : Int , complict : @escaping ( _ isSuccess : Bool,_ code : [WFCollectionModel])->() ) {
        
        request(urlString: "getHomePageInfo", parameters: ["pageNo":"\(page)","pageSize":"10"] as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFCollectionModel.self , json: json?["list"]  ?? [] ) as? [WFCollectionModel]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }

    
    
    ///提交反馈
    func submitSuggest(_ params :  [String : AnyObject] , complict : @escaping ( _ isSuccess : Bool,_ code : String)->() ) {
        
        request(method: .POST,urlString: "submitSuggest", parameters: params ) { (json , isSuccess) in

            let json = json as? [String : AnyObject]

            guard let number = json?["data"]?["id"] as? Int else {
                return complict(false , "-1" )
            }
            
            return complict(isSuccess,"\(number)" )
            
        }
    }

    ///获取病例讨论列表
    func getUserCaseList(_ page : Int , complict : @escaping ( _ isSuccess : Bool,_ code : [WFDiscussModel])->() ) {
        
        request(urlString: "getUserCaseList", parameters: ["pageNo":"\(page)","pageSize":"10","userId":userCount.id ?? ""] as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFDiscussModel.self , json: json?["list"]  ?? [] ) as? [WFDiscussModel]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }
    
    ///完善信息
    func perfectInformation(_ params :  [String : AnyObject] , complict : @escaping ( _ isSuccess : Bool)->() ) {
        
        request(method: .POST,urlString: "perfectInformation", parameters: params ) { (json , isSuccess) in
            
            let json = json as? [String : AnyObject]
            return complict(isSuccess )
            
        }
    }

    
    ///修改个人信息
    func updateUserInfo(_ params :  [String : AnyObject] , complict : @escaping ( _ isSuccess : Bool , _ json : [AnyHashable : Any])->() ) {
        
        request(method: .POST,urlString: "updateUserInfo", parameters: params ) { (json , isSuccess) in
//            
            let json = json as? [String : AnyObject]
            
            return complict(isSuccess,json?["data"] as? [AnyHashable : Any] ??  [:])
            
        }
    }

}


///会议视频接口
extension NetworkerManager {
    
    ///获取省份列表接口
    func meetingProvinceList(complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "meeting/meetingProvinceList", parameters: [:]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFEducationModel])
            
        }
    }
    
    ///获取会议专科列表接口
    func getMeetingSpecialites(complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "meeting/getMeetingSpecialites", parameters: [:]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFEducationModel])
            
        }
    }

    ///获取直播中会议接口
    func getMeetingLive(_ params : [String : String] , complict : @escaping ( _ isSuccess : Bool,_ code : [WFPlayModel])->() ) {
        
        request(urlString: "meeting/getMeetingLive", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFPlayModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as? [WFPlayModel] ?? [])
            
        }
    }
    
    ///获取精彩录播接口
    func meetingRecording(_ params : [String : String] ,  complict : @escaping ( _ isSuccess : Bool,_ code : [WFMeetingModel])->() ) {
        
        request(urlString: "meeting/meetingRecording", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFMeetingModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFMeetingModel])
            
        }
    }

    ///获取直播预告接口
    func meetingLivetrailer(_ params : [String : String] , complict : @escaping ( _ isSuccess : Bool,_ code : [WFMeetingModel])->() ) {
        
        request(urlString: "meeting/meetingLivetrailer", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFMeetingModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFMeetingModel])

        }
    }

    ///获取搜索信息接口
    func searchInfo(_ keywords : String ,_ pageNo : Int ,complict : @escaping ( _ isSuccess : Bool,_ code : [WFCollectionModel])->() ) {
        
        request(urlString: "searchInfo", parameters: ["keywords":keywords as AnyObject,"pageNo" : "\(pageNo)" as AnyObject,"pageSize":"10" as AnyObject]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFCollectionModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFCollectionModel])
            
        }
    }
  
    ///获取医院搜索信息接口
    func hospital(complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "meeting/hospital", parameters: [:]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as! [WFEducationModel])
            
        }
    }

    ///获取其他搜索信息接口
    func other(complict : @escaping ( _ isSuccess : Bool,_ code : [WFEducationModel])->() ) {
        
        request(urlString: "meeting/other", parameters: [:]) { (json , isSuccess) in
            
            let modelArray = NSArray.yy_modelArray(with: WFEducationModel.self , json: json?["list"]  ?? [] )
            
            return complict(isSuccess,modelArray as? [WFEducationModel] ?? [])
            
        }
    }

}


///微信登录 授权
extension NetworkerManager{

    
    ///判定是否存在微信用户
    /// - Parameters:
    ///   - unionid: 微信id
    ///   - complict: 返回的请求数据
    func unionidIsExist(_ unionid : String , complict : @escaping ( _ isSuccess : Bool ,_ code : Int )->() ) {
        
        request(method: .POST, urlString: "v1/unionidIsExist", parameters: ["unionid" : unionid ] as [String : AnyObject]) { (json, isSuccess) in
            
            let jon = json as? [String : AnyObject]
            
            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            
            
            complict(isSuccess,jon?["code"] as? Int ?? -2)
        }
    }
    
    
    ///判定是否存在微信用户
    /// - Parameters:
    ///   - unionid: 微信id
    ///   - captcha: 验证码
    ///   - username: 手机号
    ///   - complict: 返回的请求数据
    func bindWeixinUid(_ username : String ,_ captcha : String , _ unionid : String , complict : @escaping ( _ isSuccess : Bool ,_ code : Int )->() ) {
        
        request(method: .POST, urlString: "v1/bindWeixinUid", parameters: ["unionid" : unionid ,
                                                                           "captcha" : captcha,
                                                                           "username" : username] as [String : AnyObject]) { (json, isSuccess) in
            
            let jon = json as? [String : AnyObject]
            
            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            
            
            complict(isSuccess,jon?["code"] as? Int ?? -2)
        }
    }
    
    
    ///绑定微信用户设置密码
    /// - Parameters:
    ///   - unionid: 微信id
    ///   - captcha: 验证码
    ///   - username: 手机号
    ///   - complict: 返回的请求数据
    func bindWeixinUidRegister(_ username : String ,_ captcha : String , _ unionid : String , complict : @escaping ( _ isSuccess : Bool ,_ code : Int )->() ) {
        
        request(method: .POST, urlString: "v1/bindWeixinUidRegister", parameters: ["unionid" : unionid ,
                                                                           "password" : captcha,
                                                                           "username" : username] as [String : AnyObject]) { (json, isSuccess) in
                                                                            
                                                                            let jon = json as? [String : AnyObject]
                                                                            
                                                                            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
                                                                            
                                                                            
                                                                            complict(isSuccess,jon?["code"] as? Int ?? -2)
        }
    }
    
    /// - Parameters:
    ///   - unionid: 微信id
    ///   - userId: 手机号
    ///   - complict: 返回的请求数据
    func userIdBindWeixin(_ unionid : String , complict : @escaping ( _ isSuccess : Bool ,_ code : Int )->() ) {
        
        request(method: .POST, urlString: "v1/userIdBindWeixin", parameters: ["unionid" : unionid ,
                                                                              "userId" : NetworkerManager.shared.userCount.id ?? ""] as [String : AnyObject]) { (json, isSuccess) in
                                                                                
                                                                                let jon = json as? [String : AnyObject]
                                                                                
                                                                                self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
                                                                                
                                                                                
                                                                                complict(isSuccess,jon?["code"] as? Int ?? -2)
        }
    }
    
    
    
    ///取消绑定用户
    /// - Parameters:
    ///   - userId: 微信id
    ///   - complict: 返回的请求数据
    func cancleBindWeixin( complict : @escaping ( _ isSuccess : Bool ,_ code : Int )->() ) {
        
        request(method: .POST, urlString: "v1/cancleBindWeixin", parameters: ["userId" : userCount.id ?? "" ] as [String : AnyObject]) { (json, isSuccess) in
            
            let jon = json as? [String : AnyObject]
            
            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            
            
            complict(isSuccess,jon?["code"] as? Int ?? -2)
        }
    }
    
    ///获取病例亚专业列表
    func getMpSubspecialty(complict : @escaping ( _ isSuccess : Bool,_ code : [WFMPSubSpecialty])->() ) {
        
        request(urlString: "v1/mp/getSubspecialty", parameters: [:]) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFMPSubSpecialty.self , json: json?["list"]! ?? [] ) as? [WFMPSubSpecialty]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }
    // 获取我的病例
    func getMpUserArticles(_ pageNo:Int, _ pageSize:Int = 10, complict : @escaping ( _ isSuccess : Bool,_ code : [WFMPArticle])->() ) {
        var params = [String:AnyObject]()
        params["creatorId"] = NetworkerManager.shared.userCount.id as AnyObject
        params["pageNo"] = pageNo as AnyObject
        params["pageSize"] = pageSize as AnyObject
        request(urlString: "v1/mp/userArticle", parameters: params) { (json , isSuccess) in
            
            let modelArray  = NSArray.yy_modelArray(with: WFMPArticle.self , json: json?["list"]! ?? [] ) as? [WFMPArticle]
            
            return complict(isSuccess,modelArray ?? [] )
        }
    }
    ///上传病例文件
    func uploadMPFile(_ filepath : String ,complict : @escaping ( _ isSuccess : Bool, _ model : String )->() ) {
//        request(method: .Construct, images: [], pictureName: "empcard", urlString: "uploadEmpcard", parameters: ["userId" : NetworkerManager.shared.userCount.id ?? ""] as [String : AnyObject]) { (json, isSuccess) in
//
//            let json = json as? [String : AnyObject]
//
//            complict(isSuccess, json?["data"] as? [String : String] ?? [:])
//        }
        uploadFile(fileName: filepath, urlString: "v1/mp/uploadFile", parameters: [:]) {
            (json, isSuccess) in
            let json = json as? [String : AnyObject]
            complict(isSuccess, json?["data"]?["filePath"] as? String ?? "")
        }
    }
    //病例 保存文章
    func mpSaveArticle(_ params : [String : AnyObject] , complict : @escaping ( _ isSuccess : Bool ,_ code :  [String : AnyObject] )->() ) {
        
        request(method: .POST, urlString: "v1/mp/save", parameters: params) { (json, isSuccess) in
            let jon = json as? [String : AnyObject]
            //self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            
            complict(isSuccess,jon?["data"] as! [String : AnyObject] )
        }
    }
    //病例修改文章
    func mpUpdateArticle(_ params : [String : AnyObject] , complict : @escaping ( _ isSuccess : Bool ,_ code : Int )->() ) {
        
        request(method: .POST, urlString: "v1/mp/update", parameters: params) { (json, isSuccess) in
            let jon = json as? [String : AnyObject]
//            self.userCount.yy_modelSet(with:jon?["data"] as? [AnyHashable : Any] ??  [:])
            complict(isSuccess,jon?["code"] as? Int ?? -2)
        }
    }
    //病例删除文章
    func deleteArticle(_ id : String , complict : @escaping ( _ isSuccess : Bool ,_ code : Int )->() ) {

        let params = ["id":id,"userId": NetworkerManager.shared.userCount.id]
        request(method: .POST, urlString: "v1/mp/delete", parameters: params as [String : AnyObject]) { (json, isSuccess) in
            let jon = json as? [String : AnyObject]

            complict(isSuccess,jon?["code"] as? Int ?? -2)
        }
    }
    
    //获取 视频auth
    func getPlayAuth(_ id : String , complict : @escaping ( _ isSuccess : Bool ,_ code : String )->() ) {
        
        let params = ["vid":id]
        request(method: .GET, urlString: "v1/oes/getPlayAuth", parameters: params as [String : AnyObject]) { (json, isSuccess) in
            guard let jon = json as? [String : AnyObject],
                  let jsonss = jon["data"] as? [String : String],
                  let string = jsonss["authinfo"]
                  else{
                    return complict(false,"")
            }

            complict(isSuccess,string)
        }
    }

    
    func uploadFile(fileName:String =
        "",urlString : String , parameters : [String : AnyObject]?, completion : @escaping (_ json : AnyObject? ,  _ isSuccess : Bool)->() ) {
        
        SVProgressHUD.show()
        
        //成功的回调
        let success = { (task : URLSessionDataTask , json : Any?)->() in
            
            SVProgressHUD.dismiss()
            
            print(json ?? "")
            
            if let json = json as? [String:AnyObject] {
                
                if json["code"] as? String ?? ""  == "-1" || json["status"] as? String  ?? "" == "-1" || json["code"] as? Int ?? 0  == -1 || json["status"] as? Int  ?? 0 == -1{
                    SVProgressHUD.showInfo(withStatus: json["msg"] as? String ?? "")
                    completion(json as AnyObject, false)
                    return
                }
            }
            
            completion(json as AnyObject, true)
        }
        
        //失败的回调
        let failure = {(task : URLSessionDataTask? , error : Error)->() in
            
            SVProgressHUD.dismiss()
            
            let error = error as NSError
            print("网络请求错误 \(error)")
            
            print(error.userInfo["com.alamofire.serialization.response.error.string"] ?? "暂无错误信息")
            
            var string = error.userInfo["com.alamofire.serialization.response.error.string"]  as? String
            
            string = string?.substring(from: (string?.index((string?.startIndex)!, offsetBy: 25))!)
            
            string = string?.substring(to: (string?.index((string?.endIndex)!, offsetBy: -2))!)
            
            if error.code == -1009 {
                SVProgressHUD.showInfo(withStatus: "暂无网络连接" )
                completion(nil, false)
                return
            }
            
            let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
            
            if mainContoller?.selectedIndex == 0 && string == "用户名或密码错误"{
                
            }else{
                SVProgressHUD.showInfo(withStatus: string )
            }
            completion(["code" : "\(error.code)"] as AnyObject, false)
        }
        var urlString  =  Service_Domain + "/" + urlString + ".do"
        let  parameter = SignIng.singleton().constructSigningParam([:], requestType: "POST", andNetWorkStyle: urlString)
        urlString = urlString + "?timestamp=\(String(describing: parameter?["timestamp"] ?? ""))&sign=\(String(describing: parameter?["sign"] ?? ""))"
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            do {
                try formData.appendPart(withFileURL: URL.init(fileURLWithPath: fileName), name: "file")
            }
            catch {
                print(error)
            }
        }, progress: nil, success: success, failure: failure)
        
    }
}





