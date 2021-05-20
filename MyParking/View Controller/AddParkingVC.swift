//
//  AddParkingVC.swift
//  MyParking
//
//  Created by Inzi Hussain on 2021-05-20.
//

import UIKit

class AddParkingVC: UIViewController {

    
    @IBOutlet weak var tfBuildingCode: UITextField!
    @IBOutlet weak var tfParkingLocation: UITextField!
    @IBOutlet weak var tfSuiteNum: UITextField!
    
    @IBOutlet weak var lblSelectedCar: UILabel!

    @IBOutlet weak var lblNumOfHours: UILabel!
    
    
    
    @IBOutlet var selectCarGesture: UITapGestureRecognizer!
    
    @IBOutlet var numOfHoursGesture: UITapGestureRecognizer!
            
    
    
    var parking : Parking?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSettings()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(addParking))
        // Do any additional setup after loading the view.
    }
    
    
    func initialSettings()
    {
        
        if let parking = parking
        {
            //Edit Page
        }
        else
        {
            //Add Page
        }
        
        
        tfParkingLocation.delegate = self
        tfBuildingCode.delegate = self
        tfSuiteNum.delegate = self
        
        selectCarGesture.addTarget(self, action: #selector(selectCarAreaTapped(gesture:)))
        numOfHoursGesture.addTarget(self, action: #selector(numOfHoursAreaTapped(gesture:)))

 
    }
    
    //MARK: Button and Gesture Actions
    
    @objc func addParking()
    {
        
    }
    
    
    @IBAction func useLocationButtonClicked(_ sender: UIButton) {
        
        
    }
    
    
    
    @objc func numOfHoursAreaTapped(gesture: UITapGestureRecognizer)
    {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "PickListViewController") as! PickListViewController
        
        
        
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
    @objc func selectCarAreaTapped(gesture: UITapGestureRecognizer)
    {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "PickListViewController") as! PickListViewController
        
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    
}


extension AddParkingVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension AddParkingVC : UIViewControllerTransitioningDelegate
{
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//            return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
//        }
}
