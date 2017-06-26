//
//  Error+PT.swift
//  PTPark
//
//  Created by soso on 2017/5/23.
//
//

import Foundation

public struct PTHTTPError {
    
    static func description(with errorCode: CFNetworkErrors) -> String? {
        switch (errorCode) {
        case .cfErrorHTTPAuthenticationTypeUnsupported:
            return "不支持的认证类型"
        case .cfErrorHTTPBadCredentials:
            return "错误的认证信息"
        case .cfErrorHTTPBadProxyCredentials:
            return "错误的代理认证，请检查你的代理设置。"
        case .cfurlErrorDNSLookupFailed:
            return "DNS错误，请检查你的DNS设置。"
        case .cfNetServiceErrorBadArgument:
            return "错误的参数"
        case .cfurlErrorTimedOut:
            return "请求超时，请重试。"
        case .cfNetServiceErrorTimeout:
            return "请求超时，请重试。"
        case .cfurlErrorUnsupportedURL:
            return "不支持的链接地址，请检查你的链接地址。"
        case .cfErrorHTTPBadURL:
            return "错误的链接地址"
        case .cfurlErrorBadURL:
            return "错误的链接地址"
        case .cfErrorHTTPProxyConnectionFailure:
            return "代理连接失败，请检查你的代理设置。"
        case .cfErrorHTTPSProxyConnectionFailure:
            return "代理连接失败，请检查你的代理设置。"
        case .cfErrorHTTPParseFailure:
            return "网络解析失败，错误的网络返回，请重试。"
        case .cfurlErrorBadServerResponse:
            return "网络解析失败，错误的网络返回，请重试。"
        case .cfurlErrorZeroByteResource:
            return "网络解析失败，错误的网络返回，请重试。"
        case .cfurlErrorCannotDecodeRawData:
            return "网络解析失败，错误的网络返回，请重试。"
        case .cfurlErrorCannotDecodeContentData:
            return "网络解析失败，错误的网络返回，请重试。"
        case .cfurlErrorCannotParseResponse:
            return "网络解析失败，错误的网络返回，请重试。"
        case .cfurlErrorDataNotAllowed:
            return "网络解析失败，错误的网络返回，请重试。"
        case .cfErrorHTTPConnectionLost:
            return "请检查网络是否可用，再行尝试。"
        case .cfurlErrorNetworkConnectionLost:
            return "请检查网络是否可用，再行尝试。"
        case .cfurlErrorCannotFindHost:
            return "请检查网络是否可用，再行尝试。"
        case .cfurlErrorCannotConnectToHost:
            return "请检查网络是否可用，再行尝试。"
        case .cfurlErrorResourceUnavailable:
            return "请检查网络是否可用，再行尝试。"
        case .cfurlErrorNotConnectedToInternet:
            return "请检查网络是否可用，再行尝试。"
        case .cfNetServiceErrorNotFound:
            return "请检查网络是否可用，再行尝试。"
        case .cfNetServiceErrorDNSServiceFailure:
            return "请检查网络是否可用，再行尝试。"
        default: return nil
        }
    }
    
}

public extension NSError {
    
    func PTDescription() -> String? {
        guard let code = CFNetworkErrors(rawValue: Int32(self.code)) else {
            return nil
        }
        return PTHTTPError.description(with: code)
    }
    
}

public extension Error {
    
    func PTDescription() -> String? {
        return (self as NSError).PTDescription()
    }
    
}
