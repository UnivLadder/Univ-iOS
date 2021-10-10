//
//  CommunityVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/09/19.
//

import UIKit

class CommunityVC: UIViewController {

    @IBOutlet weak var communityTableView: UITableView!
    
    @IBOutlet weak var writeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        communityTableView.delegate = self
        communityTableView.dataSource = self
        
        setUI()
    }
    

    private func setUI() {
        
        communityTableView.estimatedRowHeight = UITableView.automaticDimension
        communityTableView.rowHeight = UITableView.automaticDimension
        
        communityTableView.separatorInset = .zero
        
        writeButton.layer.cornerRadius = writeButton.bounds.width * 0.5
    }

    @IBAction func didTapWriteButton(_ sender: Any) {
        // 1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
        let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력됏습니다.", preferredStyle: .actionSheet)
        
        // 2. UIAlertAction 생성: 버튼들..
        let ok = UIAlertAction(title: "같이해요", style: .default)
        let ok2 = UIAlertAction(title: "일상", style: .default) {_ in
            self.present(CreateArticleVC(), animated: true, completion: nil)
        }
        
        // 3. 1+2
        alert.addAction(ok)
        alert.addAction(ok2)
        
        // 4. present
        present(alert, animated: true, completion: nil)
    }
}

extension CommunityVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath)
        return cell
    }
    
    
}
