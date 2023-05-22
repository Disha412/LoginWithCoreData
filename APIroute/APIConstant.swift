//
//  APIConstant.swift
//

import Foundation

let KStatus = "status"
let KSuccess = "success"
let KData = "data"
let KEnabled = "enabled"
let KError = "error"
let KErrorMessage = "errorMessage"
let KerrorCode = "errorCode"
let KUser_SID_Invalid = "USER_SID_INVALID"
let kProgress = "progress"
let kMessage = "message"

struct API {
    
    struct url {
        //Base URL
        static let DevelopemntBaseURL = "http://services.lingapps.titan.wizkids.dk"
        static let LiveBaseURL = "https://services.lingapps.dk"
        static let insertDataURL = "https://stats.appwriterlog.wizkids.dk/stats/insert"
        
        static let FinalBaseURL = LiveBaseURL
        
        static let accountLogin = "https://www.wizkids.co.uk/support/appwriter/user-guides/ios/"
        static let Help_and_guidance =  "/misc/appwriter_ipadHelp?"
        static let Account_and_statistics = "//"
        static let spelling_help = "/profile/aw/spelling"
        static let Glossary = "/profile/aw/glossaries"
        static let Subjects_List = ""
        static let Sync_profile_settings = ""
        
        static let ProductionSTTSocketBaseURL = "wss://stt.lingapps.dk/stt/recognize?"                     //// Production URL
        static let DevelopmentSTTSocketBaseURL = "ws://titan.wizkids.dk:8087/stt/recognize?"      //// Development URL
        
        static let GoogleAnalyticsURL = "https://www.google-analytics.com/collect"
    }
    
    struct APIParameterKey {
        
        static let parameters = "parameters"
        
        static let remember = "remember"
        static let username = "username"
        static let password = "password"
        static let provider = "provider"
        static let locale = "locale"
        static let application = "application"
        static let email = "email"
        static let licenseKey = "licenseKey"
        static let apiKey = "apiKey"
        static let applicationVersion = "applicationVersion"
        static let sourceProfile = "sourceProfile"
        static let name = "name"
        static let product = "product"
        static let version = "version"
        static let profile = "profile"
        static let language = "language"
        static let languages = "languages"
        static let value = "value"
        static let prototype = "prototype"
        static let property = "property"
        static let action = "action"
        static let settings = "settings"
        //static let languages = "languages"
        static let exportFormat = "exportFormat"
        static let userSessionId = "userSessionId"
        static let grammarLanguage = "grammarLanguage"
    }
}

enum ResponseStatus: String{
    case success
    case error
}

let boundary = "NET-POST-boundary-\(arc4random())-\(arc4random())"

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case User_sessionID = "LingApps-User-Session-ID"
    case LingAppsApplicationVersion = "LingApps-Application-Version"
    case kLingAppsApplication = "LingApps-Application"
    case application = "application"
    //case multipart = "multipart/form-data;boundary=\(boundary)"
            //"multipart/form-data"
    case contentType_text = "text/html"
}

enum ContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}

enum ParameterValue: String {
    case productName = "appwriter_ipad"
    case txtanalyser = "txtanalyser_ipad"
}

enum ResponseKey : String {
    case error = "error"
    case expired = "expired"
    case progress = "progress"
    case customErrorTypes = "customErrorTypes"
    case defaultErrorTypes = "defaultErrorTypes"
    case dictionaries = "dictionaries"
    case highlightType = "highlightType"
    case prosodyRate = "prosodyRate"
    case readerVoice = "readerVoice"
    case readLatin = "readLatin"
    case readLetters = "readLetters"
    case readLetterSound = "readLetterSound"
    case readMath = "readMath"
    case readSentences = "readSentences"
    case readStopAfterSentence = "readStopAfterSentence"
    case readWords = "readWords"
    case wordPredictions = "wordPredictions"
    case wordPredictionsContextIndependent = "wordPredictionsContextIndependent"
    case wordPredictionsLanguage = "wordPredictionsLanguage"
}
