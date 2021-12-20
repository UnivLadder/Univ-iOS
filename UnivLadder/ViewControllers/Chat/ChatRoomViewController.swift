//
//  ChatRoomViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    static func instance() -> ChatRoomViewController {
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        return vc
    }
    let data: [String] = Array(repeating: "test", count: 10)

    var isExpanded: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                self.buttonStackView.isHidden = !self.isExpanded
            }
        }
    }
    
    @IBOutlet weak var chatBubbleTableView: UITableView! {
        didSet {
            chatBubbleTableView.rowHeight = UITableView.automaticDimension
        }
    }
    // input view
    @IBOutlet weak var inputBackgroundView: UIView! {
        didSet {
            inputBackgroundView.layer.cornerRadius = Constant.cornerRadius
            inputBackgroundView.backgroundColor = Theme.light500
            
        }
    }
    @IBOutlet weak var expandButton: UIButton! {
        didSet {
            expandButton.setTitle("", for: .normal)
            expandButton.setImage(UIImage(named: "plusbutton"), for: .normal)
            expandButton.addTarget(self, action: #selector(expandButtonClicked(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.backgroundColor = .clear
            textView.text = "메시지를 입력해주세요"
            textView.textColor = Theme.text1000
        }
    }
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setTitle("", for: .normal)
            sendButton.setImage(UIImage(named: "sendbutton"), for: .normal)
        }
    }
    // expanded view
    @IBOutlet weak var buttonStackView: UIView! {
        didSet {
            buttonStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var cameraView: UIView! {
        didSet {
            cameraView.layer.cornerRadius = cameraView.bounds.width / 2
            cameraView.backgroundColor = Theme.light500
        }
    }
    @IBOutlet weak var cameraButtonTitle: UILabel! {
        didSet {
            cameraButtonTitle.text = "카메라"
            cameraButtonTitle.textAlignment = .center
            cameraButtonTitle.textColor = Theme.text900
            cameraButtonTitle.font = Theme.esamanru11Light
        }
    }
    @IBOutlet weak var galleryView: UIView! {
        didSet {
            galleryView.layer.cornerRadius = galleryView.bounds.width / 2
            galleryView.backgroundColor = Theme.light500
        }
    }
    @IBOutlet weak var galleryButtonTitle: UILabel! {
        didSet {
            galleryButtonTitle.text = "앨범"
            galleryButtonTitle.textAlignment = .center
            galleryButtonTitle.textColor = Theme.text900
            galleryButtonTitle.font = Theme.esamanru11Light
        }
    }
    @IBOutlet weak var documentView: UIView! {
        didSet {
            documentView.layer.cornerRadius = documentView.bounds.width / 2
            documentView.backgroundColor = Theme.light500
        }
    }
    @IBOutlet weak var documentButtonTitle: UILabel! {
        didSet {
            documentButtonTitle.text = "파일"
            documentButtonTitle.textAlignment = .center
            documentButtonTitle.textColor = Theme.text900
            documentButtonTitle.font = Theme.esamanru11Light
        }
    }
    @IBOutlet weak var cameraButton: UIButton! {
        didSet {
            cameraButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var galleryButton: UIButton! {
        didSet {
            galleryButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var documentButton: UIButton! {
        didSet {
            documentButton.setTitle("", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatBubbleTableView.delegate = self
        chatBubbleTableView.dataSource = self
        
        chatBubbleTableView.separatorStyle = .none

    }
}

extension ChatRoomViewController {
    
}


extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 {
            setEmptyMessage()
        } else {
            restore()
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatBubbleCell.identifier, for: indexPath) as? MyChatBubbleCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatBubbleCell.identifier, for: indexPath) as? YourChatBubbleCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setEmptyMessage() {
        let imageView = UIImageView(image: UIImage(named: "emptybubble"))

        imageView.contentMode = .scaleAspectFit
        imageView.layer.frame = CGRect(x: view.frame.midX-75, y: view.frame.midY-175, width: 150, height: 150)
        let tableViewBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: chatBubbleTableView.bounds.size.width, height: chatBubbleTableView.bounds.size.height))
        tableViewBackgroundView.addSubview(imageView)
        
        chatBubbleTableView.backgroundView = tableViewBackgroundView
    }

    func restore() {
        chatBubbleTableView.backgroundView = nil
    }
    
}

extension ChatRoomViewController {
    @objc func expandButtonClicked(_ sender: UIButton) {
        isExpanded.toggle()
    }
}
