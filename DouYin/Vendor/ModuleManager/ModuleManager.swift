//
//  ModuleManager.swift
//  ModuleManager
//
//  Created by huluobo on 2018/3/12.
//

import UIKit

public protocol Module: UIApplicationDelegate {}

public final class ModuleManager: NSObject  {
    
    public static let shared = ModuleManager()
    
    private override init() {
    
    }
    
    fileprivate var _modules: [Module] = []
    
    fileprivate var _objecMap: [String: Any] = [:]
    
    fileprivate var _instanceMap: [String: Any] = [:]
}

extension ModuleManager {
    /**
       Register the modules whit a plist file.
       - important: A plist file should like this:
       ```
        <key>Modules</key>
        <array>
          <string>ModuleA</string>
        </array>
       ```
       - parameter path: the path of modules`s name plist
     */
    public func registerModule(_ path: String) {
        guard let dict = NSDictionary(contentsOfFile: path) else { fatalError(" The plist file dose not exist") }
        guard let modules = dict["Modules"] as? [String] else {
            fatalError("The plist file should contain the 'Modules' key ")
        }
        
        register(modules)
        
    }
    
    /// Register the modules whit module`s name.
    /// - parameter modules: the modules name need to be registed
    public func register(_ moduleNames: String...) {
        register(moduleNames)
    }
    
    /// Register the modules whit module`s name.
    public func register(_ moduleNames: [String]) {
        let a = moduleNames.flatMap({ (module) -> Module.Type? in
            GetClassFromString(module) as? Module.Type
        })
        
        register(a)
    }
    
    /// Register the modules whit module`s type.
    public func register(_ modules: Module.Type...) {
        register(modules)
    }
    
    /// Register the modules whit module`s type.
    public func register(_ modules: [Module.Type]) {
        let a = modules.flatMap {
            ($0 as? NSObject.Type)?.init()
        }
        _modules = a as! [Module]
    }
    
    public func GetClassFromString(_ classString: String) -> AnyClass? {
        
        guard let bundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return nil
        }
            
        var anyClass: AnyClass? = NSClassFromString(bundleName + "." + classString)
        if (anyClass == nil) {
            anyClass = NSClassFromString(classString)
        }
        return anyClass
    }
}

extension ModuleManager {
    /// Register regular Type which conformed the protocol.
    /// The `anyType` can be `struct`, `enum` or `class`.
    public static func register<T, P>(_ anyType: T.Type, for protocol: P.Type) where T: ModuleObjectProtocol {
        ModuleManager.shared.register(anyType, for: `protocol`)
    }
    
    public static func register<P>(for protocol: P.Type, returned: @escaping (Any?) -> P) {
        return ModuleManager.shared.register(for: `protocol`, returned: returned)
    }
    
    /// Return registed object conformed the protocol.
    public static func object<T>(for protocol: T.Type) -> T {
        return ModuleManager.shared.object(for: `protocol`)
    }
    
    public static func object<T>(for protocol: T.Type, parameter: Any?) -> T {
        return ModuleManager.shared.object(for: `protocol`, parameter: parameter)
    }
        
    /// Register regular Type which conformed the protocol.
    /// The `anyType` can be `struct`, `enum` or `class`
    public func register<T, P>(_ anyType: T.Type, for protocol: P.Type) where T: ModuleObjectProtocol {
        let name = String(describing: `protocol`)
        _objecMap[name] = anyType
    }
    
    public func register<P>(for protocol: P.Type, returned: @escaping (Any?) -> P) {
        let name = String(describing: `protocol`)
        _instanceMap[name] = returned
    }
    
    public func object<T>(for protocol: T.Type, parameter: Any?) -> T {
        let name = String(describing: `protocol`)
        guard let instanceClosure = _instanceMap[name] else {
            fatalError("??? Please call 'register(for: returned:)' first to register '\(`protocol`)' ")
        }
        if let instanceClosure = instanceClosure as? (Any?) -> T {
            return instanceClosure(parameter)
        }
        fatalError("??? 'Your Type does not conform to expected type '\(`protocol`)'")
    }
    
