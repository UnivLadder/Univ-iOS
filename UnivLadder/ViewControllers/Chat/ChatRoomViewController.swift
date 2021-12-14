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
    let data: [String] = ["안녕", "하하하하"]

    var isExpanded: Bool = false
    
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
    @IBOutlet weak var galleryView: UIView! {
        didSet {
            galleryView.layer.cornerRadius = galleryView.bounds.width / 2
            galleryView.backgroundColor = Theme.light500
        }
    }
    @IBOutlet weak var documentView: UIView! {
        didSet {
            documentView.layer.cornerRadius = documentView.bounds.width / 2
            documentView.backgroundColor = Theme.light500
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

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatBubbleCell.identifier, for: indexPath) as? YourChatBubbleCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ChatRoomViewController {
    @objc func expandButtonClicked(_ sender: UIButton) {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.buttonStackView.isHidden = !self.isExpanded
        }
    }
}
