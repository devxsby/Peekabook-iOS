//
//  UserSearchVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class UserSearchVC: UIViewController {
    
    // MARK: - Properties
    
    private let bookShelfVC = BookShelfVC()
    private var serverGetUserData: SearchUserResponse?
    
    private var friendId: Int = 0
    private var isFollowingStatus: Bool = false
    
    // MARK: - UI Components
    
    private let emptyView = UIView()
    private let emptyImgView = UIImageView().then {
        $0.image = ImageLiterals.Icn.empty
    }
    private let emptyLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed_60
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.text = I18N.ErrorPopUp.emptyUser
    }
    
    private let headerView = UIView()
    private lazy var backButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.back, for: .normal)
        $0.addTarget(
            self,
            action: #selector(backBtnTapped),
            for: .touchUpInside
        )
    }
    private let searchTitleLabel = UILabel().then {
        $0.text = I18N.Tabbar.userSearch
        $0.textColor = .peekaRed
        $0.font = .h3
    }
    private let headerUnderlineView = UIView()
    private let userSearchView = CustomSearchView()
    
    private let friendProfileContainerView = UIView()
    private let profileImage = UIImageView().then {
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
    }
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .peekaRed
        $0.font = .h1
    }
    private lazy var followButton = UIButton().then {
        $0.setTitle(I18N.FollowStatus.follow, for: .normal)
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.titleLabel?.font = .s3
        $0.backgroundColor = .peekaRed
        $0.addTarget(self, action: #selector(followButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func followButtonDidTap() {
        isFollowingStatus.toggle()
        if isFollowingStatus {
            followed()
            postFollowAPI(friendId: friendId)
        } else {
            unfollowed()
            deleteFollowAPI(friendId: friendId)
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReusableView()
        setUI()
        setLayout()
        setBlankView()
        userSearchView.searchTextField.delegate = self
    }
    
    @objc private func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func searchBtnTapped() {
        getUserAPI(nickname: userSearchView.searchTextField.text!)
    }
}

// MARK: - UI & Layout

extension UserSearchVC {
    
    private func setReusableView() {
        userSearchView.searchTextField.attributedPlaceholder = NSAttributedString(string: I18N.PlaceHolder.userSearch)
        userSearchView.searchButton.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
    }
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerUnderlineView.backgroundColor = .peekaRed
        emptyView.backgroundColor = .clear
        friendProfileContainerView.backgroundColor = .white
    }
    
    private func setEmptyView() {
        self.friendProfileContainerView.isHidden = true
        self.emptyView.isHidden = false
    }
    
    private func setSuccessView() {
        self.emptyView.isHidden = true
        self.friendProfileContainerView.isHidden = false
    }
    
    private func setFollowStatus() {
        if followButton.isSelected {
            followed()
        } else {
            unfollowed()
        }
    }
    
    private func setBlankView() {
        emptyView.isHidden = true
        friendProfileContainerView.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(
            [userSearchView,
            friendProfileContainerView,
            headerView,
            emptyView]
        )
        headerView.addSubviews(
            [backButton,
             searchTitleLabel,
             headerUnderlineView]
        )
        emptyView.addSubviews(emptyImgView, emptyLabel)
        friendProfileContainerView.addSubviews(
            [profileImage,
            nameLabel,
            followButton]
        )
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(48)
        }
        searchTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        headerUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        userSearchView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userSearchView.searchContainerView).offset(204)
            make.height.equalTo(96)
            make.width.equalTo(247)
        }
        emptyImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImgView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        friendProfileContainerView.snp.makeConstraints { make in
            make.top.equalTo(userSearchView.searchContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(176)
        }
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.height.width.equalTo(56)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        followButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(82)
            make.height.equalTo(32)
        }
    }
}

// MARK: - Methods

extension UserSearchVC {
    
    private func followed() {
        followButton.backgroundColor = .peekaGray2
        followButton.setTitle(I18N.FollowStatus.following, for: .normal)
        profileImage.layer.borderColor = UIColor.peekaGray2.cgColor
    }
    private func unfollowed() {
        followButton.backgroundColor = .peekaRed
        followButton.setTitle(I18N.FollowStatus.follow, for: .normal)
        profileImage.layer.borderColor = UIColor.peekaRed.cgColor
    }
}

extension UserSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userSearchView.searchTextField.endEditing(true)
        searchBtnTapped()
        return true
    }
}

// MARK: - Network

extension UserSearchVC {
    private func getUserAPI(nickname: String) {
        FriendAPI.shared.searchUserData(nickname: nickname) { response in
            if response?.success == true {
                guard let serverGetUserData = response?.data else { return }
                self.nameLabel.text = serverGetUserData.nickname
                self.profileImage.kf.indicatorType = .activity
                self.profileImage.kf.setImage(with: URL(string: serverGetUserData.profileImage))
                self.followButton.isSelected = serverGetUserData.isFollowed
                self.isFollowingStatus = self.followButton.isSelected
                self.friendId = serverGetUserData.friendID
                self.setFollowStatus()
                self.setSuccessView()
            } else {
                self.setEmptyView()
            }
        }
    }
    
    private func postFollowAPI(friendId: Int) {
        FriendAPI.shared.postFollowing(id: friendId) { response in
            if response?.success == true {
                self.isFollowingStatus = true
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
    
    private func deleteFollowAPI(friendId: Int) {
        FriendAPI.shared.deleteFollowing(id: friendId) { response in
            if response?.success == true {
                self.isFollowingStatus = false
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