    /// Return registed object conformed the protocol
    public func object<T>(for protocol: T.Type) -> T {
        let name = String(describing: `protocol`)
        if let instanceClosure = _instanceMap[name] {
            if let instanceClosure = instanceClosure as? (Any?) -> T {
                return instanceClosure(nil)
            }
            fatalError("??? Your Type does not conform to expected type '\(`protocol`)'")
        }
        
        guard let Class = _objecMap[name] else {
            fatalError("??? Please register '\(`protocol`)' first")
        }
        let moduleType = Class as! ModuleObjectProtocol.Type
        guard let obj = moduleType.instance() as? T else {
            fatalError("??? '\(moduleType)' does not conform to expected type '\(`protocol`)'")
        }
        
        return obj
    }

}

protocol SomeProtocol {
    func some()
}

extension ModuleManager: UIApplicationDelegate {
    @discardableResult
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        _modules.forEach {
            let _ = $0.application?(application, willFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
    
    @discardableResult
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        _modules.forEach {
            let _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        return true
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        _modules.forEach {
            $0.applicationDidBecomeActive?(application)
        }
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        _modules.forEach {
            $0.applicationWillResignActive?(application)
        }
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        _modules.forEach {
            $0.applicationDidEnterBackground?(application)
        }
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        _modules.forEach {
            $0.applicationWillEnterForeground?(application)
        }
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        _modules.forEach {
            $0.applicationWillTerminate?(application)
        }
    }
    
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        _modules.forEach {
            $0.applicationDidReceiveMemoryWarning?(application)
        }
    }
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        _modules.forEach {
            $0.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)
        }
    }
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        _modules.forEach {
            $0.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation)
        }
    }
    
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {// in screen coordinates
        _modules.forEach {
            $0.application?(application, willChangeStatusBarFrame: newStatusBarFrame)
        }
    }
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        _modules.forEach {
            $0.application?(application, didChangeStatusBarFrame: oldStatusBarFrame)
        }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        _modules.forEach {
            let _ = $0.application?(application, handleOpen: url)
        }
        return true
    }
    
    @available(iOS 9.0, *)
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {// no equiv. notification. return NO if the application can't open for some reason
        _modules.forEach {
            let _ = $0.application?(app, open: url, options: options)
        }
        return true
    }
    
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        _modules.forEach {
            $0.application?(application, didRegister: notificationSettings)
        }
    }
    
    @available(iOS 3.0, *)
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        _modules.forEach {
            $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    @available(iOS 3.0, *)
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        _modules.forEach {
            $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
    
    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        _modules.forEach {
            $0.application?(application, didReceiveRemoteNotification: userInfo)
        }
    }
    
    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        _modules.forEach {
            $0.application?(application, didReceive: notification)
        }
    }
    
    
    // Called when your app has been activated by the user selecting an action from a local notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Swift.Void) {
        _modules.forEach {
            $0.application?(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void) {
        _modules.forEach {
            $0.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }
    
    // Called when your app has been activated by the user selecting an action from a remote notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void) {
        
        _modules.forEach {
            $0.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void) {
        _modules.forEach {
            $0.application?(application, handleActionWithIdentifier: identifier, for: notification, withResponseInfo:responseInfo,  completionHandler: completionHandler)
        }
    }
    
    /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    
    @available(iOS 7.0, *)
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        _modules.forEach {
            $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    
    /// Applications with the "fetch" background mode may be given opportunities to fetch updated content in the background or when it is convenient for the system. This method will be called in these situations. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
    @available(iOS 7.0, *)
    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        _modules.forEach {
            $0.application?(application, performFetchWithCompletionHandler: completionHandler)
        }
    }
    
    
    // Called when the user activates your application by selecting a shortcut on the home screen,
    // except when -application:willFinishLaunchingWithOptions: or -application:didFinishLaunchingWithOptions returns NO.
    @available(iOS 9.0, *)
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void) {
        _modules.forEach {
            $0.application?(application, performActionFor:shortcutItem,  completionHandler:completionHandler)
        }
    }
    
    
}

extension Sequence {
    func flatMap<ElementOfResult>(
        _ transform: (Element) throws -> ElementOfResult?
        ) rethrows -> [ElementOfResult] {
        
        return try compactMap(transform)
    }
}
