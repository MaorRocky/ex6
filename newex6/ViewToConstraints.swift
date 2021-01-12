//
// Created by Scores_Main_User on 1/12/21.
//

import UIKit

class ViewToConstraints
{
    var viewProp: UIView
    var index: Int
    var stringToConsts: [String: NSLayoutConstraint]


    init(v: UIView, index: Int, strToConsts: [String: NSLayoutConstraint])
    {
        self.viewProp = v
        self.index = index
        self.stringToConsts = strToConsts
    }


    func addConst(name: String, const: NSLayoutConstraint)
    {
        self.stringToConsts[name] = const
    }

    func removeConst(nameToRemove:String){

        self.stringToConsts.removeValue(forKey: nameToRemove)


    }

}