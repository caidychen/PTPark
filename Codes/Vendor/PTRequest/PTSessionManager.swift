//
//  PTSessionManager.swift
//  PTPark
//
//  Created by soso on 2017/6/9.
//
//

import Foundation
import Alamofire
import Realm
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper

//public enum PTCachePolicy {
//    
//    //忽略本地缓存
//    case ignoreCacheData
//    
//    //加载服务器数据，如果失败则返回缓存数据
//    case returnCacheDataThenLoadFailed
//    
//    //返回缓存数据(如果未过期)，然后加载服务器数据，成功后更新缓存
//    case returnCacheDataThenUpdate(TimeInterval)
//    
//    //返回缓存数据(如果未过期)，然后加载服务器数据，成功后更新缓存，返回数据
//    case returnCacheDataThenLoad(TimeInterval)
//    
//}
//
//open class PTSessionManager: SessionManager {
//    
//    var useFileSizeLimit: Int {
//        get {
//            return cacheManager.fileSizeLimit
//        }
//        set {
//            cacheManager.fileSizeLimit = newValue
//        }
//    }
//    
//    fileprivate let cacheManager = PTSessionCacheManager()
//    
//    @discardableResult
//    open func request<T:Mappable>(
//        _ url: URLConvertible,
//        method: HTTPMethod = .get,
//        parameters: Parameters? = nil,
//        encoding: ParameterEncoding = URLEncoding.default,
//        headers: HTTPHeaders? = nil,
//        cachePolicy: PTCachePolicy = PTCachePolicy.ignoreCacheData,
//        success: ((T.Type?) -> ())?,
//        failure: ((Error?) -> ())?)
//        -> URLSessionTask?
//    {
////        let key = (try! url.asURL()).description
////        
////        switch cachePolicy {
////        case .returnCacheDataThenUpdate(let timeInt):
////            
////            break
////        case .returnCacheDataThenLoad(let timeInt):
////            
////            break
////        default: break
////        }
//        
//        self.startRequestsImmediately = false
//        let request = super.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseObject { (data: DataResponse<T>) in
//            
//        }
//        request.task?.resume()
//        return request.task
//    }
//    
//}
//
//fileprivate class PTSessionCacheManager: NSObject {
//    
//    //使用文件缓存的阀值 byte，大小超过则使用文件缓存，否则使用数据库缓存
//    var fileSizeLimit: Int = 128
//    
//    fileprivate let _queue = DispatchQueue(label: "com.putao.park.http.cache.queue")
//    fileprivate let _path = NSHomeDirectory().stringByAppendingPathComponent("Documents/HTTPCache/")
//    fileprivate let _realmName = "cache.realm"
//    fileprivate var realm: Realm!
//    
//    override init() {
//        super.init()
//        let fileManager = FileManager.default
//        if !fileManager.fileExists(atPath: _path) {
//            try! fileManager.createDirectory(at: URL(fileURLWithPath: _path), withIntermediateDirectories: true, attributes: nil)
//        }
//        
//        var config = Realm.Configuration.defaultConfiguration
//        config.fileURL = URL(fileURLWithPath: _path + _realmName)
//        config.schemaVersion = 1
//        realm = try! Realm(configuration: config)
//    }
//    
//    fileprivate func size() -> Int {
//        var attri: [FileAttributeKey:Any]?
//        do {
//            attri = try FileManager.default.attributesOfFileSystem(forPath: _path)
//        } catch {
//            return 0
//        }
//        if let size = attri?[FileAttributeKey.size] as? Int {
//            return size
//        }
//        return 0
//    }
//    
//    fileprivate func clear() {
//        try! realm.write {
//            realm.deleteAll()
//        }
//        try! FileManager.default.removeItem(atPath: _path)
//    }
//    
//    fileprivate func readData(_ key: String) -> (data: Data?, date: Date?) {
//        let res = readFromDB(key)
//        guard let data = res.data, let date = res.date else {
//            return readFromFile(key)
//        }
//        return (data, date)
//    }
//    
//    fileprivate func storeData(_ data: Data?, for key: String) {
//        guard let `data` = data else {
//            storeInDB(nil, for: key)
//            storeInFile(nil, for: key)
//            return
//        }
//        if data.count < fileSizeLimit {
//            storeInDB(data, for: key)
//        } else {
//            storeInFile(data, for: key)
//        }
//    }
//    
//    private func readFromDB(_ key: String) -> (data: Data?, date: Date?) {
//        var item: PTCacheObject?
//        realm.beginWrite()
//        item = realm.object(ofType: PTCacheObject.self, forPrimaryKey: key)
//        try! realm.commitWrite()
//        return(item?.data, item?.date)
//    }
//    
//    private func storeInDB(_ data: Data?, for key: String) {
//        let obj = PTCacheObject()
//        obj.key = key
//        obj.data = data
//        obj.date = Date()
//        try! realm.write {
//            realm.add(obj, update: true)
//        }
//    }
//    
//    private func readFromFile(_ key: String) -> (data: Data?, date: Date?) {
//        let path = _path + key
//        var attr: [FileAttributeKey:Any]?
//        do {
//            attr = try FileManager.default.attributesOfItem(atPath: path)
//        } catch {
//            return (nil, nil)
//        }
//        guard let fileAttr = attr else {
//            return (nil, nil)
//        }
//        guard let date = fileAttr[FileAttributeKey.modificationDate] as? Date else {
//            return (nil, nil)
//        }
//        return(try! Data(contentsOf: URL(fileURLWithPath: path)), date)
//    }
//    
//    private func storeInFile(_ data: Data?, for key: String) {
//        let path = _path + key
//        guard let `data` = data else {
//            try! FileManager.default.removeItem(atPath: path)
//            return
//        }
//        try! data.write(to: URL(fileURLWithPath: path), options: .atomic)
//    }
//    
//}
//
//fileprivate class PTCacheObject: Object {
//    
//    dynamic var key: String = ""
//    dynamic var data: Data?
//    dynamic var date: Date?
//    
//    override class func primaryKey() -> String? {
//        return "key"
//    }
//}
