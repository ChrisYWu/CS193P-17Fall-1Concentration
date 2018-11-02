//
//  ViewController.swift
//  Concentration
//
//  Created by Chris Wu on 10/26/18.
//  Copyright © 2018 Wu Personal Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairOfCards: numberOfPairOfCards)
    private var emojiSetChoiceIndex: Int = 0
    {
        didSet{
            setGameUI()
        }
    }
    
    override func viewDidLoad() {
        emojiSetChoiceIndex = ViewController.emojiChoices.count.arc4random
    }
    
    private func setGameUI(){
        let (emojiChoices, bgColor, cardBGColor) = ViewController.emojiChoices[emojiSetChoiceIndex]
        view.backgroundColor = bgColor
        viewBackGroundColor = bgColor
        currentEmojiChoies = emojiChoices
        cardBackGroundColor = cardBGColor
        flipCountLabel.backgroundColor = cardBGColor
        flipCountLabel.textColor = bgColor
        gameScore.backgroundColor = cardBGColor
        gameScore.textColor = bgColor
        newGameButton.backgroundColor = cardBGColor
        newGameButton.setTitleColor(bgColor, for: UIControl.State.normal)
        
        for index in cardButtons.indices{
            cardButtons[index].backgroundColor = cardBGColor
        }
        print ("emojiSetChoiceIndex=\(emojiSetChoiceIndex), bg=\(viewBackGroundColor), cardBG=\(self.cardBackGroundColor)")
    }
    
    var numberOfPairOfCards : Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    private static var emojiChoices =
        [
            (["🐶","🐱","🐭","🦄","🐔","🐸","🐤","🐥"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
            (["😀","😍","🤓","😜","🤩","😩","😡","😰"], #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
            (["🍏","🍊","🥑","🍆","🥖","🍅","🥦","🥒"], #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)),
            (["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱"], #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),
            (["🚗","🚕","🚙","🛴","🚘","🚟","🚝","🛸"], #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
            (["❤️","💔","㊙️","💯","☯️","💓","⚛️","🈶"], #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
        ]
    
    private lazy var cardBackGroundColor = ViewController.emojiChoices[emojiSetChoiceIndex].2
    private lazy var viewBackGroundColor = ViewController.emojiChoices[emojiSetChoiceIndex].1
    private lazy var currentEmojiChoies = ViewController.emojiChoices[emojiSetChoiceIndex].0
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var gameScore: UILabel!
    @IBAction func newGame() {
        emojiSetChoiceIndex = ViewController.emojiChoices.count.arc4random
        game = Concentration(numberOfPairOfCards: numberOfPairOfCards)
        updateViewFromModel()
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    private func updateViewFromModel() {
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            //Set logic and not the flip logic
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)     // UIColor.white
            }
            else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardBackGroundColor
            }
        }
        gameScore.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.totalFlipCount) (\(game.elapsedSeconds)sec)"
    }
    
    private var emoji = [Int: String]()
    
    private func emoji(for card:Card) -> String {
        if emoji[card.identifier] == nil, currentEmojiChoies.count > 0 {
            emoji[card.identifier] = currentEmojiChoies.remove(at: currentEmojiChoies.count.arc4random)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
