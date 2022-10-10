//
//  NetworkManager.swift
//  agsChat
//
//  Created by MAcBook on 10/06/22.
//

import UIKit
import Network

class NetworkManager: NSObject {

    static let sharedInstance = NetworkManager()
    private override init() {}
    
    var contactListURL : String = "http://14.99.147.156:5000/user/public//user-list"
    //rewuest-body: {"id":"6271005aa0b24b24eb781674","secretKey":"U2FsdGVkX18AsTXTniJJwZ9KaiRWQki0Gike3TN+QyXws0hyLIdcRN4abTk84a7r"}
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
            } else {
                print("No connection.")
                // post disconnected notification
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    
    /*func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable {
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        return dataTask as! Cancellable
    }   //  */
    
    /*func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, err in
            if err == nil {
                completion(data, response, err)
            }
        }
        dataTask.resume()
        return dataTask
    }   //  */
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable {
        
//        if let cachedImage = image(url: URL(string: grupImage)) {
//            DispatchQueue.main.async {
//                completion(item, cachedImage)
//            }
//            return
//        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, err in
            if err == nil {
                completion(data, response, err)
            }
        }
        dataTask.resume()
        return dataTask
    }
    
//    func load(URL: NSURL) {
//            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//            let request = NSMutableURLRequest(URL: URL)
//            request.HTTPMethod = "GET"
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
//                if (error == nil) {
//                    // Success
//                    let statusCode = (response as NSHTTPURLResponse).statusCode
//                    println("Success: \(statusCode)")
//
//                    // This is your file-variable:
//                    // data
//                }
//                else {
//                    // Failure
//                    println("Failure: %@", error.localizedDescription);
//                }
//            })
//            task.resume()
//        }
    
    func download(url : URL, fileLocation : URL, obj : UserChatVC, completion : @escaping (_ result : String) -> Void) {
        
        let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
            //let saveFile = documentUrl.appendingPathComponent(fileLocation)
            //try FileManager.default.moveItem(at: fileUrl, to: savedFile)
            //data?.write(to: saveFile, options: .noFileProtection)
            do {
                try data?.write(to: fileLocation)
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "File Download", message: "File downloaded successfully.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    }
                    alertController.addAction(OKAction)
                    obj.present(alertController, animated: true, completion: nil)
                }
                completion("downloaded")
            } catch let error {
                print(error.localizedDescription)
            }
        }
        downloadTask.resume()
        /*let downloadTask = URLSession.shared.downloadTask(with: url) { url, response, err in
            guard let fileUrl = url else { return }
            do {
                let documentUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let savedFile = documentUrl.appendingPathComponent(fileName)
                try FileManager.default.moveItem(at: fileUrl, to: savedFile)
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "File Download", message: "File downloaded successfully.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                    }
                    alertController.addAction(OKAction)
                    obj.present(alertController, animated: true, completion: nil)
                }
                completion("downloaded")
            } catch {
                print ("file error: \(error)")
                completion("fail")
            }
        }
        downloadTask.resume()   //  */
    }
    
    /*func getContactList(userId : String, secretKey : String, completion : @escaping (_ response : ContactList) -> Void) {
        //rewuest-body: {"id":"6271005aa0b24b24eb781674","secretKey":"U2FsdGVkX18AsTXTniJJwZ9KaiRWQki0Gike3TN+QyXws0hyLIdcRN4abTk84a7r"}
        
        let params = ["id":userId, "secretKey":secretKey] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: contactListURL)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                let receiveList : ContactList = try JSONDecoder().decode(ContactList.self, from: data!)
                //print(receiveList)
                if (receiveList.success)! {
                    completion(receiveList)
                } else {
                    print("Error while get contact list.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })

        task.resume()
    }   //  */
}



