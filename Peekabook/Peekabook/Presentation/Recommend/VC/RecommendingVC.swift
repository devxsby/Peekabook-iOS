//
//  RecommendingVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

class RecommendingVC: UIViewController {
    
    // MARK: - Properties
    
    private var recommendedDummy: [RecommendModel] = [
        RecommendModel(
            image: ImageLiterals.Sample.book4,
            bookName: "눈보라 체이스",
            writer: "양윤옥",
            recommendedPersonImage: ImageLiterals.Sample.profile3,
            recommendedPerson: "강희선배",
            memo: "‘추천사요약’ 을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. 당신에게 추천해요!"
        ),
        RecommendModel(
            image: ImageLiterals.Sample.book1,
            bookName: "아무튼, 여름",
            writer: "김신회",
            recommendedPersonImage: ImageLiterals.Sample.profile2,
            recommendedPerson: "하정선배",
            memo: "‘추천사요약’ 을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. 당신에게 추천해요!"
        ),
        RecommendModel(
            image: ImageLiterals.Sample.book1,
            bookName: "아무튼, 여름",
            writer: "김신회",
            recommendedPersonImage: ImageLiterals.Sample.profile4,
            recommendedPerson: "영주선배",
            memo: "‘추천사요약’ 을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. 당신에게 추천해요! ‘추천사요약’을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. ‘추천사요약’을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. ‘추천사요약’을 쓸 건데 나는 이 책이 후"
        )
    ]
    
    // MARK: - UI Components
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.allowsSelection = false
        $0.allowsMultipleSelection = false
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
    }
}

// MARK: - UI & Layout

extension RecommendingVC {
    
    private func setUI() {
        tableView.backgroundColor = .peekaBeige
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension RecommendingVC {
    
    private func registerCells() {
        tableView.register(
            RecommendTVC.self,
            forCellReuseIdentifier: RecommendTVC.className
        )
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension RecommendingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 221
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return recommendedDummy.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecommendTVC.className,
            for: indexPath
        ) as? RecommendTVC
        else {
            return UITableViewCell()
        }
        cell.dataBind(model: recommendedDummy[indexPath.item])
        return cell
    }
}
