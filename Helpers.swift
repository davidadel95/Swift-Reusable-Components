//
//  Helpers.swift
//  VideoWaterMarkTest
//
//  Created by admin on 11/9/18.
//  Copyright © 2018 MGPluses. All rights reserved.
//

//
//  Extensions.swift
//  ImageChef
//
//  Created by admin on 10/14/18.
//  Copyright © 2018 MGPluses. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import VIMediaCache

extension UIViewController{
    func showProgressDialoag(message:String){
        let vc = ProgressDialogView()
        vc.messageText = message
        vc.view.tag = 100
        self.add(vc)
    }
    
    func dismissPorgressDialog(){
//        view.subviews.forEach({ $0.removeFromSuperview() })
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
}

extension UIView{
    @IBInspectable
    var CornerRaduis : CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
    
    func pulse(){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.8
        animation.duration = 0.15
        animation.autoreverses = true
        animation.initialVelocity = 0.5
        animation.damping = 1.0
        
        layer.add(animation, forKey: nil)
    }
    
    
    func showLoadingIndicator(){
        self.addBlurEffect()
        let indicator = UIActivityIndicatorView(frame: self.frame)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        indicator.color = .black
        indicator.transform = .init(scaleX: 2, y: 2)
        addSubview(indicator)
    }
    
    func hideLoadingIndicator(){
        self.removeBlurEffect()
        for subview in self.subviews{
            if let indicator = subview as? UIActivityIndicatorView{
                indicator.removeFromSuperview()
            }
        }
    }
    
    func addBlurEffect(){
        let BlurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        BlurEffectView.frame = self.bounds
        self.addSubview(BlurEffectView)
    }
    
    func removeBlurEffect(){
        for vf in self.subviews{
            if let tmp = vf as? UIVisualEffectView{
                tmp.removeFromSuperview()
            }
        }
    }
    
}

//@IBDesignable
class CUIView : UIView{
    
    var GColor1 : UIColor?
    var GColor2 : UIColor?
    
    @IBInspectable
    var BGColor : UIColor? = nil{
        didSet{
            self.backgroundColor = BGColor
        }
    }
    
    @IBInspectable
    var GradientColor1 : UIColor? = nil{
        didSet{
            GColor1 = GradientColor1
        }
    }
    
    @IBInspectable
    var GradientColor2 : UIColor? = nil{
        didSet{
            GColor2 = GradientColor2
        }
    }
    
    func applyGradient(color1: UIColor,color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
    }
    
    func addShadow(color: UIColor,opacity : Float){
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 5
        //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
    }
    
    @IBInspectable
    var shadowColor : UIColor? = nil{
        didSet{
            self.addShadow(color: shadowColor!, opacity: 1)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.shadowOffset = CGSize(width: 0, height: -2)
        
        if GColor1 != nil && GColor2 != nil{
            applyGradient(color1: GColor1!, color2: GColor2!)
        }
        
        addShadow(color: .black, opacity: 0.3)
    }
    
    func moveFromScreen(delay: TimeInterval){
        UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
            //self.transform = CGAffineTransform(translationX: -(self.superview?.frame.width)!, y: 0)
            self.alpha = 0
        }, completion: nil)
    }
    
    func moveToScreen(delay: TimeInterval){
        self.alpha = 0
//        self.transform = CGAffineTransform(translationX: (self.superview?.frame.width)!, y: 0)
        UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
            //self.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: nil)
    }
}

func showAlert(Message: String,viewcontroller: UIViewController){
    let message = UIAlertController(title: "Repost", message: Message, preferredStyle: .alert)
    let ok = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
    message.addAction(ok)
    viewcontroller.present(message, animated: true, completion: nil)
}

func showAlertWithActions(controller: UIViewController, title: String!, message: String!, positiveAction: UIAlertAction, negativeAction: UIAlertAction){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(positiveAction)
    alert.addAction(negativeAction)
    
    controller.present(alert, animated: true, completion: nil)
}

func getContext() -> NSManagedObjectContext{
    let appdel = UIApplication.shared.delegate as! AppDelegate
    return appdel.persistentContainer.viewContext
}

