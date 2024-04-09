//
//  WifiModel.swift
//  Metal Detector
//
//  Created by iApp on 26/03/24.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreLocation

struct NetworkInfo {
    
    var interface: String
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}

class WifiViewModel: NSObject,CLLocationManagerDelegate{
    
    private var currentNetworkInfos = [NetworkInfo]()
    private var locationManager = CLLocationManager()
    
    var wifiTuple: (address: String, name: String) = ("", "")
    var incomingWifiData: (()->Void)?
    
    override init() {
        super.init()
        if #available(iOS 13.0, *) {
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedWhenInUse {
                updateWiFi()
            } else {
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            updateWiFi()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                updateWiFi()
            }
        }
    
    // MARK: UPDATE WIFI
    
    final func updateWiFi() {
        self.currentNetworkInfos = self.fetchNetworkInfo() ?? []
        if let ssid = currentNetworkInfos.first?.ssid {
            let address = self.getWiFiAddress()
            self.wifiTuple.address = address ?? ""
            self.wifiTuple.name = ssid
            self.incomingWifiData?()
        }
    }
    
    private func fetchNetworkInfo() -> [NetworkInfo]? {
        if let interfaces: NSArray = CNCopySupportedInterfaces() {
            var networkInfos = [NetworkInfo]()
            for interface in interfaces {
                let interfaceName = interface as! String
                var networkInfo = NetworkInfo(interface: interfaceName,
                                              success: false,
                                              ssid: nil,
                                              bssid: nil)
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    networkInfo.success = true
                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                }
                networkInfos.append(networkInfo)
            }
            return networkInfos
        }
        return nil
    }
    
    
    // MARK: WIFI ADDRESS

    func getWiFiAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        // Get list of all interfaces on the local machine:
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                if let interface = ptr?.pointee {
                    
                    // Check for IPv4 or IPv6 interface:
                    let addrFamily = interface.ifa_addr.pointee.sa_family
                    if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                        
                        // Convert interface name to a Swift String:
                        let name = String(cString: interface.ifa_name)
                        
                        // Check if the interface name matches "en0":
                        if name == "en0" {
                            
                            // Convert interface address to a human readable string:
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            if getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                           &hostname, socklen_t(hostname.count),
                                           nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                                address = String(cString: hostname)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
}
