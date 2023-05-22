func callAPI() {
        
        NetworkManager.deleteCookies()
        showHud()
        NetworkManager.getOpenID(providerName: providerName) { [self] (result) in
            switch result {
            case .success(let response):
               hideHud()
                if let url = response.data, response.status == ResponseStatus.success.rawValue {
                    let webLoginVCObj = WebLoginVC.instantiate(fromAppStoryboard: .LoginScreens)
                    webLoginVCObj.providerName = providerName
                    webLoginVCObj.providerURL = url
                    webLoginVCObj.shouldResize = true
                    webLoginVCObj.popupHeight = kFrameWidth
                    webLoginVCObj.delegate = self
                    webLoginVCObj.popup(with: .fadeIn, dismissType: .fadeOut, position: .center, dismissOnBackgroundTouch: false)
                }
               
                break
            case .failure(let error):
                print(error)
                hideHud()
                break
            }
        }
    }


func callAPI1() {
        NetworkManager.checkAssociateLicenses(completion: { (result) in
            
            let success = result.object(forKey: KStatus) as? String
            let errorMsg = result.object(forKey: KErrorMessage) as? String
            
            if success == KSuccess {
                let resultData = result.object(forKey: KData) as! NSDictionary
                if resultData.count > 0{
                    var isExpired : Bool = AWUserDefaults.defaults.bool(forKey: UserDefaultKey.isActiveTA)
                    if let i = resultData.value(forKey: "expired") {
                        isExpired = i as! Bool
                    }
                    if isExpired {
                        AWUserDefaults.defaults.set(false, forKey: UserDefaultKey.isActiveTA)
                    }else{
                        AWUserDefaults.defaults.set(true, forKey: UserDefaultKey.isActiveTA)
                    }
                }else {
                    AWUserDefaults.defaults.set(false, forKey: UserDefaultKey.isActiveTA)
                }
                AWUserDefaults.defaults.synchronize()
            }
            else{
                print("\nErrorrrr checkAssociateLicenses: \(errorMsg)")
            }
        })
    }
