//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //setup tab bar
        let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        let firstView = characterViewController()
        let secondView = locationViewController()
        
        tabBarViewController.addChild(firstView)
        tabBarViewController.addChild(secondView)
        firstView.tabBarItem.title = "Character"
        var image1 = UIImage(named: "character")
        image1 = image1?.scalePreservingAspectRatio(targetSize: CGSize(width: 25, height: 25))
        firstView.tabBarItem.image = image1
        secondView.tabBarItem.title = "Location"
        var image2 = UIImage(named: "location")
        image2 = image2?.scalePreservingAspectRatio(targetSize: CGSize(width: 25, height: 25))
        secondView.tabBarItem.image = image2

        window?.rootViewController = tabBarViewController
        
        window?.makeKeyAndVisible()
    }
    
    private func characterViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = UINavigationController()
        
        let cs = CharacterService(request: URLSessionRequest(), url: "/character")
        let cvm = CharacterViewModel(service: cs, maxRetrieve: 10)
        let mainView = storyboard.instantiateViewController(withIdentifier: "CharacterViewController") as! ViewController
    
        let bottomSheetVC = filterViewController(delegate: mainView)
        
        let characterDetailVC = detailViewController()
        
        mainView.setup(characterViewModel: cvm, filterViewController: bottomSheetVC, characterDetailViewController: characterDetailVC)
        nav.viewControllers = [mainView]
        return nav
    }
    
    private func filterViewController(delegate: FilterViewDelegate) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "FilterView") as! FilterViewViewController
        let cfvp = CharacterFilterViewModel()
        bottomSheetVC.setup(characterFilterViewModelProtocol: cfvp)
        bottomSheetVC.delegate = delegate
        return bottomSheetVC
    }
    
    private func detailViewController() -> CharacterDetailProtocol {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cdViewController = storyboard.instantiateViewController(withIdentifier: "CharacterDetails") as! CharacterDetailsViewController
        return cdViewController
    }
    
    private func locationViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let ls = LocationService(request: URLSessionRequest(), url: "/location")
        let lvm = LocationViewModel(service: ls, maxRetrieve: 10)
        let mainView = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        
        let locationDetailVC = locationDetailViewController()
        
        mainView.setup(locationViewModel: lvm, locationDetailVC: locationDetailVC)
        return mainView
    }
    
    private func locationDetailViewController() -> LocationDetailProtocol {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ldViewController = storyboard.instantiateViewController(withIdentifier: "LocationDetailViewController") as! LocationDetailViewController
        return ldViewController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