func savePostToLocal(post: InstagramPostModel){
    let context = getContext()
    let entity = NSEntityDescription.entity(forEntityName: "InstaPostEntity", in: context)
    let managedObject = NSManagedObject(entity: entity!, insertInto: context)
    
    managedObject.setValue(post.postID, forKey: "postid")
    managedObject.setValue(post.profileName, forKey: "profilename")
    
    if (post.postType == .Video){
        managedObject.setValue("video", forKey: "postType")
    }else{
        managedObject.setValue("photo", forKey: "postType")
    }
    
    managedObject.setValue(post.profilePicLink, forKey: "profilePicLink")
    managedObject.setValue(post.caption, forKey: "caption")
    managedObject.setValue(post.thumbnailLink, forKey: "thumbnailLink")
    managedObject.setValue(post.mediaLink, forKey: "mediaurl")
    managedObject.setValue(post.postlink, forKey: "postlink")
    managedObject.setValue(post.numberOfChildrens, forKey: "numberofchildrens")
    
    if (post.childrens != nil){
        managedObject.setValue(post.childrens, forKey: "childrensLinks")
    }
    
    
    do{
//        print("Post Saved To Local Database")
        try context.save()
    }catch{}
}

func getInstaPosts() -> [InstagramPostModel]{
    var tmp = [InstagramPostModel]()
    
    let moc = getContext()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InstaPostEntity")
    
    do {
        let result = try moc.fetch(request)
        var index = 0
        for managedObject in (result as! [NSManagedObject]).reversed() {
            
            let postlink = managedObject.value(forKey: "postlink") as! String?
            let postid = managedObject.value(forKey: "postid") as! String?
            let profilename = managedObject.value(forKey: "profilename") as! String?
            let profilePicUrl = managedObject.value(forKey: "profilePicLink") as! String?
            let postType = managedObject.value(forKey: "postType") as! String?
            let caption = managedObject.value(forKey: "caption") as! String?
            let thumbnailUrl = managedObject.value(forKey: "thumbnailLink") as! String?
            let mediaurl = managedObject.value(forKey: "mediaurl") as! String?
            let numberofchildrens = managedObject.value(forKey: "numberofchildrens") as! Int?
            
            let childrens = managedObject.value(forKey: "childrensLinks") as! [URL]?
            
            let videoPath = managedObject.value(forKey: "videoPath") as! String?
            
            let post = InstagramPostModel()
            post.postlink = postlink!
            post.postID = postid
            post.profileName = profilename
            post.profilePicLink = profilePicUrl
            post.caption = caption
            post.thumbnailLink = thumbnailUrl
            post.mediaLink = mediaurl!
            
            if (videoPath != nil){
                post.localVideoPath = videoPath
            }
            
            if (childrens != nil){
                post.childrens = childrens
            }
            
            if (postType == "video"){
                post.postType = .Video
            }else{
                post.postType = .Photo
            }
            
            post.numberOfChildrens = numberofchildrens!
            tmp.append(post)
            index += 1
        }
        
    } catch {
//        print("Failed")
    }
    
    return tmp
}

func getLocalPosts() -> [InstagramPostModel]{
    var tmp = [InstagramPostModel]()
    
    let moc = getContext()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InstaPostEntity")
    
    do {
        let result = try moc.fetch(request)
        var index = 0
        for managedObject in (result as! [NSManagedObject]).reversed() {
                        
            let postlink = managedObject.value(forKey: "postlink") as! String?
            let postid = managedObject.value(forKey: "postid") as! String?
            let profilename = managedObject.value(forKey: "profilename") as! String?
            let profilePicUrl = managedObject.value(forKey: "profilePicLink") as! String?
            let caption = managedObject.value(forKey: "caption") as! String?
            let thumbnailUrl = managedObject.value(forKey: "thumbnailLink") as! String?
            let mediaurl = managedObject.value(forKey: "mediaurl") as! String?
            let numberofchildrens = managedObject.value(forKey: "numberofchildrens") as! Int?
            
            let videoPath = managedObject.value(forKey: "videoPath") as! String?
            
            let childrens = managedObject.value(forKey: "childrensLinks") as! [URL]?
            
            let post = InstagramPostModel()
            post.postlink = postlink!
            post.postID = postid
            post.profileName = profilename
            post.profilePicLink = profilePicUrl
            post.caption = caption
            post.thumbnailLink = thumbnailUrl
            post.mediaLink = mediaurl!
            post.postType = mediaurl!.contains("mp4") ? .Video : .Photo
            post.numberOfChildrens = numberofchildrens!
            
            if (videoPath != nil){
                post.localVideoPath = videoPath
            }
            
            if (childrens != nil){
                post.childrens = childrens
            }
            
            tmp.append(post)
            index += 1
        }
        
    } catch {
//        print("Failed")
    }
    
    return tmp
}

