//
//  ViewController.swift
//  iBearded Robot
//
//  Created by Prashant Pandey on 10/2/15.
//  Copyright © 2015 Prashant Pandey. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class ViewController: UIViewController,FBSDKLoginButtonDelegate ,GPPSignInDelegate{
    var props:Dictionary<String,String>=["Purchase":"Loki Sceptre","Vendor":"The wizard of OZ"]
    var signIn : GPPSignIn?

    override func viewDidLoad() {
        super.viewDidLoad()
        let myFirstLabel = UILabel()
        let addToCart = UIButton()
        let purchase = UIButton()
        let rate = UIButton()
        let setDnd = UIButton()
        let unsetDnd = UIButton()
        let gid = UIButton()

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }


        myFirstLabel.text = "Product:Loki Sceptre\nPrice:2265\nVendor:The Wizard of Oz"
        myFirstLabel.font = UIFont(name: "MarkerFelt-Thin", size: 15)
        myFirstLabel.textColor = UIColor.redColor()
        myFirstLabel.textAlignment = NSTextAlignment.Left
        myFirstLabel.numberOfLines = 0
        myFirstLabel .sizeToFit()
        myFirstLabel.frame = CGRectMake(0, 0, 280, 150)
        
        addToCart.setTitle("Add This Item To Cart", forState: .Normal)
        addToCart.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addToCart.frame = CGRectMake(0, 100, 350, 20)
        addToCart.addTarget(self, action: "addedToCart:", forControlEvents: .TouchUpInside)
        addToCart.backgroundColor = UIColor.grayColor()
        addToCart.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Center

        purchase.setTitle("Purchase this Product for 2265", forState: .Normal)
        purchase.setTitleColor(UIColor.blueColor(), forState: .Normal)
        purchase.frame = CGRectMake(0, 160, 350, 20)
        purchase.addTarget(self, action: "purchase:", forControlEvents: .TouchUpInside)
        purchase.backgroundColor = UIColor.grayColor()
        purchase.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Center
        
        rate.setTitle("Rate this Item 7 Star", forState: .Normal)
        rate.setTitleColor(UIColor.blueColor(), forState: .Normal)
        rate.frame = CGRectMake(0, 130, 350, 20)
        rate.addTarget(self, action: "rate:", forControlEvents: .TouchUpInside)
        rate.backgroundColor = UIColor.grayColor()
        rate.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Center
        

        setDnd.setTitle("Set DND", forState: .Normal)
        setDnd.setTitleColor(UIColor.blueColor(), forState: .Normal)
        setDnd.frame = CGRectMake(0, 190, 350, 20)
        setDnd.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        setDnd.backgroundColor = UIColor.grayColor()
        setDnd.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Center
        
        unsetDnd.setTitle("Unset DND", forState: .Normal)
        unsetDnd.setTitleColor(UIColor.blueColor(), forState: .Normal)
        unsetDnd.frame = CGRectMake(0, 220, 350, 20)
        unsetDnd.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        unsetDnd.backgroundColor = UIColor.grayColor()
        unsetDnd.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Center
        
        gid.setTitle("GoogleLogin", forState: .Normal)
        gid.setTitleColor(UIColor.blueColor(), forState: .Normal)
        gid.frame = CGRectMake(0, 320, 350, 20)
        gid.addTarget(self, action: "gLogin:", forControlEvents: .TouchUpInside)
        gid.backgroundColor = UIColor.grayColor()
        gid.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Center

        CleverTap.init()
        self.view.addSubview(myFirstLabel)
        self.view.addSubview(addToCart)
        self.view.addSubview(purchase)
        self.view.addSubview(rate)
        self.view.addSubview(setDnd)
        self.view.addSubview(unsetDnd)
        self.view.addSubview(gid)


        // Do any additional setup after loading the view, typically from a nib.
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        NSLog("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                    NSLog("GRAPHSS", String(returnUserData()))
            }
        }
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                NSLog("Error: \(error)")
            }
            else
            {
                NSLog("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                NSLog("User Name is: \(userName)")
                //let userEmail : NSString = result.valueForKey("email") as! NSString
                //NSLog("User Email is: \(userEmail)")
            }
        })
    }
    
    
    
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if auth.accessToken != nil {
            NSLog("GID ",auth.accessToken)
        }
    }
    func didDisconnectWithError(error: NSError!) {
        signIn!.signOut()
    }


    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        NSLog("User Logged Out")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addedToCart(sender:UIButton!){
        let cart:Dictionary<String,String>=["Product":"Loki Sceptre","Vendor":"The wizard of Oz"]
        CleverTap.push().eventName("Added To Cart",eventProps: cart)
        let alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = "Added To Cart";
        alertView.message = "Loki Sceptre..Next thing recommended is IronMan Suit";
        alertView.show();
    }
 
    
    
    func gLogin(sender:UIButton!){
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.clientID = "421662389188-dk2t2u69to8nktghe7dk6g4v28bs7fsk.apps.googleusercontent.com"
        signIn?.scopes = [kGTLAuthScopePlusLogin]
        signIn?.shouldFetchGoogleUserEmail = true;
        signIn?.shouldFetchGoogleUserID = true;
        signIn?.delegate = self
        signIn?.authenticate()
    }
    
    
    func rate(sender:UIButton!){
        let rprops:Dictionary<String,String>=props
        props["Rating"]=String(Int(arc4random_uniform(10)))
        CleverTap.push().eventName("Product Rated", eventProps: rprops)
        let alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = "Thanks";
        alertView.message = "Thanks for rating Lokis Sceptre";
        alertView.show();
    }
    
    
    func purchase(sender:UIButton!){
        let chargeDetails:Dictionary<String,String>=["Payment mode":"Debit Card","Amount":"2265","Transaction ID":String(Int(arc4random_uniform(1000000)))]
        let items:[Dictionary<String,String>]=[props]
        CleverTap.push().chargedEventWithDetails(chargeDetails, andItems: items)
        let alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = "Purchased";
        alertView.message = "Purchased Loki Sceptre..";
        alertView.show();
    }
    
    func pressed(sender: UIButton!) {
        let alertView = UIAlertView();
        alertView.addButtonWithTitle("Ok");
        alertView.title = "title";
        alertView.message = "message";
        alertView.show();
        //let profile:Dictionary<String,String>=["Name":"Prashant","Email":"prashant@cleverTap.com"]
        //CleverTap.push().profile(profile)
        //CleverTap.push().eventName("ButtonPush")
   }
}

