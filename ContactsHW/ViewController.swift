//
//  ViewController.swift
//  ContactsHW
//
//  Created by Rares Marina on 11/29/23.
//

import UIKit

class ViewController: UIViewController {

    private var names = [String]()
    
    private var sectionTitle = [String]()
    
    private var nameDict = [String: [String]]()

    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.placeholder = "Adaugati un contact nou"
        textField.delegate = self
        
        names = [
            "Abraham", "Allan", "Alsop", "Anderson", "Arnold", "Avery", "Bailey", "Baker", "Ball", "Bell", "Berry", "Black", "Blake", "Bond", "Bower", "Brown", "Buckland", "Burgess", "Butler", "Cameron", "Campbell", "Carr", "Chapman", "Churchill", "Clark", "Clarkson", "Coleman", "Cornish", "Davidson", "Davies", "Dickens", "Dowd", "Duncan", "Dyer", "Edmunds", "Ellison", "Ferguson", "Fisher", "Forsyth", "Fraser", "Gibson", "Gill", "Glover", "Graham", "Grant", "Gray", "Greene", "Hamilton", "Hardacre", "Harris", "Hart", "Hemmings", "Henderson", "Hill", "Hodges", "Howard", "Hudson", "Hughes", "Hunter", "Ince", "Jackson", "James", "Johnston", "Jones", "Kelly", "Kerr", "King", "Knox", "Lambert", "Langdon", "Lawrence", "Lee", "Lewis", "Lyman", "MacDonald", "Mackay", "Mackenzie", "MacLeod", "Manning", "Marshall", "Martin", "Mathis", "May", "McDonald", "McLean", "McGrath", "Metcalfe", "Miller", "Mills", "Mitchell", "Morgan", "Morrison", "Murray", "Nash", "Newman", "Nolan", "North", "Ogden", "Oliver", "Paige", "Parr", "Parsons", "Paterson", "Payne", "Peake", "Peters", "Piper", "Poole", "Powell", "Pullman", "Quinn", "Rampling", "Randall", "Rees", "Reid", "Roberts", "Robertson", "Ross", "Russell", "Rutherford", "Sanderson", "Scott", "Sharp", "Short", "Simpson", "Skinner", "Slater", "Smith", "Springer", "Stewart", "Sutherland", "Taylor", "Terry", "Thomson", "Tucker", "Turner", "Underwood", "Vance", "Vaughan", "Walker", "Wallace", "Walsh", "Watson", "Welch", "White", "Wilkins", "Wilson", "Wright", "Xoxo", "Young", "Zack",
        ]
        //adaugam primele litere din fecare nume intr un set pentru a elimina duplicatele si il sortam
        sectionTitle = Array(Set(names.compactMap({String($0.prefix(1))})))
        sectionTitle.sort()
        
        //construim dictionarul
        sectionTitle.forEach({nameDict[$0] = [String]()})
        names.forEach({nameDict[String($0.prefix(1))]?.append($0)})
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIApplication.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIApplication.keyboardWillHideNotification,
            object: nil
        )
        
    }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y -= keyboardHeight
        }
        
    }

    @objc private func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nameDict[sectionTitle[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = nameDict[sectionTitle[indexPath.section]]?[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitle[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionTitle
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        
        names.append(text.capitalized)
        names.sort()
        
        sectionTitle = Array(Set(names.compactMap({String($0.prefix(1))})))
        
        //reconstruim dictionarul
        sectionTitle.forEach({nameDict[$0] = [String]()})
        names.forEach({nameDict[String($0.prefix(1))]?.append($0)})
        
        updateSectionTitle()
        tableView.reloadData()

        textField.text = ""
        textField.resignFirstResponder()
        return true
    }

    private func updateSectionTitle() {
        sectionTitle = Array(Set(nameDict.keys)).sorted()
    }
    

}
