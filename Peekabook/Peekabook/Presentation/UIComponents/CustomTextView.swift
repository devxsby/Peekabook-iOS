//
//  CommentView.swift
//  Peekabook
//
//  Created by 고두영 on 2023/02/22.
//

import UIKit

final class CustomTextView: UIView {

    // MARK: - UI Components
    
    private let boxView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 229))
    private let headerView = UIView()
    
    private let label = UILabel().then {
        $0.text = I18N.BookDetail.comment
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private let textView = UITextView().then {
        $0.text = I18N.BookDetail.commentHint
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.backgroundColor = .clear
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
    
    private let maxLabel = UILabel().then {
        $0.text = I18N.BookAdd.commentLength
        $0.font = .h2
        $0.textColor = .peekaGray2
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomTextView {
    
    private func setDelegate() {
        textView.delegate = self
    }
    
    private func setUI() {
        backgroundColor = .clear
        boxView.backgroundColor = .peekaWhite_60
        boxView.layer.borderWidth = 2
        boxView.layer.borderColor = UIColor.peekaRed.cgColor
        headerView.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        
        addSubviews(boxView, maxLabel)
        
        [headerView, textView].forEach {
            boxView.addSubview($0)
        }
        
        [label].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(boxView).inset(14)
        }
        
        maxLabel.snp.makeConstraints {
            $0.top.equalTo(boxView.snp.bottom).offset(8)
            $0.trailing.equalTo(boxView.snp.trailing)
        }
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == I18N.BookDetail.commentHint) ||
            (textView.text == I18N.BookDetail.memoHint) ||
            (textView.text == I18N.BookDetail.emptyComment) ||
            (textView.text == I18N.BookDetail.emptyMemo) {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if label.text == I18N.BookDetail.comment {
                textView.text = I18N.BookDetail.commentHint
                textView.textColor = .peekaGray1
            } else {
                textView.text = I18N.BookDetail.memoHint
                textView.textColor = .peekaGray1
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if label.text == I18N.BookDetail.comment {
            maxLabel.text = "\(textView.text.count)/200"
            if textView.text.count > 200 {
                textView.deleteBackward()
            }
        } else {
            maxLabel.text = "\(textView.text.count)/50"
            if textView.text.count > 50 {
                textView.deleteBackward()
            }
        }
    }
}

extension CustomTextView {
    func setAddBookMemoTextView() {
        boxView.frame.size.height = 101
        label.text = I18N.BookDetail.memo
        textView.text = I18N.BookDetail.memoHint
        maxLabel.text = I18N.BookAdd.memoLength
    }
    
    func setEditBookCommentTextView() {
        boxView.backgroundColor = .clear
    }
    
    func setEditBookMemoTextView() {
        boxView.backgroundColor = .clear
        boxView.frame.size.height = 101
        label.text = I18N.BookDetail.memo
        textView.text = I18N.BookDetail.memoHint
    }
    
    func setBookDetailCommentTextView() {
        boxView.backgroundColor = .clear
        maxLabel.isHidden = true
    }
    
    func setBookDetailMemoTextView() {
        label.text = I18N.BookDetail.memo
        boxView.backgroundColor = .clear
        maxLabel.isHidden = true
        boxView.frame.size.height = 101
    }
    
    func getBoxView() -> UIView {
        return self.boxView
    }

    func getTextView() -> UITextView {
        return self.textView
    }
    
    func getMaxLabel() -> UILabel {
        return self.maxLabel
    }
}
