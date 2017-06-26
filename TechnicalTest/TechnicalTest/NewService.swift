//
//  NewService.swift
//  TechnicalTest
//
//  Created by CHEN KAIDI on 21/6/2017.
//  Copyright © 2017 Putao. All rights reserved.
//

import Foundation
import ObjectMapper

typealias GetGrowIndexHeadlineCompletionBlock = (_ result: AnyObject?, _ success: Bool, _ responseCode: Int) -> ()

extension PTBaseService {
    func getGrowIndexHeadline(completion aCompletion:@escaping GetGrowIndexHeadlineCompletionBlock){
        
        PTBaseService.request("", method: .get, parameters:nil) { (request, response, data, error) in
            guard let _ = data
                else{
                    aCompletion(nil, false, 0)
                    return
            }
            
            // nsdate -> String
            let dataString = String(data: data!, encoding: String.Encoding.utf8)
            
//            let responseData = Mapper<PTGrowIndexHeadlineResponseData>().map(JSONString: dataString!)
//            if let item = responseData?.data?.headlines{
//                aCompletion(item , true, PTConfig.StatusCode.success)
//            }else{
//                aCompletion(nil, false, PTConfig.StatusCode.failure)
//            }
            
            print(response ?? "response non")
            
        }
    }
}

