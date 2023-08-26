//
//  ChatRoomViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

//채팅방 화면
class ChatRoomViewController: UIViewController, UITextViewDelegate {

    var allChatting = [ChattingRoom]()
    var myChatting = [ChattingRoom]()
    var yourChatting = [ChattingRoom]()
    
    var user: AccountData?
    var userName: String?
    var userAccount: Int?
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var messageButtonStackView: UIView!
    
    static func instance() -> ChatRoomViewController {
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        return vc
    }
    
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
//            expandButton.addTarget(self, action: #selector(expandButtonClicked(_:)), for: .touchUpInside)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    //키보드 올라갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillShow(_ sender:Notification){
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height - messageButtonStackView.frame.height + 10

        if messageView.frame.origin.y == 0 {
            messageView.frame.origin.y -= keyboardHeight
        }
    }
    //키보드 내려갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillHide(_ sender:Notification){
        self.messageView.frame.origin.y = 0
    }
    
    let textViewPlaceHolder = "메시지를 입력해주세요."
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.backgroundColor = .clear
            textView.text = textViewPlaceHolder
            textView.textColor = Colors.Text.text1000.color
            textView.delegate = self
            textView.autocorrectionType = .no
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
    
    
    // Direct Message 전송 action
    @IBAction func sendMsgAction(_ sendffer: Any) {
        // 받을 멘토 id
        let msg = ["accountId" : userAccount ?? 0,
                   "message" : textView.text,
                   "type" : "TEXT"] as [String : Any]
        if let token = UserDefaults.standard.string(forKey: "accessToken"){
            APIService.shared.sendDirectMessage(accessToken: token, param: msg, completion: { res in
                if res == true {
                    APIService.shared.getDirectMessages(myaccessToken: token, senderAccountId: msg["accountId"] as! Int, completion: { res in
                        self.allChatting = res
                        self.textView.text = ""
                        self.chatBubbleTableView.reloadData()
                        let moveIndex = IndexPath(row: self.allChatting.count-1, section: 0)
                        self.chatBubbleTableView.scrollToRow(at: moveIndex, at: .bottom, animated: false)
                    })
                }
            })
        }

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chatBubbleTableView.setContentOffset(CGPoint(x: 0, y: chatBubbleTableView.contentSize.height - chatBubbleTableView.bounds.height), animated: true)
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = userName ?? ""
        //키패드 제어
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        
        chatBubbleTableView.delegate = self
        chatBubbleTableView.dataSource = self
        chatBubbleTableView.separatorStyle = .none

        if let chattingListUserdefault = UserDefaultsManager.chatting{
            allChatting = chattingListUserdefault
            chattingListUserdefault.enumerated().forEach({
                if $0.element.senderAccountId == UserDefaults.standard.integer(forKey: "accountId"){
                    myChatting.append(chattingListUserdefault[$0.offset])
                }else{
                    yourChatting.append(chattingListUserdefault[$0.offset])
                }
            })
            if allChatting.count > 0 {
                let moveIndex = IndexPath(row: allChatting.count-1, section: 0)
                chatBubbleTableView.scrollToRow(at: moveIndex, at: .bottom, animated: false)
            }
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allChatting.count == 0 {
            setEmptyMessage()
        } else {
            restore()
        }
        return allChatting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if allChatting[indexPath.row].senderAccountId == UserDefaults.standard.integer(forKey: "accountId"){
            //내 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatBubbleCell.identifier, for: indexPath) as? MyChatBubbleCell else {
                return UITableViewCell()
            }
            var bubble = allChatting[indexPath.row].message
            var time = allChatting[indexPath.row].lastModifiedDate

            cell.bubbleLabel.text = bubble
            cell.timeLabel.text = time.toDate()?.toString()
            
            cell.selectionStyle = .none
            return cell
        }
        //대화 상대 셀
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatBubbleCell.identifier, for: indexPath) as? YourChatBubbleCell else {
            return UITableViewCell()
        }
        
        var bubble2 = allChatting[indexPath.row].message
        var time2 = allChatting[indexPath.row].lastModifiedDate.toDate()?.toString()

        cell.bubbleLabel.text = allChatting[indexPath.row].message
        cell.timeLabel.text = allChatting[indexPath.row].lastModifiedDate.toDate()?.toString()
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
//        isExpanded.toggle()
    }
}
