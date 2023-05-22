//
//  APIRouter.swift
//

import Foundation
import Alamofire
import DefaultsKit


enum APIRouter: URLRequestConvertible {
    
    case login(remember: Bool,email: String, password: String)
    case forgotPassword(email: String , locale : String)
    case openIDLogin(providerName: String)
    case usernameAvailable(userName: String)
    case createUser(username: String,email: String, password: String)
    case activateStukLicense(apiKey: String)
    case loginSTUK(apiKey: String)
    case associateLicenses
    case createProfile(sourceProfile: String)
    case setProfileSettings(settingsValue: NSArray)
    case ProfileSettings(getLang : String)
    case getPhoneticSpellings(getlanguage : String)
    case getAbbreviations(getLangCode : String)
    case getTtsReplacements(getLangCode : String)
    case getUserInfo
    case userlogout
    case synthesize(dataDict: [AnyHashable : Any])
    case uploadOCRImage
    case validateSessionId
    case TTS_StartJob(dataDict: [AnyHashable : Any])
    case TTS_GetJobStatus(dataDict: [AnyHashable : Any])
    case getTranslations(language: String, grammarLanguage: String)
    case setProfileSettingsTA(dataDict: [AnyHashable : Any])
    case getProfileSettingsTA(dataDict: [AnyHashable : Any])
    case onAnalyzeGrammar(dataDict: [AnyHashable : Any])
    case onParseSentenceTA(dataDict: [AnyHashable : Any])
    case sttGetToken(dataDict: [AnyHashable : Any])
    case lookup(dataDict: [AnyHashable : Any])

    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login,.openIDLogin,.usernameAvailable,.createUser,.activateStukLicense,.loginSTUK,.associateLicenses,.createProfile,.setProfileSettings,.ProfileSettings,.getPhoneticSpellings,.getAbbreviations,.getTtsReplacements,.getUserInfo,.userlogout,.synthesize,.forgotPassword,.getTranslations,.setProfileSettingsTA,.getProfileSettingsTA,.onAnalyzeGrammar,.onParseSentenceTA,.TTS_StartJob, .TTS_GetJobStatus,.sttGetToken,.lookup:
            return .get
        case .uploadOCRImage,.validateSessionId:
            return .post
        }
    }
        // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/user/login"
        case .openIDLogin:
            return "/user/getOpenIdLoginUrl"
        case .usernameAvailable:
            return "user/usernameAvailable"
        case .createUser:
            return "user/createUser"
        case .activateStukLicense:
            return "license/activateStukLicense"
        case .loginSTUK:
            return "user/stukLogin"
        case .associateLicenses:
            return "user/associateLicenses"
        case .createProfile:
            return "profile/copyProfile"
        case .setProfileSettings:
            return "profile/setProfileSettings"
        case .ProfileSettings:
            return "profile/getProfileSettings"
        case .getPhoneticSpellings:
            return "prediction/getPhoneticSpellings"
        case .getAbbreviations:
            return "prediction/getAbbreviations"
        case .getTtsReplacements:
            return "tts/getTtsReplacements"
        case .getUserInfo:
            return "user/getUserInfo"
        case .userlogout:
            return "user/logout"
        case .synthesize:
            return "tts/synthesize"
        case .forgotPassword:
            return "user/forgotPassword"
        case .uploadOCRImage:
            return "ocr/ocrImage"
        case .validateSessionId:
            return "user/validateSession"
        case .getTranslations:
            return "textAnalyzer/getTranslations"
        case .setProfileSettingsTA:
            return "profile/setProfileSettings"
        case .getProfileSettingsTA:
            return "profile/getProfileSettings"
        case .onAnalyzeGrammar:
            return "textAnalyzer/analyzeGrammar"
        case .onParseSentenceTA:
            return "textAnalyzer/parseSentences"
        case .TTS_StartJob:
            return "tts/startJob"
        case .TTS_GetJobStatus:
            return "tts/getJobStatus"
        case .sttGetToken:
            return "stt/getToken"
        case .lookup:
            return "dictionary/lookup"
        }
        
    }
       
        // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let remember, let userName, let password):
            let dictionary = [API.APIParameterKey.username: userName,
                              API.APIParameterKey.password: password,
                              API.APIParameterKey.remember : remember] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .openIDLogin(let providerName):
            let dictionary = [API.APIParameterKey.provider: providerName,
                              API.APIParameterKey.locale: "en-GB"
                              ] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString(),
                             API.APIParameterKey.application : ParameterValue.productName.rawValue]
            return paramDict as Parameters
            
        case .usernameAvailable(let userName):
            let dictionary = [API.APIParameterKey.username: userName] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
        
        case .createUser(let userName, let email, let password):
            let dictionary = [API.APIParameterKey.username: userName,
                              API.APIParameterKey.password: password,
                              API.APIParameterKey.email : email,
                              API.APIParameterKey.locale : "da-DK"] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .activateStukLicense(let apiKey):
            let dictionary = [API.APIParameterKey.licenseKey: apiKey,
                              API.APIParameterKey.applicationVersion : "7"] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .loginSTUK(apiKey: let apiKey):
            let dictionary = [API.APIParameterKey.apiKey: apiKey,
                              API.APIParameterKey.applicationVersion : "7"] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .associateLicenses:
            let dictionary = [API.APIParameterKey.application : ParameterValue.txtanalyser.rawValue] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
        
        case .createProfile(let getsourceProfile):
            let dictionary = [API.APIParameterKey.sourceProfile: getsourceProfile,
                              API.APIParameterKey.name : getsourceProfile,
                              API.APIParameterKey.product : ParameterValue.productName.rawValue,
                              API.APIParameterKey.version : "7"] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
        
        case .setProfileSettings(let settingsValue):
            let dictionary = [API.APIParameterKey.version: "3",
                              API.APIParameterKey.product : ParameterValue.productName.rawValue,
                              API.APIParameterKey.settings : settingsValue] as [String : Any]
            print("Dic:- \(dictionary)")
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .ProfileSettings(let getLang):
            let dictionary = [API.APIParameterKey.profile : getLang,
                              API.APIParameterKey.product : ParameterValue.productName.rawValue,
                              API.APIParameterKey.version : "3"] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .getPhoneticSpellings(let getlanguage) :
            let dictionary = [API.APIParameterKey.language : getlanguage] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .getAbbreviations(let getLangCode):
            let dictionary = [API.APIParameterKey.language : getLangCode] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .getTtsReplacements(let getLangCode):
            let dictionary = [API.APIParameterKey.language : getLangCode] as [String : Any] 
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .getUserInfo:
            return nil
            
        case .userlogout:
            return nil

        case .synthesize(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString()]
            return paramDict as Parameters
            
        case .forgotPassword(let email, let locale):
            let dictionary = [API.APIParameterKey.email : email,
                                    API.APIParameterKey.locale : locale,] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .uploadOCRImage:
            return nil
            
        case .validateSessionId:
            let dictionary = [API.APIParameterKey.userSessionId : getSessionID() ?? ""] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]
            return paramDict as Parameters
            
        case .getTranslations(let language, let grammarLanguage):
            let dictionary = [API.APIParameterKey.language : language,
                                    API.APIParameterKey.grammarLanguage : grammarLanguage,
                              API.APIParameterKey.version : "2"] as [String : Any]
            let paramDict = [API.APIParameterKey.parameters :dictionary.jsonString()]

            return paramDict as Parameters
            
        case .setProfileSettingsTA(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString(),"action":"setProfileSettings"]
            return paramDict as Parameters
            
        case .getProfileSettingsTA(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString(),"action":"getProfileSettings"]
            return paramDict as Parameters

        case .onAnalyzeGrammar(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString()]
            return paramDict as Parameters
            
        case .onParseSentenceTA(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString()]
            return paramDict as Parameters
            
        case .TTS_StartJob(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString()]
            return paramDict as Parameters
            
        case .TTS_GetJobStatus(let dataDict):

            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString()]
            return paramDict as Parameters
            
        case .sttGetToken(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString()]
            return paramDict as Parameters
            
        case .lookup(let dataDict):
            let paramDict = [API.APIParameterKey.parameters :dataDict.jsonString()]
            return paramDict as Parameters
            
        }

    }
        
        // MARK: URLRequestConvertible
        func asURLRequest() throws -> URLRequest {

            let url = try API.url.FinalBaseURL.asURL()

            let sessionID = getSessionID()
            //print("SessionID:::: \(String(describing: sessionID))")
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue(ContentType.json.rawValue,
                                forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
            urlRequest.setValue(ContentType.json.rawValue,
                                forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            urlRequest.setValue(sessionID,
                                 forHTTPHeaderField: HTTPHeaderField.User_sessionID.rawValue)
            urlRequest.setValue(ParameterValue.productName.rawValue,
                                forHTTPHeaderField: HTTPHeaderField.application.rawValue)
           // urlRequest.setValue("test", forHTTPHeaderField: "LingApps-Request-Log")
            urlRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: AppIdentifiers.GROUP_IDENTIFIER).cookies!)
            urlRequest.httpShouldHandleCookies = true
            
//            print("header fields : \(String(describing: urlRequest.allHTTPHeaderFields))")
            
            switch self {

            case .login,.forgotPassword,.openIDLogin,.usernameAvailable,.createUser,.activateStukLicense,.associateLicenses,.createProfile, .setProfileSettings,.ProfileSettings, .getPhoneticSpellings, .getAbbreviations, .getTtsReplacements, .getUserInfo, .userlogout, .synthesize,.validateSessionId, .getTranslations, .setProfileSettingsTA, .getProfileSettingsTA, .onAnalyzeGrammar, .onParseSentenceTA,.TTS_StartJob, .TTS_GetJobStatus,.sttGetToken,.lookup:
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
                break
            case
                .uploadOCRImage:
                    urlRequest.setValue("multipart/form-data",forHTTPHeaderField: "Content-Type")
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
                break
            default:
                if let parameters = parameters {
                    do {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    } catch {
                        throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                    }
                }
            }

            return urlRequest
        }
}

