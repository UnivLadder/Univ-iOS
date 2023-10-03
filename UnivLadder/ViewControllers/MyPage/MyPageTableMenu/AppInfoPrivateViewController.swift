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
    var status = 0
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = "개인정보처리방침"
            if status == 1{
                titleLabel.text = "오픈소스 라이선스"
            }
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
        var paths = Bundle.main.path(forResource: "realtutorInfo.txt", ofType: nil)
        if self.status == 1{
            paths = Bundle.main.path(forResource: "podlist.txt", ofType: nil)
        }

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
