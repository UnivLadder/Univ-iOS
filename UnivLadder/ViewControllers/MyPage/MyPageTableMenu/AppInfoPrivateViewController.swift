//
//  AppInfoPrivateViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/08/06.
//

import UIKit

class AppInfoPrivateViewController: UIViewController {
    
    var result = ""
    var titleText = ""
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = "개인정보처리방침"
            titleLabel.font = Fonts.EsamanruOTF.bold.font(size: Constant.menuFontSizeXS)
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!{
        didSet{
            textLabel.lineBreakMode = .byWordWrapping
            textLabel.numberOfLines = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readTxtFile()
    }
    func readTxtFile() {
        let paths = Bundle.main.path(forResource: "realtutorInfo.txt", ofType: nil)
        guard paths != nil else { return }

        do {
            result = try String(contentsOfFile: paths!, encoding: .utf8)
        }
        catch let error as NSError {
            print("catch :: ", error.localizedDescription)
            return
        }
        textLabel.text = result
    }
}