func updatePost(postId:String, videoPath:String){
    
    //As we know that container is set up in the AppDelegates so we need to refer that container.
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    //We need to create a context from this container
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "InstaPostEntity")
    fetchRequest.predicate = NSPredicate(format: "postid = %@", postId)
    do{
        let test = try managedContext.fetch(fetchRequest)
        
        let objectUpdate = test[0] as! NSManagedObject
        objectUpdate.setValue(videoPath, forKey: "videoPath")
        do{
            try managedContext.save()
        }catch{
//            print(error)
        }
    }catch{
//        print(error)
    }
}

func getFavoritePosts() -> [String]{
    var tmp = [String]()
    
    let moc = getContext()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
    
    do {
        let result = try moc.fetch(request)
        var index = 0
        for managedObject in result as! [NSManagedObject] {
            
            let id = managedObject.value(forKey: "id") as! String?
            
            tmp.append(id!)
        }
        
    } catch {
//        print("Failed")
    }
    
    return tmp
}


func addPostToFavorite(id: String){
    let context = getContext()
    let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
    let managedObject = NSManagedObject(entity: entity!, insertInto: context)
    
    managedObject.setValue(id, forKey: "id")
    
    do{
//        print("Saved to Favorite")
        try context.save()
    }catch{}
}

func deleteFavorite(id: String){
    let moc = getContext()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
    
    do {
        let result = try moc.fetch(request)
        for managedObject in result as! [NSManagedObject] {
            
            let postid = managedObject.value(forKey: "id") as! String?
            
            if postid == id{
                moc.delete(managedObject)
                try moc.save()
                return
            }
        }
        
    } catch {
//        print("Failed")
    }
}

func getData(id: String) -> Data?{
    let moc = getContext()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DataEntity")
    
    do {
        let result = try moc.fetch(request)
        
        for managedObject in result as! [NSManagedObject] {
            
            if let tmp = managedObject.value(forKey: "id") as? String
            {
                if tmp == id
                {
                    if let data = managedObject.value(forKey: "data") as? Data
                    {
                        return data
                    }
                }
            }
            
        }
        
    } catch {
//        print("Failed")
    }
    return nil
}

func saveData(data: Data,id: String){
    let context = getContext()
    let entity = NSEntityDescription.entity(forEntityName: "DataEntity", in: context)
    let managedObject = NSManagedObject(entity: entity!, insertInto: context)
    
    managedObject.setValue(data, forKey: "data")
    managedObject.setValue(id, forKey: "id")
    
    do
    {
//        print("Data Saved To Local Database")
        try context.save()
    }catch{}
}

func deleteRecord(postid: String){
    
    let moc = getContext()
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InstaPostEntity")
    
    do {
        let result = try moc.fetch(request)
        for managedObject in result as! [NSManagedObject] {
            
            let id = managedObject.value(forKey: "postid") as! String?
            
            if postid == id
            {
                moc.delete(managedObject)
                try moc.save()
                return
            }
        }
        
    } catch {
//        print("Failed")
    }
}

func showNotification(Yposition: CGFloat,view: UIView,message: String){
    let rect = CGRect(x: 0, y: Yposition, width: view.frame.width, height: view.frame.width*0.1)
    let notificationView = CUIView(frame: rect)
    let color = UIColor(red: 0.81, green: 0.29, blue: 0.48, alpha: 1)//rgb(81%, 29%, 48%)
    notificationView.backgroundColor = color
    notificationView.transform = CGAffineTransform(scaleX: 1, y: 0)
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
    label.textAlignment = .center
    label.text = message
    label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    label.textColor = .white
    notificationView.addSubview(label)
    
    view.addSubview(notificationView)
    view.bringSubview(toFront: notificationView)
    
    UIView.animate(withDuration: 0.2, animations: {
        notificationView.transform = CGAffineTransform.identity
    }, completion: {
        _ in
        UIView.animate(withDuration: 0.2, delay: 3, options: .curveEaseInOut, animations: {
            notificationView.alpha = 0
        }, completion: {
            _ in
            notificationView.removeFromSuperview()
        })
    })
}

