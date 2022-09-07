//
//  QuestionsView.swift
//  Batch
//
//  Created by Kevin Shiflett on 8/18/22.
//

import Foundation
import UIKit

protocol QuestionSelectionDelegate {
    func questionSelected(question: String)
}

class QuestionsView: UIStackView {
    
    //MARK: Variablesd
    var questionSelected: Bool = false
    
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate let questionID = "question"
    
    var selectionDelegate: QuestionSelectionDelegate?
    
    var questions: [String]? {
        didSet {
            self.questionsCollection.reloadData()
            self.layoutSubviews()
        }
    }
    
    //MARK: UI Elements
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-Extrabold", size: 22)
        label.textAlignment = .center
        label.text = "Select a Question"
        return label
    }()
    
    lazy var questionsCollection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 25, right: 0)
        self.axis = .vertical
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.isHidden = true
        self.distribution = .fill
        self.addArrangedSubview(headerLabel)
        setupQuestionsCollection()
    }
    
    fileprivate func setupQuestionsCollection() {
        self.questionsCollection.clipsToBounds = false
        self.questionsCollection.layer.masksToBounds = false
        self.addArrangedSubview(questionsCollection)
        self.questionsCollection.backgroundColor = .clear
        questionsCollection.translatesAutoresizingMaskIntoConstraints = false
        collectionViewHeightConstraint = self.questionsCollection.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint.isActive = true
        self.questionsCollection.collectionViewLayout = self.flowLayout
        self.questionsCollection.register(QuestionCell.self, forCellWithReuseIdentifier: questionID)
        self.questionsCollection.dataSource = self
        self.questionsCollection.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewHeightConstraint.constant = self.questionsCollection.collectionViewLayout.collectionViewContentSize.height
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectRandom() {
        self.collectionView(questionsCollection, didSelectItemAt: IndexPath(item: Int.random(in: 0 ... 3), section: 0))
    }
}

extension QuestionsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return questions?.count ?? 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionID, for: indexPath) as! QuestionCell
        cell.question = questions![indexPath.item]
        cell.isUserInteractionEnabled = !questionSelected
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 50, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? QuestionCell
        guard let question = cell?.question else { return }
        self.selectionDelegate?.questionSelected(question: question)
        self.questionSelected = true
        self.questions!.removeAll(where: {$0 != question})
        self.headerLabel.text = "Question Selected"
    }
    
}
