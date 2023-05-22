//
//  NetworkManager.swift
//

import UIKit
import Alamofire
import DefaultsKit

class NetworkManager {
    
    static let instance = NetworkManager()

    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    func startNetworkReachabilityObserver() {

        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {

                case .notReachable:
                    NotificationCenter.default.post(name: Notification.Name(NotificationName.noInternet), object: nil)
                    print("The network is not reachable")

                case .unknown :
                    print("It is unknown whether the network is reachable")

                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")

                case .reachable(.cellular):
                    print("The network is reachable over the WWAN connection")

                }
        })
    }

    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        let request = AF.request(route)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
                if response.response != nil {
                    getCookiesFromResponseHeader(response: response.response!)
                }
                
                if let data = response.data {
                    if let responseData = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.RawValue(Int(String.Encoding.utf8.rawValue)))) {
                        if let urlRequest = route.urlRequest, let bodyParams  = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8){
                            //print("Request : \(String(describing: urlRequest))\nParameters : \(bodyParams)\nResponse : \(responseData)")
                            //print("\nall header \(urlRequest.allHTTPHeaderFields as Any?)")
                        }
                    }
                }
                
                if (response.error != nil){
                    print("Errrrrrrrrrrrrorrrrrrrrrrrrrrrrr \(response.error?.localizedDescription ?? "no error description")")
                }else{

                }
                completion(response.result)
        }
        return request
    }
    
    private static func performRequestWithoutModel(route: APIRouter, completion:@escaping (NSDictionary)->Void) -> DataRequest{
        
        let request =  AF.request(route).responseData { (response) in
            if response.response != nil {
                getCookiesFromResponseHeader(response: response.response!)
            }
            var dictResponse = NSDictionary()
            if let data = response.data {
                if let responseData = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.RawValue(Int(String.Encoding.utf8.rawValue)))) {
                    if let urlRequest = route.urlRequest, let bodyParams  = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8){
                       //print("Request : \(String(describing: urlRequest))\nParameters : \(bodyParams)\nResponse : \(responseData)")
                        dictResponse = stringtoDictionary(jsonText: responseData) ?? NSDictionary()
                        //print("\ndictRes:- \(dictResponse)")
                    }
                }
            }
            
            if (response.error != nil){
                print("Errorrrr: \(response.error?.localizedDescription ?? "no error description")")
            }
            else{
            }
            completion(dictResponse)
        }
        return request
    }
   
    private static func uploadOCRImage(route: APIRouter,image: Data, params: [String: Any],completion:@escaping (NSDictionary)->Void) -> DataRequest{
        
        var dictResponse = NSMutableDictionary()
        let request =    AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                
                print("value: \(value) \nkey: \(key)")
                multiPart.append("\(value)".data(using: .utf8)!, withName: "\(key)")
                /*
                if let temp = value as? String { multiPart.append(temp.data(using: .utf8)!, withName: key}
                
                if let subArray = value as? NSArray {
                    do {if(key == "language"){
                            let data = try JSONSerialization.data(withJSONObject: subArray, options: [])
                            multiPart.append(data, withName: "language" ) }
                    } catch {print("error msg")}
                } */
            }
            multiPart.append(image, withName: "file", fileName: "file.png", mimeType: "image/png")
         
     }, with: route)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                dictResponse.setValue(Float(progress.fractionCompleted), forKey: kProgress)
                dictResponse.setValue(kProgress, forKey: KStatus)
                completion(dictResponse)
                
                print("Image upload progress: \(Float(progress.fractionCompleted))")
            })
