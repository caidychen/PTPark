//
//  PTRealmManager.swift
//  RxRealm
//
//  Created by xiaopeng on 2017/4/18.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//
import RealmSwift
import Realm

class PTRLMManager {
    
    static let shared = PTRLMManager()
    
    public var realm : Realm!
    
    
    /// 在获得UID后调用，确保数据库对应每一个用户
    ///
    /// - Parameter name: UID or UserNme
    public func initWithName(name: String){
        
        var config = Realm.Configuration()
        
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent()
            .appendingPathComponent("\(name).realm")
        
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        config.schemaVersion = 1;
        
        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        config.migrationBlock = { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        }
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // generate the compact realm
        compactRealm()
    }
    
    public func add<T>(obj: T){
        
        guard let realmObj = obj as? Object  else {
            print("please provide the instance of Object")
            return
        }
        
        let key = type(of: realmObj).primaryKey()
        if let _ = key{
            try! realm.write {
                realm.add(realmObj, update: true)
            }
        }else{
            try! realm.write {
                realm.add(realmObj)
            }
        }
    }
    
    public func delete<T>(obj: T){
        
        guard let realmObj = obj as? Object  else {
            print("please provide the instance of Object")
            return
        }
        try! realm.write {
            realm.delete(realmObj)
        }
    }
    
    public func update<T>(obj: T, _ closure: @escaping (_ obj:T) -> Void){
        
        guard obj is Object  else {
            print("please provide the instance of Object")
            return
        }
        
        try! realm.write {
            closure(obj)
        }
    }
    
    public func query<T>(type:T.Type) -> Results<T>{
        return realm.objects(type)
    }
    
    
    /// purpose: fix the realm database increased size
    fileprivate func compactRealm() {
        let fileURL = Realm.Configuration.defaultConfiguration.fileURL!
        let tempURL = fileURL.deletingPathExtension()
        let compactPath = tempURL.absoluteString.appending("-compact.realm")
        let _compactURL = URL(string: compactPath)
        
        guard let compactURL = _compactURL  else {
            // compact isn't existed,
            return
        }
        
        autoreleasepool {
            realm = try! Realm()
            try! realm.writeCopy(toFile: compactURL)
            try! FileManager.default.removeItem(at: fileURL)
            try! FileManager.default.moveItem(at: compactURL, to: fileURL)
        }
    }
}
