//
//  BLEHandler.swift
//  matsya
//
//  Created by Naresh Kumar Devalapally on 10/10/22.
//

import Foundation
import UIKit
import CoreBluetooth

class BLEHandler: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Powered off")
        case .unsupported:
            print("Does not support BLE")
//            NymiSocketManager.shared.sendStatus(status: "Not a supported device")
        case .poweredOn:
            print("Powered On")
            isBLEON = true
        case .unauthorized:
            print("App is not authorized.")
        default:
            print("Unhandled state for CBCentral")
        }
        
    }
    
    
    static let shared = BLEHandler()
    
    var currentDeviceId: String = "89a9aae9"
    let bleCentral: CBCentralManager
    var webPageUrl : String = ""
    var isBLEON: Bool = false
    var currentPeripheral: CBPeripheral?
    
    private override init(){
        bleCentral = CBCentralManager()
        super.init()
        bleCentral.delegate = self
    }
    
    var color: UIColor = UIColor.green
    
    func startAuthentication(){
        print("Authentication started")
        
    }
    
    func handleQuery(queryItems: [URLQueryItem]?){
        // Get the sourceURL and the remaining parameters
        if let bandIdItem = queryItems?.first(where: { item in
            item.name == "bandId"
        }){
            if let bandId = bandIdItem.value {
                currentDeviceId = bandId
            }
        }
        
        if let userIdItem = queryItems?.first(where: { item in
            item.name == "userId"
        }) {
            print("user ID")
            print(userIdItem.value)
        }
        if let sourceUrlItem = queryItems?.first(where: { item in
            item.name == "sourceUrl"
        }) {
            if let sourceUrl = sourceUrlItem.value {
                webPageUrl = sourceUrl
            }
        }
        
        
        startScanning()
        
    }
    
    func startScanning() {
        if(isBLEON) {
            bleCentral.scanForPeripherals(withServices: [])
        }
//        NymiSocketManager.shared.sendStatus(status: "Scanning for \(currentDeviceId)")
        respondAuthentication(responseUrl: webPageUrl)
    }
    
    func stopScanning() {
        bleCentral.stopScan()
    }
    
    func respondAuthentication(responseUrl: String){
        if(responseUrl.isEmpty) {
            return
        }
        if let url = URL(string: responseUrl){
            UIApplication.shared.open(url)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("CBCentral discovered device")
       
//        if(currentDeviceId.isEmpty){
//            return
//        }
        let peripheralId = peripheral.identifier.uuidString
        let peripheralName = peripheral.name
        print(peripheralName )
        print(" -- ")
        print(peripheralId)
        print(peripheral)
        if(peripheralName == currentDeviceId){
            // Connect to it
//            NymiSocketManager.shared.sendStatus(status: "Discovered device")
            currentPeripheral = peripheral
            currentPeripheral?.delegate = self
            bleCentral.connect(currentPeripheral!)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("CBCentral connect to device \(currentDeviceId)")
//        NymiSocketManager.shared.sendStatus(status: "Connected to \(currentDeviceId)")
        currentPeripheral!.discoverServices(nil)
        
    }
    
    //MARK: Peripheral methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Peripheral did discover service")
        print(peripheral.services?.count)
        // Pick the first one
//        if let service = peripheral.services?.first {
//            peripheral.discoverCharacteristics(nil, for: service)
//
//
//        }
        // discover characteristics for all
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            
            print("Peripheral printing characteristics")
            for characteristic in characteristics {
                
                if(characteristic.properties.contains(CBCharacteristicProperties.read)) {
                    peripheral.readValue(for: characteristic)
                }
                
            }
        }
       
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
         print("Characteristic value")
        print(characteristic.value)
        print(characteristic.uuid.uuidString)
        respondAuthentication(responseUrl: webPageUrl)
    }
}