//            .uploadProgress(closure: { progress in
//                print("Image upload progress: \(progress.fractionCompleted)")
//            })
            .responseJSON(completionHandler: { response in
                
                if response.response != nil {
                    getCookiesFromResponseHeader(response: response.response!)
                }
                dictResponse.removeAllObjects()
                if let data = response.data {
                    
                    if let responseData = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.RawValue(Int(String.Encoding.utf8.rawValue)))) {
                        if let urlRequest = route.urlRequest, let bodyParams  = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8){
//                            print("Request : \(String(describing: urlRequest))\nParameters : \(bodyParams)\nResponse : \(responseData)")

                            dictResponse = stringtoMutableDictionary(jsonText: responseData) ?? NSMutableDictionary()
                            
                            if dictResponse.count == 0 && responseData == "" {
                                dictResponse.setValue(responseData, forKey: KData)
                                dictResponse.setValue(KSuccess, forKey: KStatus)
                            }else{
                                if responseData == "" {
                                    dictResponse.setValue(responseData, forKey: KData)
                                    dictResponse.setValue(KError, forKey: KStatus)
                                }else{
                                    dictResponse.setValue(responseData, forKey: KData)
                                    dictResponse.setValue(KSuccess, forKey: KStatus)
                                }
                            }
                            
                        }
                    }else{
                        print("Errorrrr: \(response.error?.localizedDescription ?? "no error description")")
                    }
                    
                    if (response.error != nil){
                        print("Errorrrr: \(response.error?.localizedDescription ?? "no error description")")
                    }
                    completion(dictResponse)
                }
                else{ //response is nil
                    print("response.data is nil")
                    completion(dictResponse)
                }
            })
        
        return request
    }
    
    private static func uploadCreateOCRImage(route: APIRouter,image: Data, params: [String: Any],completion:@escaping (NSDictionary)->Void) -> DataRequest{
        
        var dictResponse = NSMutableDictionary()
        let request =    AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                
                print("value: \(value) \nkey: \(key)")
                multiPart.append("\(value)".data(using: .utf8)!, withName: "\(key)")
                /*
                if let temp = value as? String { multiPart.append(temp.data(using: .utf8)!, withName: key}
                
                if let subArray = value as? NSArray {
                    do {if(key == "language"){
                            let data = try JSONSerialization.data(withJSONObject: subArray, options: [])
                            multiPart.append(data, withName: "language" ) }
                    } catch {print("error msg")}
                } */
            }
            multiPart.append(image, withName: "file", fileName: "file.png", mimeType: "image/png")
         
     }, with: route)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                dictResponse.setValue(Float(progress.fractionCompleted), forKey: kProgress)
                dictResponse.setValue(kProgress, forKey: KStatus)
                completion(dictResponse)
                
                print("Image upload progress: \(Float(progress.fractionCompleted))")
            })