func showLongNotification(Yposition: CGFloat,view: UIView,message: String) -> UIView{
    let rect = CGRect(x: 0, y: Yposition, width: view.frame.width, height: view.frame.width*0.1)
    let notificationView = CUIView(frame: rect)
    let color = UIColor(red: 0.81, green: 0.29, blue: 0.48, alpha: 1)//rgb(81%, 29%, 48%)
    notificationView.backgroundColor = color
    notificationView.transform = CGAffineTransform(scaleX: 1, y: 0)
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
    label.textAlignment = .center
    label.text = message
    label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    label.textColor = .white
    notificationView.addSubview(label)
    
    view.addSubview(notificationView)
    view.bringSubview(toFront: notificationView)
    
    UIView.animate(withDuration: 0.2, animations: {
        notificationView.transform = CGAffineTransform.identity
    }, completion: nil)
    
    let animation = CABasicAnimation(keyPath: "position.x")
    let Xposition = label.frame.width/2
    animation.duration = 1
    animation.fromValue = Xposition-5
    animation.toValue = Xposition+5
    animation.repeatCount = .infinity
    animation.autoreverses = true
    label.layer.add(animation, forKey: nil)
    
    return notificationView
}


let Product_IDs = ["ih.repostproforinstagram.monthly",
                   "ih.repostproforinstagram.annual",
                   "ih.repostproforinstagram.lifetime"]

enum Subscription{
    case Silver
    case Gold
    case Expired
    case None
}

