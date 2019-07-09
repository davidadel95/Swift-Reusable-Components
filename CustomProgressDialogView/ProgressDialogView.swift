//  ProgressDialogView.swift
//
//  Created by David Adel on 7/2/19.
//  Copyright © 2019 DavidAdel. All rights reserved.
//

import UIKit
import NicoProgress
import SwiftEventBus


class ProgressDialogView: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var nicoProgressBarr: NicoProgressBar!
    @IBOutlet var messageLbl: UILabel!
    
    //MARK: Variables
    var messageText = ""
    
    @IBOutlet var cancelBtn: UIButton!
    
    override func loadView() {
        Bundle.main.loadNibNamed("ProgressDialogView", owner: self, options: nil)
        self.view.frame = DisplayManager.getFullScreenRect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transition(to: .indeterminate)

        nicoProgressBarr.primaryColor = .orange
        nicoProgressBarr.secondaryColor = .black
        
        messageLbl.text = messageText
    }
    
    //MARK: Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        SwiftEventBus.post(Events.ON_CANCEL_BUTTON_PRESSED)
        self.dismisProgressViewController()
    }
    
    @objc func dismisProgressViewController(){
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    //MARK: State
    internal func transition(to state: NicoProgressBarState) {
        switch state {
        case .determinate(_):
            nicoProgressBarr.transition(to: state)
        case .indeterminate:
            nicoProgressBarr.transition(to: state)
        }
    }
}
