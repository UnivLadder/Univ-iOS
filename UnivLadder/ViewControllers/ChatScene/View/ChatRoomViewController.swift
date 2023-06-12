//
//  ChatRoomViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

//채팅방 화면
class ChatRoomViewController: UIViewController {
    
    static func instance() -> ChatRoomViewController {
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        return vc
    }
    
    let data: [String] = Array(repeating: "test", count: 5)

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
            inputBackgroundView.backgroundColor = Colors.Light.light500.color
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
            textView.textColor = Colors.Text.text1000.color
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
            cameraView.backgroundColor = Colors.Light.light500.color
        }
    }
    @IBOutlet weak var cameraButtonTitle: UILabel! {
        didSet {
            cameraButtonTitle.text = "카메라"
            cameraButtonTitle.textAlignment = .center
            cameraButtonTitle.textColor = Colors.Text.text900.color
            cameraButtonTitle.font = Fonts.EsamanruOTF.light.font(size: 11)
        }
    }
    @IBOutlet weak var galleryView: UIView! {
        didSet {
            galleryView.layer.cornerRadius = galleryView.bounds.width / 2
            galleryView.backgroundColor = Colors.Light.light500.color
        }
    }
    @IBOutlet weak var galleryButtonTitle: UILabel! {
        didSet {
            galleryButtonTitle.text = "앨범"
            galleryButtonTitle.textAlignment = .center
            galleryButtonTitle.textColor = Colors.Text.text900.color
            galleryButtonTitle.font = Fonts.EsamanruOTF.light.font(size: 11)
        }
    }
    @IBOutlet weak var documentView: UIView! {
        didSet {
            documentView.layer.cornerRadius = documentView.bounds.width / 2
            documentView.backgroundColor = Colors.Light.light500.color
        }
    }
    @IBOutlet weak var documentButtonTitle: UILabel! {
        didSet {
            documentButtonTitle.text = "파일"
            documentButtonTitle.textAlignment = .center
            documentButtonTitle.textColor = Colors.Text.text900.color
            documentButtonTitle.font = Fonts.EsamanruOTF.light.font(size: 11)
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
    
    
    //메시지 전송
    //    {
    //      "accountId" : 4,
    //      "message" : "안녕하세요!!",
    //      "type" : "TEXT"
    //    }
    @IBAction func sendMsgAction(_ sender: Any) {
        let msg = ["accountId" : 9,
                   "message" : textView.text,
                   "type" : "TEXT"] as [String : Any]
        APIService.shared.getDirectListMessage()
//        APIService.shared.sendDirectMessage(param: msg)
        
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
            //보내는 사람
            var bubble = ["안녕하세요 :)"," ",
                          "네 안녕하세요~ OPIC 관련해서 멘토링 받고 싶어서 연락드립니다."," ",
                          "OPIC을 처음 준비하는 학생입니다. IH를 목표로 하고 있는데 단기간에 성적을 받을 수 있는 방법이 있을까요~?"," ",
                          "안녕하세요 :)","안녕하세요 :)",
                          "안녕하세요 :)"]
            var time = ["12:00","12:00","12:07","12:00","12:15",
                        "12:00","12:00","12:00","12:00","12:00"]
            
            cell.bubbleLabel.text = bubble[indexPath.row]
            cell.timeLabel.text = time[indexPath.row]
            
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatBubbleCell.identifier, for: indexPath) as? YourChatBubbleCell else {
            return UITableViewCell()
        }
        //받는 사람
        var bubble2 = ["","네 안녕하세요. 영어 및 영어 관련 자격증 멘토 홍길동입니다!😊",
                       "","아하 그러시군요 반갑습니다! 어떤 부분에서 멘토링이 필요하실까요!? ",
                       "안녕하세요"," ",
                       "안녕하세요"," ",
                       "안녕하세요"," "]
        var time2 = ["","12:03","12:09","12:09","12:00",
                     "12:00","12:00","12:00","12:00","12:00"]
        
        cell.bubbleLabel.text = bubble2[indexPath.row]
        cell.timeLabel.text = time2[indexPath.row]
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
