//
//  ViewController.swift
//  newex6
//
//  Created by Scores_Main_User on 1/11/21.
//

import UIKit

class ViewController: UIViewController
{

    var viewsToConstraintsDict: [UIView: [NSLayoutConstraint]] = [:]
    var viewToPositionDict: [UIView: Int] = [:]


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.createInitialViews()
        self.addTapGestures()

    }


    func createDummyView() -> UIView
    {
        let dummyView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        self.view.addSubview(dummyView)
        dummyView.isUserInteractionEnabled = true
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        dummyView.backgroundColor = UIColor.systemTeal
        let conY: NSLayoutConstraint = dummyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let conWidth: NSLayoutConstraint = dummyView.widthAnchor.constraint(equalToConstant: 35)
        let conHeight: NSLayoutConstraint = dummyView.heightAnchor.constraint(equalToConstant: 35)
        NSLayoutConstraint.activate([conY, conWidth, conHeight])
        return dummyView
    }


    func createInitialViews()
    {


        let firstView = createDummyView()
        var conX = firstView.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -70)
        viewsToConstraintsDict[firstView] = [conX]
        viewToPositionDict[firstView] = 1
        NSLayoutConstraint.activate([conX])

        let secondView = createDummyView()
        conX = secondView.leadingAnchor.constraint(equalTo: firstView.trailingAnchor, constant: 1)
        viewsToConstraintsDict[secondView] = [conX]
        viewToPositionDict[secondView] = 2
        NSLayoutConstraint.activate([conX])

        let thirdView = createDummyView()
        conX = thirdView.leadingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: 1)
        viewsToConstraintsDict[thirdView] = [conX]
        viewToPositionDict[thirdView] = 3
        NSLayoutConstraint.activate([conX])

        let fourthView = createDummyView()
        conX = fourthView.leadingAnchor.constraint(equalTo: thirdView.trailingAnchor, constant: 1)
        viewsToConstraintsDict[fourthView] = [conX]
        viewToPositionDict[fourthView] = 4
        NSLayoutConstraint.activate([conX])


    }


    func addTapGestures()
    {
        for myView in viewsToConstraintsDict.keys
        {
            self.addTapGesturesToAView(with: myView)
        }
    }


    func addTapGesturesToAView(with myView: UIView)
    {
        let addGesture = UITapGestureRecognizer(target: self, action: #selector(self.addViewGesture(_:)))
        addGesture.numberOfTapsRequired = 2
        myView.addGestureRecognizer(addGesture)

        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(self.deleteViewGesture(_:)))
        deleteGesture.numberOfTapsRequired = 1
        myView.addGestureRecognizer(deleteGesture)

        deleteGesture.require(toFail: addGesture)
        deleteGesture.delaysTouchesBegan = true
        addGesture.delaysTouchesBegan = true
    }


    func deleteSubView(with myView: UIView, index: Int)
    {
        self.viewsToConstraintsDict.removeValue(forKey: myView)
        self.viewToPositionDict.removeValue(forKey: myView)
        self.decreasePositions(from: index)
        if let recognizers = myView.gestureRecognizers
        {
            for recognizer in recognizers
            {
                myView.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
        }
        myView.removeFromSuperview()


    }


    @objc func deleteViewGesture(_ sender: UITapGestureRecognizer)
    {

        if let view: UIView = sender.view
        {

            for iterView: UIView in viewsToConstraintsDict.keys
            {
                if view === iterView
                {
                    if let index: Int = viewToPositionDict[view]
                    {
                        print("you tapped box number \(index)")

                        self.deleteSubView(with: iterView, index: index)

                        if let nextView: UIView = getViewByIndex(index + 1)
                        {
                            self.moveBackwards(with: nextView)
                        }

                        let prevIndex: Int = index - 1 < 1 ? 1 : index - 1
                        print("prevIndex is \(prevIndex)")

                        if let prevView = getViewByIndex(prevIndex)
                        {
                            self.moveForwards(with: prevView)
                        }

                        self.adjustXAnchorForSubviews()

                    }
                    else
                    {
                        print("error")
                    }
                }
            }
        }
    }


    @objc func addViewGesture(_ sender: UITapGestureRecognizer)
    {
        if let view: UIView = sender.view
        {
            for iterView in viewsToConstraintsDict.keys
            {
                if view === iterView
                {
                    if let index: Int = viewToPositionDict[view]
                    {
                        print("you tapped box number \(index)")

                        if let firstView: UIView = getViewByIndex(1)
                        {
                            self.moveBackwards(with: firstView)
                        }

                        if let nextView: UIView = getViewByIndex(index + 1)
                        {
                            self.moveForwards(with: nextView)


                        }
                        let prevIndex: Int = index - 1 < 1 ? 1 : index - 1
                        print("prevIndex is \(prevIndex)")
                        if let prevView = getViewByIndex(prevIndex)
                        {
                            self.createNewSubView(at: index + 1, anchorWith: prevView)
                        }

                        self.adjustXAnchorForSubviews()
                    }
                    else
                    {
                        print("error")
                    }
                }
            }
        }

    }


    //this function using the extension at the bottom for the dictionary
    func getViewByIndex(_ index: Int) -> UIView?
    {
        if let nextView: UIView = viewToPositionDict.key(from: index)
        {
            return nextView
        }
        else
        {
            return nil
        }
    }


    // moves forward for the animation
    func moveForwards(with myView: UIView, by amount: Int = 40)
    {

        if let constraintsArray: [NSLayoutConstraint] = viewsToConstraintsDict[myView]
        {
            let const: NSLayoutConstraint = constraintsArray[0]
            const.constant += CGFloat(amount)
        }

        UIView.animate(withDuration: 1.2, delay: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

    }


    // moves backwards for the animation
    func moveBackwards(with myView: UIView, by amount: Int = 40)
    {
        if let constraintsArray: [NSLayoutConstraint] = viewsToConstraintsDict[myView]
        {
            let const: NSLayoutConstraint = constraintsArray[0]
            const.constant -= CGFloat(amount)
        }

        UIView.animate(withDuration: 1.2, delay: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }


    func createNewSubView(at position: Int, anchorWith prevView: UIView)
    {
        let newView: UIView = createDummyView()

        self.updatePoistionsIndexs(from: position)
        self.viewToPositionDict[newView] = position
        self.addTapGesturesToAView(with: newView)

        let conX: NSLayoutConstraint = newView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: 1)
        NSLayoutConstraint.activate([conX])
        self.viewsToConstraintsDict[newView] = [conX]

    }


    func updatePoistionsIndexs(from position: Int)
    {
        for (k, v) in viewToPositionDict
        {
            if v >= position
            {
                viewToPositionDict[k] = v + 1
            }
        }
    }


    func decreasePositions(from position: Int)
    {
        for (k, v) in viewToPositionDict
        {

            if v > position
            {
                viewToPositionDict[k] = v - 1
            }

        }
    }


    func adjustXAnchorForSubviews()
    {

        self.deactivateAndDeleteAllXConstraints()

        if let prevView: UIView = getViewByIndex(1)
        {
            let conX: NSLayoutConstraint = prevView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
            NSLayoutConstraint.activate([conX])
            viewsToConstraintsDict[prevView] = [conX]
        }

        for i in 2...viewsToConstraintsDict.count + 1
        {
            if let currView: UIView = getViewByIndex(i)
            {
                if let prevView: UIView = getViewByIndex(i - 1)
                {
                    let conX: NSLayoutConstraint = currView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: 1)
                    NSLayoutConstraint.activate([conX])
                    viewsToConstraintsDict[currView] = [conX]
                }
            }

        }


        UIView.animate(withDuration: 1.2, delay: 0.1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }


    func deactivateConstraints(with myView: UIView)
    {
        if let constraints: [NSLayoutConstraint] = viewsToConstraintsDict[myView]
        {
            for constraint in constraints
            {
                constraint.isActive = false

            }
        }
    }


    // as the name suggests
    func deactivateAndDeleteAllXConstraints()
    {
        for uv in viewsToConstraintsDict.keys
        {
            self.deactivateConstraints(with: uv)
            self.viewsToConstraintsDict[uv] = [NSLayoutConstraint]()
        }

    }

}


// this function help me to get by value.
extension Dictionary where Value: Equatable
{
    func key(from value: Value) -> Key?
    {
        return self.first(where: { $0.value == value })?.key
    }
}


