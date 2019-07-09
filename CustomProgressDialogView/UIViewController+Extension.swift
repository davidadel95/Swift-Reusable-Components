//  Created by David Adel on 7/2/19.
//  Copyright © 2019 DavidAdel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showProgressDialoag(message:String){
        let vc = ProgressDialogView()
        vc.messageText = message
        vc.view.tag = 100
        self.add(vc)
    }
    
    func dismissPorgressDialog(){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
}
