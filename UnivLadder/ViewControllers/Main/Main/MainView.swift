//
//  MentoListView.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/09/13.
//

import UIKit
// SnapKit : 스토리 보드 없이 오토 레이아웃 할 수 있는 라이브러리
import SnapKit
import Then

                                
class MainView: UIView {

    // MARK: - 멘토 프로필
    let profileImageView = UIImageView().then {
        //이미지 try catch 처리
        let image = UIImage(named: "펭수.png");
        
//        let imageView = UIImageView(image: squareImg(at: image!)!)
//        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
//        mainView.addSubview(imageView)
//        $0.image = mainView.asImage()
//        let userInfo = CoreDataManager.shared.getUserInfo()
//        // 없는 경우 기본 이미지
//        var image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal)
        // 있는 경우
//        if userInfo[0].thumbnail != nil {
//            image = UIImage(named: self.userInfo[0].thumbnail)
//        }

        $0.image = image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = Constant.profileImgSize/2
        
        //넘치는 영역 잘라내기
        $0.clipsToBounds = true
    }
    
    let registerMentoButton = UIButton().then {
        var state = "멘토"
        $0.setTitle(state, for: .normal)
        
    }
    
    let nameLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.bold.font(size: Constant.menuFontSizeXS)
        let userInfo = CoreDataManager.shared.getUserInfo()
        
        //exception 처리
        if userInfo.count > 0{
            $0.text = userInfo[0].name
        }else{
            $0.text = ""
        }
        
        $0.textColor = .black
    }
    
    let name2Label = UILabel().then {
        $0.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS-2)
        $0.text = "님"
        $0.textColor = .black
    }
    
    let mapImageView = UIImageView().then {
        let image = UIImage(named: "map.png");
        $0.image = image
        
    }
    
    let addressLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.light.font(size: 12)
        $0.textColor = Colors.Text.text1000.color
        $0.text = "서울특별시 동작구 양녕로 29길 22"
    }
    
    // MARK: - 멘토 찾기
    let searchMentoTitleLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS)
        $0.textColor = .black
        $0.text = "멘토 찾기"
    }
    
    let img = #imageLiteral(resourceName: "find")
    
    let searchMentoButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "find"), for: .normal)// 이미지 넣기
        $0.setTitle("  어떤 분야의 멘토를 찾으시나요?", for: .normal)
        $0.titleLabel?.textAlignment = .left
        $0.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.cornerRadius = 10

    }


    //카테고리
    let categoryCollectionLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS)
        $0.textColor = .black
        $0.text = "카테고리"
    }
    
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
    }
    
    // MARK: - 지금 뜨고 있는 멘토
    let mentoListTitleLabel = UILabel().then {
        $0.font = Fonts.EsamanruOTF.medium.font(size: Constant.menuFontSizeXS)
        $0.textColor = .black
        $0.text = "지금 뜨고 있는 멘토"
    }
    
    let mentoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        $0.backgroundColor = .white
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension MainView: ViewRepresentable {
    func setupViews() {
        backgroundColor = .white
        
        // 프로필
        addSubview(profileImageView)
        addSubview(registerMentoButton)
        addSubview(nameLabel)
        addSubview(name2Label)
//        addSubview(mapImageView)
//        addSubview(addressLabel)
        
        // 멘토찾기
        addSubview(searchMentoTitleLabel)
        addSubview(searchMentoButton)
        
        //카테고리
        addSubview(categoryCollectionLabel)
        addSubview(categoryCollectionView)
        
        // 지금 뜨고 있는 멘토
        addSubview(mentoListTitleLabel)
        addSubview(mentoCollectionView)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(Constant.profileImgSize)
            $0.top.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        registerMentoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(profileImageView)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView)
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        //님 label
        name2Label.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing)
            $0.bottom.firstBaseline.equalTo(nameLabel)
        }
        
//        mapImageView.snp.makeConstraints {
//            $0.leading.equalTo(profileImageView)
//            $0.width.height.equalTo(15)
//            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
//        }
        
//        addressLabel.snp.makeConstraints {
//            $0.leading.equalTo(mapImageView.snp.trailing).offset(10)
//            $0.centerY.equalTo(mapImageView)
//            $0.trailing.equalToSuperview().offset(-20)
//        }
        
        searchMentoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constant.menuIntervalHeight)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        searchMentoButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.top.equalTo(searchMentoTitleLabel.snp.bottom).offset(Constant.menuContentIntervalHeight)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        categoryCollectionLabel.snp.makeConstraints {
            $0.top.equalTo(searchMentoButton.snp.bottom).offset(Constant.menuIntervalHeight)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionLabel.snp.bottom).offset(Constant.menuContentIntervalHeight)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Constant.categoryImgSize)
        }
        
        mentoListTitleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(Constant.menuIntervalHeight)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }

        mentoCollectionView.snp.makeConstraints {
            $0.top.equalTo(mentoListTitleLabel.snp.bottom).offset(Constant.menuContentIntervalHeight)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Constant.profileImgSize+40)
        }
    }
}

func squareImg(at image: UIImage, length: CGFloat = Constant.profileImgSize) -> UIImage? {
    let originWidth: CGFloat = image.size.width
    let originHeight: CGFloat = image.size.height
    var resizedWidth: CGFloat = length
    var resizedHeight: CGFloat = length
    
    UIGraphicsBeginImageContext(CGSize(width: length, height: length))
    UIColor.white.set()
    UIRectFill(CGRect(x: 0.0, y: 0.0, width: length, height: length))
    
    let sizeRatio = length / max(originWidth, originHeight)
    if originWidth > originHeight{
        resizedWidth = length
        resizedHeight = originHeight + sizeRatio
    }else{
        resizedWidth = originWidth + sizeRatio
        resizedHeight = length
    }
    image.draw(in: CGRect(x: length/2 - resizedWidth/2,
                          y: length/2 - resizedHeight/2,
                          width: resizedWidth,
                          height: resizedHeight))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
}
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
extension UIView {
  func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
