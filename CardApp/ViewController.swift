//
//  ViewController.swift
//  CardApp
//
//  Created by Sumeet  Jain on 13/01/20.
//  Copyright © 2020 Sumeet Jain. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var greenDeck = Array(1...9)
    var redDeck = Array(1...9)
    var blueDeck = Array(1...9)
    var yellowDeck = Array(1...9)
    var reverseDeck = Array(1...4)
    var players: Int = 0
    var playersCard: [Int : [Card]] = [:]
    
    let inputField = UITextField()
    let infoLabel = UILabel()
    let playerLabel = UILabel()
    let colorTextField = UITextField()
    let btn = UIButton()
    let winnerLabel = UILabel()
    var lastCard = Card(.NoColor, number: -1, isreverse: false)
    var notPlayed: [Int] = []
    var isPlayingReverse = false
    var solution = false
    var newIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputField.delegate = self
        inputField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputField)
        inputField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        inputField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputField.placeholder = "Enter the number of players"
        inputField.tag = 1
        inputField.keyboardType = .numberPad
        inputField.returnKeyType = .done
        inputField.borderStyle = .roundedRect
        inputField.addDoneButtonOnKeyboard()
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        infoLabel.text = "ADD CARDS LIKE THIS : 4 of RED R4 \n For reverse use => rev \n Cards should be comma separated R4,Y5,4B"
        infoLabel.numberOfLines = 0
        infoLabel.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 30).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerLabel)
        playerLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30).isActive = true
        playerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        colorTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorTextField)
        colorTextField.topAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 30).isActive = true
        colorTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorTextField.delegate = self
        colorTextField.tag = 2
        colorTextField.placeholder = "ADD CARDS"
        colorTextField.borderStyle = .roundedRect
        colorTextField.isUserInteractionEnabled = false
        
        btn.setTitle("Next", for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(getNextData), for: .touchUpInside)
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: colorTextField.bottomAnchor, constant: 20).isActive = true
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(winnerLabel)
        winnerLabel.numberOfLines = 0
        winnerLabel.textAlignment = .center
        winnerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        winnerLabel.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 20).isActive = true
        winnerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1:
            if let textValue = textField.text, let num = Int(textValue){
                if num > 13 || num <= 1{
                    print("enter valid number of players... supports from 2 to 13")
                }else{
                    players = num
                    inputField.isUserInteractionEnabled = false
                    colorTextField.isUserInteractionEnabled = true
                    playerLabel.text = "ENTER CARDS FOR PLAYER \(playersCard.count + 1)"
                    //                    getPlayerCards()
                }
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    //    func getPlayerCards(){
    //        for index in 0..<players{
    //
    //        }
    //    }
    
    @objc func getNextData(){
        if btn.currentTitle == "Next"{
            if let inputData = colorTextField.text, !inputData.isEmpty{
                parseData(inputData.lowercased())
            }
        }else{
            getRandomCard(colorArr: ["r", "g", "y", "b"])
            if lastCard.number != -1 {
//                lastCard = Card(.red, number: 5, isreverse: false)
                playerLabel.text = "RANDOM CARD is \(lastCard.color.rawValue) \(lastCard.number)"
                while notPlayed.count < players && !solution{
                    getWinner()
                }
                if notPlayed.count == players {
                    winnerLabel.text = "MATCH DRAW"
                    print("MATCH DRAWN")
                }
            }else{
                print("SOMETHING WENT WRONG")
            }
        }
    }
    func getWinner(){
        outer :for index in 0 ..< playersCard.count{
            var sameNumberIndex = -1
            var reverseCardIndex = -1
            var found = false
            
            if isPlayingReverse{
                if newIndex - 1 < 0{
                    newIndex = players - 1
                }else{
                    newIndex -= 1
                }
            }else{
                newIndex = index
            }
            
            if var currentPlayerCard = playersCard[newIndex]{
                p: for cardIndex in 0 ..< currentPlayerCard.count{
                    if currentPlayerCard[cardIndex].color == lastCard.color{
                        lastCard = currentPlayerCard[cardIndex]
                        print("PLAY PLAYER\(newIndex + 1): \(lastCard.color.rawValue) \(lastCard.number)")
                        currentPlayerCard.remove(at: cardIndex)
                        playersCard[newIndex] = currentPlayerCard
                        found = true
                        break p
                    }else if currentPlayerCard[cardIndex].number == lastCard.number{
                        sameNumberIndex = cardIndex
                    }else if currentPlayerCard[cardIndex].isReverse{
                        reverseCardIndex = cardIndex
                    }
                }
                
                if !found{
                    if sameNumberIndex != -1{
                        lastCard = currentPlayerCard[sameNumberIndex]
                        print("PLAY PLAYER\(newIndex + 1): \(lastCard.color.rawValue) \(lastCard.number)")
                        currentPlayerCard.remove(at: sameNumberIndex)
                        playersCard[newIndex] = currentPlayerCard
                        notPlayed.removeElement(ele: newIndex)
                    }
                    else if reverseCardIndex != -1 {
                        print("PLAY PLAYER\(newIndex + 1): Reverse ")
                        currentPlayerCard.remove(at: reverseCardIndex)
                        playersCard[newIndex] = currentPlayerCard
                        notPlayed.removeElement(ele: newIndex)
                        isPlayingReverse = !isPlayingReverse
                    }else{
                        print("PLAY PLAYER\(newIndex + 1): PASS TO NEXT PLAY")
                        notPlayed.append(newIndex)
                    }
                }else{
                    notPlayed.removeElement(ele: newIndex)
                }
                
                if currentPlayerCard.count == 0{
                    solution = true
                    print("WINNER IS PLAYER \(newIndex + 1)")
                    winnerLabel.text = "WINNER IS PLAYER \(newIndex + 1)"
                    break outer
                }
            }
        }
    }
    
    func parseData(_ input: String){
        
        let index = playersCard.count
        var cardArr: [Card] = []
        let strArr = input.split(separator: ",")
        
        if strArr.count == 3{
            for strIndex in 0 ..< strArr.count{
                let str = strArr[strIndex]
                if str.count > 2 && str == "rev" && reverseDeck.count > 0{
                    cardArr.append(Card(.NoColor, number: -1, isreverse: true))
                    reverseDeck.remove(at: 0)
                }else{
                    if str.count == 2, let number = Int(String(str.suffix(1))){
                        
                        switch String(str.prefix(1)){
                        case "r":
                            if redDeck.contains(number){
                                cardArr.append(Card(.red,number: number,isreverse: false))
                                redDeck.removeElement(ele: number)
                            }
                            
                        case "g":
                            if greenDeck.contains(number){
                                cardArr.append(Card(.green,number: number,isreverse: false))
                                greenDeck.removeElement(ele: number)
                                
                            }
                            
                        case "y":
                            if yellowDeck.contains(number){
                                cardArr.append(Card(.yellow,number: number,isreverse: false))
                                yellowDeck.removeElement(ele: number)
                                
                            }
                            
                        case "b":
                            if blueDeck.contains(number){
                                cardArr.append(Card(.blue,number: number,isreverse: false))
                                blueDeck.removeElement(ele: number)
                                
                            }
                        default:
                            break
                        }
                    }
                    else{
                        print("Enter proper formatted data")
                    }
                }
            }
            
            if cardArr.count == 3 {
                playersCard[index] = cardArr
                if playersCard.count == players {
                    btn.setTitle("GET THE WINNER", for: .normal)
                }else{
                    playerLabel.text = "ENTER CARDS FOR PLAYER \(playersCard.count + 1)"
                    colorTextField.text = nil
                    colorTextField.placeholder = "ADD CARDS"
                }
            }
            
        }else{
            print("Enter proper formatted data")
        }
        
    }
    
    func getRandomCard(colorArr: [String]){
        var colArr = colorArr
        if let randomColor = colorArr.randomElement(){
            switch randomColor{
            case "r":
                if redDeck.isEmpty{
                    colArr.removeElement(ele: "r")
                    getRandomCard(colorArr: colArr)
                }else{
                    if let randNo = redDeck.randomElement(){
                        lastCard = Card(.red,number: randNo,isreverse: false)
                    }
                }
                
            case "g":
                if greenDeck.isEmpty{
                    colArr.removeElement(ele: "g")
                    getRandomCard(colorArr: colArr)
                }else{
                    if let randNo = greenDeck.randomElement(){
                        lastCard = Card(.green,number: randNo,isreverse: false)
                    }
                }
                
            case "y":
                if yellowDeck.isEmpty{
                    colArr.removeElement(ele: "y")
                    getRandomCard(colorArr: colArr)
                }else{
                    if let randNo = yellowDeck.randomElement(){
                        lastCard = Card(.yellow,number: randNo,isreverse: false)
                    }
                }
                
            case "b":
                if blueDeck.isEmpty{
                    colArr.removeElement(ele: "b")
                    getRandomCard(colorArr: colArr)
                }else{
                    if let randNo = blueDeck.randomElement(){
                        lastCard = Card(.blue,number: randNo,isreverse: false)
                    }
                }
            default:
                break
            }
        }
    }
}

class Card{
    
    var color: CardColor
    var number: Int
    var isReverse: Bool
    
    init(_ color: CardColor,number: Int, isreverse: Bool) {
        self.color = color
        self.number = number
        self.isReverse = isreverse
    }
    
}

enum CardColor: String{
    case green = "Green"
    case red = "red"
    case blue = "blue"
    case yellow = "yellow"
    case NoColor = ""
}

extension UITextField{
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension Array where Element == Int{
    
    mutating func removeElement(ele: Int){
        if let index = self.firstIndex(of: ele){
            self.remove(at: index)
        }
    }
}

extension Array where Element == String{
    
    mutating func removeElement(ele: String){
        if let index = self.firstIndex(of: ele){
            self.remove(at: index)
        }
    }
}
