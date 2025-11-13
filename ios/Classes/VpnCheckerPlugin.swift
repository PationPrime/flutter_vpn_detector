import Flutter
import UIKit
import SystemConfiguration
import CoreFoundation

public class VpnCheckerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vpn_checker", binaryMessenger: registrar.messenger())
        let instance = VpnCheckerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isVpnActive":
            let isActive = isUsingProxyOrVPN()
            result(isActive)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // VPN interface prefixes
    private let vpnInterfacePrefixes = ["ppp", "ipsec", "utun", "tun", "tap", "wg"]
    
    // Constants for proxy settings keys
    private let kHTTPEnable = kCFNetworkProxiesHTTPEnable as String
    private let kHTTPProxy = kCFNetworkProxiesHTTPProxy as String
    private let kHTTPPort = kCFNetworkProxiesHTTPPort as String
    private let kHTTPSEnable = "HTTPSEnable"
    private let kHTTPSProxy = "HTTPSProxy"
    private let kHTTPSPort = "HTTPSPort"
    
    /// Check if the device is using proxy or VPN
    private func isUsingProxyOrVPN() -> Bool {
        // Method 1: Check network interfaces directly (most reliable)
        if isUsingVpnInterface() {
            return true
        }
        
        // Method 2: Check proxy settings for specific URL
        if let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue(),
           let url = URL(string: "https://www.apple.com"),
           let proxies = CFNetworkCopyProxiesForURL(url as CFURL, proxySettings).takeRetainedValue() as? [[AnyHashable: Any]],
           let settings = proxies.first {
            if let type = settings[kCFProxyTypeKey as String] as? String,
               type != kCFProxyTypeNone as String {
                return true
            }
        }
        
        // Method 3: Check proxy configuration dictionary
        let cfDict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as NSDictionary?
        
        // Check if HTTP/HTTPS/SOCKS proxy is enabled
        if let dicts = cfDict as? [String: Any] {
            // Check HTTP proxy
            if let httpEnable = dicts[kHTTPEnable] as? NSNumber, httpEnable.boolValue {
                return true
            }
            // Check HTTPS proxy
            if let httpsEnable = dicts[kHTTPSEnable] as? NSNumber, httpsEnable.boolValue {
                return true
            }
            // Check SOCKS proxy (important for many VPNs)
            if let socksEnable = dicts[kCFNetworkProxiesSOCKSEnable as String] as? NSNumber, socksEnable.boolValue {
                return true
            }
            
            // Fallback: check as Int (for compatibility)
            if let httpEnable = dicts[kHTTPEnable] as? Int, httpEnable == 1 {
                return true
            }
            if let httpsEnable = dicts[kHTTPSEnable] as? Int, httpsEnable == 1 {
                return true
            }
        }
        
        // Method 4: Check if proxy host and port keys exist
        let cfKeys = getAllSubKeys(from: cfDict as? [String: Any])
        let proxyKeys: [String] = [kHTTPProxy, kHTTPPort, kHTTPSProxy, kHTTPSPort]
        if proxyKeys.contains(where: { cfKeys.contains($0) }) {
            return true
        }
        
        // Method 5: Check for VPN interfaces in scoped network settings
        if let keys = cfDict?["__SCOPED__"] as? NSDictionary {
            for key in keys.allKeys {
                if let keyStr = key as? String,
                   vpnInterfacePrefixes.contains(where: { keyStr.lowercased().contains($0) }) {
                    return true
                }
            }
        }
        
        return false
    }
    
    /// Method 1: Check system network interfaces directly
    /// This is the most reliable method to detect VPN connections
    private func isUsingVpnInterface() -> Bool {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return false
        }
        defer { freeifaddrs(ifaddr) }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let name = String(cString: ptr.pointee.ifa_name)
            // Check if interface name starts with known VPN prefixes
            if vpnInterfacePrefixes.contains(where: { name.hasPrefix($0) }) {
                return true
            }
        }
        
        return false
    }
    
    /// Get all sub-keys from a nested dictionary
    private func getAllSubKeys(from dict: [String: Any]?) -> [String] {
        guard let dict = dict else { return [] }
        var allKeys: [String] = []
        
        for (key, value) in dict {
            allKeys.append(key)
            if let subDict = value as? [String: Any] {
                allKeys.append(contentsOf: getAllSubKeys(from: subDict))
            }
        }
        
        return allKeys
    }
}