func checkSubscriptions(completion: @escaping (_ result: Subscription,_ date: Date?) -> ()){
    let SUBSCRIPTION_SECRET = "e8ab42c841dc4088b910ace87122d413"
    let receiptPath = Bundle.main.appStoreReceiptURL?.path
    if FileManager.default.fileExists(atPath: receiptPath!){
        var receiptData:NSData?
        do{
            receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
        }
        catch{
//            print("ERROR: " + error.localizedDescription)
        }
        //let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
        
        //print(base64encodedReceipt!)
        
        let requestDictionary = ["receipt-data":base64encodedReceipt!,"password":SUBSCRIPTION_SECRET]
        
        guard JSONSerialization.isValidJSONObject(requestDictionary) else {
//            print("requestDictionary is not valid JSON");
            return
        }
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            let validationURLString = "https://buy.itunes.apple.com/verifyReceipt"  // this works but as noted above it's best to use your own trusted server
            guard let validationURL = URL(string: validationURLString) else {
//                print("the validation url could not be created, unlikely error");
                return
            }
            let session = URLSession(configuration: URLSessionConfiguration.default)
            var request = URLRequest(url: validationURL)
            request.httpMethod = "POST"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            var expires_date : String = ""
            var product_id : String = ""
            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                if let data = data , error == nil {
                    do {
                        let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
                        //print("success. here is the json representation of the app receipt: \(appReceiptJSON)")
                        // if you are using your server this will be a json representation of whatever your server provided
                        let dic = appReceiptJSON as! NSDictionary
                        let receipt = dic.value(forKey: "receipt") as! NSDictionary
                        let infos = receipt.value(forKey: "in_app") as! NSArray
//                        print("INFOS > \(infos)")
                        var ValidSubscriptionFound = false
                        for purchase in infos
                        {
                            if let expires_date = (purchase as! NSDictionary).value(forKey: "expires_date") as? String
                            {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let regex = try NSRegularExpression(pattern: "([0-9]*)-([0-9]*)-([0-9]*) ([0-9]*):([0-9]*):([0-9]*)", options: .caseInsensitive)
                                let results = regex.matches(in: expires_date, options: [], range: NSMakeRange(0, expires_date.count)).map{
                                    String(expires_date[Range($0.range, in: expires_date)!])
                                }
                                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                                let date = formatter.date(from: results.first!)
                                
                                if Date().compare(date!) == .orderedAscending
                                {
                                    ValidSubscriptionFound = true
                                    
                                    let product_id = (purchase as! NSDictionary).value(forKey: "product_id") as? String
                                    
                                    if product_id == Product_IDs[0]
                                    {
//                                        print("completion(Subscription.Silver,\(date!)")
                                        completion(Subscription.Silver,date!)
                                        return
                                    }
                                    else if product_id == Product_IDs[1]
                                    {
//                                        print("completion(Subscription.Gold,\(date!)")
                                        completion(Subscription.Gold,date!)
                                        return
                                    }
                                }
                            }
                        }
                        if !ValidSubscriptionFound
                        {
                            completion(Subscription.None,nil)
                            return
                        }
                        let lastPurchase = infos.lastObject as! NSDictionary
//                        print("LastPurchase > \(lastPurchase)")
                        expires_date = (lastPurchase.value(forKey: "expires_date") as! String)
                        product_id = (lastPurchase.value(forKey: "product_id") as! String)
                        
                        DispatchQueue.main.sync {
                            do{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let regex = try NSRegularExpression(pattern: "([0-9]*)-([0-9]*)-([0-9]*) ([0-9]*):([0-9]*):([0-9]*)", options: .caseInsensitive)
                            let results = regex.matches(in: expires_date, options: [], range: NSMakeRange(0, expires_date.count)).map{
                                String(expires_date[Range($0.range, in: expires_date)!])
                            }
                                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                            let date = formatter.date(from: results.first!)
//                          let date = formatter.date(from: "2019-09-09 12:12:12")
//                                print("expiration >\(date) \n Current > \(Date())")
                                if date?.compare(Date()) == .orderedAscending
                                {
//                                    print("completion(Subscription.Expired, date!)")
                                    completion(Subscription.Expired, date!)
                                }
                                else
                                {
                                    if product_id == Product_IDs[0]
                                    {
//                                        print("completion(Subscription.Silver,date!)")
                                        completion(Subscription.Silver,date!)
                                    }
                                    else if product_id == Product_IDs[1]
                                    {
//                                        print("completion(Subscription.Gold,date!)")
                                        completion(Subscription.Gold,date!)
                                    }
                                }
                    }catch{}
                        }
                    
                    } catch let error as NSError {
//                        print("json serialization failed with error: \(error)")
                    }
                } else {
//                    print("the upload task returned an error: \(error)")
                }
            }
            task.resume()
        } catch let error as NSError {
//            print("json serialization failed with error: \(error)")
        }
    }
    else
    {
    completion(Subscription.None, nil)
    }
}

func lifeTimeVersionState() -> Bool{
    return getInt(Key: "Pro") == 1 ? true : false
}

func getInt(Key: String) -> Int?{
    let defaults = UserDefaults.standard
    return defaults.integer(forKey: Key)
}

func saveString(value: String,Key: String){
//    print("SET : \(value) FOR \(Key)")
    let defaults  = UserDefaults.standard
    defaults.set(value, forKey: Key)
    defaults.synchronize()
}

func getString(Key: String) -> String{
    let defaults = UserDefaults.standard
    return defaults.string(forKey: Key)!
}

func activateProVersion(){
    setInt(value: 1, Key: "Pro")
}

func setInt(value: Int,Key: String){
//    print("SET : \(value) FOR \(Key)")
    let defaults  = UserDefaults.standard
    defaults.set(value, forKey: Key)
    defaults.synchronize()
}

func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
    guard let rating = starRating?.doubleValue else {
        return nil
    }
    if rating >= 5 {
        return UIImage(named: "stars_5")
    } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
    } else if rating >= 4 {
        return UIImage(named: "stars_4")
    } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
    } else {
        return nil
    }
}


func getTemporaryDirectoryURL() -> URL{
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    let date = dateFormatter.string(from: Date())
    
    return URL(fileURLWithPath: documentDirectory).appendingPathComponent("\(date).mp4")
}

func getImageTemporaryDirectoryURL() -> URL{
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    let date = dateFormatter.string(from: Date())
    
    return URL(fileURLWithPath: documentDirectory).appendingPathComponent("\(date).jpg")
}


