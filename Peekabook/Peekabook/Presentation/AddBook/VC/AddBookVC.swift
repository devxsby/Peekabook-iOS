//
//  AddBookVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class AddBookVC: UIViewController {
    
    // MARK: - Properties
    
    var bookInfo: [BookInfoModel] = []
    private var focus = 0
    var seletedBookIndex = 0
    var imgaeUrl: String = ""
    
    private var serverAddBookInfo: PostBookRequest?
    
    // MARK: - UI Components
    
    private let headerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private let headerTitleLabel = UILabel().then {
        $0.text = I18N.BookAdd.title
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private lazy var checkButton = UIButton().then {
        $0.setTitle(I18N.BookEdit.done, for: .normal)
        $0.titleLabel!.font = .h4
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    
    private let containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let bookImgView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFit
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .h3
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .h2
        $0.textAlignment = .center
        $0.textColor = .peekaRed
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let peekaCommentView = CommentView()
    private let peekaMemoView = CommentView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setReusableView()
        setUI()
        setLayout()
        setDelegate()
        addTapGesture()
        addKeyboardObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout

extension AddBookVC {
    private func setReusableView() {
        peekaMemoView.commentBoxView.frame.size.height = 101
        peekaMemoView.commentLabel.text = I18N.BookDetail.memo
        peekaMemoView.commentTextView.text = I18N.BookDetail.memoHint
        peekaMemoView.commentMaxLabel.text = I18N.BookAdd.memoLength
    }
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [backButton, headerTitleLabel, checkButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, peekaCommentView, peekaMemoView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(11)
            make.width.height.equalTo(48)
        }
        
        bookImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(99)
            make.height.equalTo(160)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImgView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(316)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(316)
        }
        
        peekaCommentView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(229)
        }
        
        peekaMemoView.snp.makeConstraints { make in
            make.top.equalTo(peekaCommentView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(101)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension AddBookVC {
    private func setDelegate() {
        peekaCommentView.commentTextView.delegate = self
        peekaMemoView.commentTextView.delegate = self
    }
    
    @objc private func backButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func checkButtonDidTap() {
        guard let bookTitle = self.nameLabel.text,
              let author = self.authorLabel.text,
              let description = peekaCommentView.commentTextView.text,
              let memo = peekaMemoView.commentTextView.text else { return }
        postMyBook(param: PostBookRequest(bookImage: imgaeUrl,
                                          bookTitle: bookTitle,
                                          author: author,
                                          description: description,
                                          memo: memo))
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
        
        if peekaCommentView.commentTextView.isFirstResponder {
            let textViewHeight = peekaCommentView.commentBoxView.frame.height
            let position = CGPoint(x: 0, y: peekaCommentView.commentBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight - 40)
            containerView.setContentOffset(position, animated: true)
            return
        }
        
        if peekaMemoView.commentTextView.isFirstResponder {
            let textViewHeight = peekaMemoView.commentBoxView.frame.height
            let position = CGPoint(x: 0, y: peekaMemoView.commentBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight - 40)
            containerView.setContentOffset(position, animated: true)
            return
        }
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
    }
    
    func dataBind(model: BookInfoModel) {
        nameLabel.text = model.title
        authorLabel.text = model.author.replacingOccurrences(of: "^", with: ", ")
        imgaeUrl = model.image
        bookImgView.kf.indicatorType = .activity
        bookImgView.kf.setImage(with: URL(string: imgaeUrl)!)
    }
}

extension AddBookVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == I18N.BookDetail.commentHint) || (textView.text == I18N.BookDetail.memoHint) {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if peekaCommentView.commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            peekaCommentView.commentTextView.text = I18N.BookDetail.commentHint
            peekaCommentView.commentTextView.textColor = .peekaGray1
        } else if peekaMemoView.commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            peekaMemoView.commentTextView.text = I18N.BookDetail.memoHint
            peekaMemoView.commentTextView.textColor = .peekaGray1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == peekaCommentView.commentTextView {
            peekaCommentView.commentMaxLabel.text = "\(peekaCommentView.commentTextView.text.count)/200"
            if peekaCommentView.commentTextView.text.count > 200 {
                peekaCommentView.commentTextView.deleteBackward()
            }
        }
        
        if textView == peekaMemoView.commentTextView {
            peekaMemoView.commentMaxLabel.text = "\(peekaMemoView.commentTextView.text.count)/50"
            if peekaMemoView.commentTextView.text.count > 50 {
                peekaMemoView.commentTextView.deleteBackward()
            }
        }
    }
}

extension AddBookVC {
    private func postMyBook(param: PostBookRequest) {
        BookShelfAPI.shared.postMyBookInfo(param: param) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