//            .uploadProgress(closure: { progress in
//                print("Image upload progress: \(progress.fractionCompleted)")
//            })
            .responseJSON(completionHandler: { response in
                
                if response.response != nil {
                    getCookiesFromResponseHeader(response: response.response!)
                }
                dictResponse.removeAllObjects()
                if let data = response.data {
                    
                    if data != nil {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                            print(json!)
                            completion(json!)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    else{
                        if (response.error != nil){
                            print("Errorrrr: \(response.error?.localizedDescription ?? "no error description")")
                        }
                        completion(dictResponse)
                    }
                    
                    
                }
                else{ //response is nil
                    print("response.data is nil")
                    completion(dictResponse)
                }
            })
        
        return request
    }
    
    static func cancelRequest() {
        let sessionManager = AF.session
        sessionManager.getAllTasks { tasks in
            print(tasks.count)
        }
        sessionManager.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            print(dataTasks.description)
            //dataTasks.forEach { $0.cancel() }
            print(uploadTasks.description)
            //uploadTasks.forEach { $0.cancel() }
            print(downloadTasks.description)
//            downloadTasks.forEach { $0.cancel() }
        }
        Alamofire.Session.default.cancelAllRequests()
    }
    
    //MARK: - Cookies storage Methods
    
    static func getCookiesFromResponseHeader(response: HTTPURLResponse) {
        setCookiesInSharedStorage(dictCookie: response.allHeaderFields as NSDictionary)
    }
    
    static func setCookiesInSharedStorage(dictCookie: NSDictionary) {
        var phpSessionID: String?
        var mID: String?
        if dictCookie["LingApps-PHP-Session-ID"] != nil && dictCookie["LingApps-Machine-ID"] != nil {
            phpSessionID = dictCookie["LingApps-PHP-Session-ID"] as? String
            mID = dictCookie["LingApps-Machine-ID"] as? String
        } else {
            if dictCookie["Set-Cookies"] != nil {
            }
            return
        }
        if dictCookie["Set-Cookies"] != nil {
            // NSLog(@"has set cookie key");
        }
        
        var cookiePropertiesS: [HTTPCookiePropertyKey : Any] = [:]
        cookiePropertiesS[HTTPCookiePropertyKey.name] = "PHPSESSID"
        cookiePropertiesS[HTTPCookiePropertyKey.value] = phpSessionID
        cookiePropertiesS[HTTPCookiePropertyKey.domain] = "lingapps.dk"
        cookiePropertiesS[HTTPCookiePropertyKey.path] = "/"
        cookiePropertiesS[HTTPCookiePropertyKey.expires] = Date().addingTimeInterval(2629743)
        
        let cookieSession = HTTPCookie(properties: cookiePropertiesS)

        var cookiePropertiesM: [HTTPCookiePropertyKey : Any] = [:]
        cookiePropertiesM[HTTPCookiePropertyKey.name] = "MID"
        cookiePropertiesM[HTTPCookiePropertyKey.value] = mID
        cookiePropertiesM[HTTPCookiePropertyKey.domain] = "lingapps.dk"
        cookiePropertiesM[HTTPCookiePropertyKey.path] = "/"
        
        cookiePropertiesM[.expires] = Date().addingTimeInterval(2629743)
        let cookieMID = HTTPCookie(properties: cookiePropertiesM)


        let httpCookies = [cookieSession, cookieMID]
        
        for cookie in httpCookies {
            HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: AppIdentifiers.GROUP_IDENTIFIER).setCookie(cookie!)
//            let cookieStorage = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: AppIdentifiers.GROUP_IDENTIFIER)
//            cookieStorage.setCookie(cookie!)
//            print(cookieStorage)
            
            //print("HTTPCookieStorage:- ",HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: AppIdentifiers.GROUP_IDENTIFIER).cookies as Any)
        }
        
    }
    
    static func deleteCookies() {
        if let cookies = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: AppIdentifiers.GROUP_IDENTIFIER).cookies{
            for cookie in cookies {
                HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: AppIdentifiers.GROUP_IDENTIFIER).deleteCookie(cookie)
            }
        }
    }
    
    //MARK: -
    static func loginUser(email: String,
                          password: String,
                          rememberMe: Bool,
                          completion:@escaping (Result<LoginResponse, AFError>)->Void) {
        _ = performRequest(route: APIRouter.login(remember: rememberMe, email: email, password: password),
                           completion: completion)
    }
    
    static func forgotPassword(email: String,
                                           locale : String,
                                           completion:@escaping (NSDictionary)->Void){
        _ = performRequestWithoutModel(route: APIRouter.forgotPassword(email: email, locale: locale),
                           completion: completion)        
    }
    
    static func usernameAvailable(userName: String,
                          completion:@escaping (Result<UsernameAvailable, AFError>)->Void) {
        _ = performRequest(route: APIRouter.usernameAvailable(userName: userName),
                           completion: completion)
    }
    
    static func getOpenID(providerName: String,
                          completion:@escaping (Result<OpenIDLoginRootClass, AFError>)->Void) {
        _ = performRequest(route: APIRouter.openIDLogin(providerName: providerName),
                           completion: completion)
    }
    
    static func createUser(email: String,
                          password: String,
                          completion:@escaping (Result<CreateUser, AFError>)->Void) {
        _ = performRequest(route: APIRouter.createUser(username: email, email: email, password: password),
                           completion: completion)
    }
    
    static func activateStukLicense(licenseKey: String,
                          completion:@escaping (Result<ActivateStukLicense, AFError>)->Void) {
        _ = performRequest(route: APIRouter.activateStukLicense(apiKey: licenseKey),
                           completion: completion)
    }
    
    static func loginSTUK(apiKey: String,completion:@escaping (Result<LoginResponse, AFError>)->Void) {
        _ = performRequest(route: APIRouter.activateStukLicense(apiKey: apiKey),
                           completion: completion)
    }
    
    static func checkAssociateLicenses(completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.associateLicenses,completion: completion)
    }
    
    static func createProfile(sourceProfile : String,
                              completion:@escaping (Result<UsernameAvailable, AFError>)->Void) {
        _ = performRequest(route: APIRouter.createProfile(sourceProfile: sourceProfile),
                               completion: completion)
    }
    
    static func getFullProfileSetting(getrequiredLang : String,
                                      completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.ProfileSettings(getLang: getrequiredLang), completion: completion)
    }
    
    static func getPhoneticSpellings(getlanguage : String,
                                     completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.getPhoneticSpellings(getlanguage: getlanguage), completion: completion)
    }
    
    static func getAbbreviations(getLangCode : String,
                                 completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.getAbbreviations(getLangCode: getLangCode), completion: completion)
    }
    
    static func getTtsReplacements(getLangCode : String,
                                   completion:@escaping (NSDictionary)->Void) {
          _ = performRequestWithoutModel(route: APIRouter.getTtsReplacements(getLangCode: getLangCode), completion: completion)
    }
    
    static func getUserInfo(completion:@escaping (Result<getUserProfile, AFError>)->Void) {
            _ = performRequest(route: APIRouter.getUserInfo,completion: completion)
    }
    
    static func userLogout(completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.userlogout, completion: completion)
    }
    
    static func setProfileSettingsAPI(getSettingsValue : NSArray, completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.setProfileSettings(settingsValue: getSettingsValue), completion: completion)
    }

    static func getOnlinePlay(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.synthesize(dataDict: dataDict), completion: completion)
    }
    
    static func uploadOCRImagetoServer(imageData :Data, completion:@escaping (NSDictionary)->Void) {
        let getLanguage = NSMutableArray.init()

        if getProfileSelectedLanguage() == LanguageNames.SwedishLangCode {
            getLanguage.add("sv-SE")
        } else {
            getLanguage.add(getProfileSelectedLanguage()!)
        }
        
        let dictionary = [API.APIParameterKey.languages : getLanguage,
                         API.APIParameterKey.exportFormat : "text"] as [String : Any]
        let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
        
        _ = uploadOCRImage(route: APIRouter.uploadOCRImage, image: imageData,params: paramDict, completion: completion)
   
    }
    
    static func uploadCreateOCRImagetoServer(imageData :Data, completion:@escaping (NSDictionary)->Void) {
        let getLanguage = NSMutableArray.init()

        if getProfileSelectedLanguage() == LanguageNames.SwedishLangCode {
            getLanguage.add("sv-SE")
        } else {
            getLanguage.add(getProfileSelectedLanguage()!)
        }
        
        let dictionary = [API.APIParameterKey.languages : getLanguage,
                         API.APIParameterKey.exportFormat : "json"] as [String : Any]
        let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
        
        _ = uploadCreateOCRImage(route: APIRouter.uploadOCRImage, image: imageData,params: paramDict, completion: completion)
   
    }
    
    static func sessionIDValide(completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.validateSessionId, completion: completion)
    }
    static func callStartJobAPI(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
           _ = performRequestWithoutModel(route: APIRouter.TTS_StartJob(dataDict: dataDict), completion: completion)
       }
       
       static func callGetJobStatusAPI(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
           _ = performRequestWithoutModel(route: APIRouter.TTS_GetJobStatus(dataDict: dataDict), completion: completion)
       }
    
    static func getTranslation(language : String, grammarLanguage : String, completion:@escaping (NSDictionary)->Void){
        _ = performRequestWithoutModel(route: APIRouter.getTranslations(language: language, grammarLanguage: grammarLanguage),
               completion: completion)
    }
    
    static func setProfileSettingsAPITA(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.setProfileSettingsTA(dataDict: dataDict), completion: completion)
    }
    
    static func getProfileSettingsAPITA(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.getProfileSettingsTA(dataDict: dataDict), completion: completion)
    }
    
    static func callOnAnalyseGrammar(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.onAnalyzeGrammar(dataDict: dataDict), completion: completion)
    }
    
    static func callOnParseSentence(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.onParseSentenceTA(dataDict: dataDict), completion: completion)
    }

    static func sttGetToken(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.sttGetToken(dataDict: dataDict), completion: completion)
    }
    
    static func lookup(dataDict : [AnyHashable : Any], completion:@escaping (NSDictionary)->Void) {
        _ = performRequestWithoutModel(route: APIRouter.lookup(dataDict: dataDict), completion: completion)
    }

    static func addGoogleAnalyticsData(eventCategory: String, eventAction: String,counter: Int) {

        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject

        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        
        
        let url = URL(string: API.url.GoogleAnalyticsURL)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        var parameters: [String: Any] = [
            "v": "1",
            "tid": "UA-79284543-23",
            "t":"event",
            "uid": AWUserDefaults.UserEmail!.sha256(),
            "an": "AppWriter iOS",
            "aid": "557545530", // appstore app id
            "av": version,
            "ec": eventCategory,
            "ea": eventAction
        ]
        if eventAction == GAActions.Get {
            parameters["ev"] = counter
        }
        print("parama GA \(parameters)")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }

        task.resume()
    }
}
