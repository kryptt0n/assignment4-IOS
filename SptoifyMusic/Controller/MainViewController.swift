//
//  MainViewController.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 10.12.2024.
//

import UIKit

class MainViewController: UIViewController, TokenNetworkingDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared.tokenDelegate = self
        NetworkingManager.shared.getToken()
        // Do any additional setup after loading the view.
    }
    
    func networkingDidFinishWithToken(token: AccessToken) {
        CoreDataManager.shared.addToken(value: token.access_token, tokenType: token.token_type)
        print(token.access_token)
    }
    
    func networkingDidFail() {
        print("Error")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
