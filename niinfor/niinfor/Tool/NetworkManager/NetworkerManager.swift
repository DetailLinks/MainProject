//
//  NetworkerManager.swift
//  FirstAid
//
//  Created by 王孝飞 on 2017/7/18.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD


//设置一个枚举代表Post和Get
enum HTTPMthod {
    case POST
    case GET
    case Construct
    case ConstructMore //一次上传多个图片
}

//网络管理工具
class NetworkerManager: AFHTTPSessionManager {

    //用户信息
     var  userCount  = WFUserAccount()
    
    //创建单利
    static let shared : NetworkerManager = {
        
        let instance = NetworkerManager()
        
        instance.responseSerializer = AFJSONResponseSerializer()//AFJSONResponseSerializer(readingOptions: .allowFragments) // //
        
        instance.responseSerializer.acceptableContentTypes?.insert("application/json")
        instance.responseSerializer.acceptableContentTypes?.insert("text/json")
        instance.responseSerializer.acceptableContentTypes?.insert("text/javascript")
        instance.responseSerializer.acceptableContentTypes?.insert("text/html")
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        instance.requestSerializer.timeoutInterval = 15
        //[manager startMonitoring];
//        instance.requestSerializer = AFHTTPRequestSerializer()
        
        instance.reachabilityManager.startMonitoring()
        
        return instance
    }()

    
    ///用一个函数封装网络请求
    func request(method : HTTPMthod = .GET ,images : [UIImage] = []  ,pictureName:String =
        "",fileName : [String] = [],urlString : String , parameters : [String : AnyObject]?, completion : @escaping (_ json : AnyObject? ,  _ isSuccess : Bool)->() ) {
        
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
            
            let nserror   = error as NSError
            
            
            print(error.userInfo["com.alamofire.serialization.response.error.string"] ?? "暂无错误信息")
            
//            let myString = String()
            
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
        
        //调用请求方法
        if method == .GET {
            
            let  parameter = SignIng.singleton().signingParam(parameters, requestType: "GET", andNetWorkStyle: urlString)

           get(urlString, parameters: parameter, progress: nil, success: success , failure: failure)
        }else if(method == .POST){
            
            var  parameter = SignIng.singleton().signingParam(parameters, requestType: "POST", andNetWorkStyle: urlString)

            urlString = urlString + "?timestamp=\(String(describing: parameter?["timestamp"] ?? ""))&sign=\(String(describing: parameter?["sign"] ?? ""))"
            
              parameter?.removeValue(forKey: "timestamp")
              parameter?.removeValue(forKey: "sign")
            
            post(urlString, parameters: parameter, progress: nil, success: success
                , failure: failure)
            
        }else if method == .ConstructMore{
        
            let  parameter = SignIng.singleton().constructSigningParam([:], requestType: "POST", andNetWorkStyle: urlString)
            
            urlString = urlString + "?timestamp=\(String(describing: parameter?["timestamp"] ?? ""))&sign=\(String(describing: parameter?["sign"] ?? ""))"
            if images.count <= 0 {
                SVProgressHUD.dismiss()
            }

            post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
                
                for  i   in 0 ..< images.count {
                
                let date = Date()
                
                let formatter = DateFormatter()
                
                formatter.dateFormat="YYYYMMddHHmmss"
                
                var dateString = formatter.string(from: date )
                
                var dataImage : NSData = NSData();
                if(UIImagePNGRepresentation(images[i]) != nil ){
                    dataImage = UIImagePNGRepresentation(images[i])! as NSData ;
                    dateString += ".png"
                }else if(UIImageJPEGRepresentation(images[i], 1.0) != nil){
                    
                    dataImage = UIImageJPEGRepresentation(images[i], 1.0)! as NSData
                    dateString += ".jpeg"
                }
                
                formData.appendPart(withFileData: dataImage as Data, name: fileName[i], fileName: dateString, mimeType: "image/png/jpeg")
                
                }
            }, progress: nil, success: success, failure: failure)
        
        }else{
            
            let  parameter = SignIng.singleton().constructSigningParam([:], requestType: "POST", andNetWorkStyle: urlString)
            
            urlString = urlString + "?timestamp=\(String(describing: parameter?["timestamp"] ?? ""))&sign=\(String(describing: parameter?["sign"] ?? ""))"
            
            if images.count <= 0 {
                SVProgressHUD.dismiss()
            }
            
            for image in images {
            
            post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
                
                let date = Date()
                
                let formatter = DateFormatter()
                
                formatter.dateFormat="YYYYMMddHHmmss"
                
                var dateString = formatter.string(from: date )
                
                var dataImage : NSData = NSData();
                if(UIImagePNGRepresentation(image) != nil ){
                    dataImage = UIImagePNGRepresentation(image)! as NSData ;
                    dateString += ".png"
                }else if(UIImageJPEGRepresentation(image, 1.0) != nil){
                    
                    dataImage = UIImageJPEGRepresentation(image, 1.0)! as NSData
                    dateString += ".jpeg"
                }
                
                formData.appendPart(withFileData: dataImage as Data, name: pictureName, fileName: dateString, mimeType: "image/png/jpeg")
                
            }, progress: nil, success: success, failure: failure)
            }
        }
        
    }



}












