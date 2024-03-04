//
//  NetworkManager.swift
//
//
//  Created by Raghavendra Daramwar on 04/03/24.
//
import Foundation

public typealias Handler<T> = (Result<T,Error>)-> Void

public class NetworkManager {
    public static func fetch<T:Decodable>(urlString:String,memberType : T.Type,accessToken:String,page:Int,completion: @escaping Handler<T>) {
        
        let header = ["accept":"application/json",
                      "Authorization":"Bearer" + " " + (accessToken)]
        print("url",urlString + String(page))
        let urlStringLocal = urlString + String(page)
        guard let url = NSURL(string: urlStringLocal) else {
            print("Faulty URL or accessToken")
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL,cachePolicy:.useProtocolCachePolicy,timeoutInterval: 10.0 )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = header
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) {(data,response,error) -> Void in
            if error != nil{
                print(error as Any)
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0,userInfo: nil)))
                return
            }
            do{
                let fetchedData = try JSONDecoder().decode(memberType, from: data)
                completion(.success(fetchedData))
            }
            catch{
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    public static func sayHello(){
        print("Have a great day!!!!")
    }
}

