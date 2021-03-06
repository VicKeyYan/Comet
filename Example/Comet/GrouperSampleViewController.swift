//
//  GrouperSampleViewController.swift
//  Comet_Example
//
//  Created by Harley-xk on 2019/4/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Comet
import SwiftRandom

let Rooms = ["101", "102", "103", "104", "201", "202", "301", "302"]

struct Student {
    var name: String
    var grade: Int
    var room: String
    var age: String
    
    static func random() -> Student {
        let student = Student(name: Randoms.randomFakeNameAndEnglishHonorific(),
                              grade: Int.random(10, 100),
                              room: Rooms.randomItem()!,
                              age: "\(Int.random(12, 15))岁")
        return student
    }
}


class GrouperSampleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var students: [Student] = []
    
    var groups: [Group<Student, String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for _ in 0 ..< 50 {
            students.append(.random())
        }
        groupByRoom()
    }
    
    @IBAction func changeGroupType(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0: groupByRoom()
        case 1: groupByAge()
        case 2: groupByGrade()
        default: break
        }
        
        tableView.reloadData()
    }
    
    private func groupByRoom() {
        groups = students.sorted{$0.room < $1.room}.grouped(by: \.room)
    }
    
    private func groupByAge() {
        groups = students.sorted{$0.age < $1.age}.grouped(by: \.age)
    }
    
    private func groupByGrade() {
        groups = students.sorted{$0.grade > $1.grade}.grouped(by: { (student) -> String in
            if student.grade < 60 {
                return "60分以下 - 不及格"
            } else if student.grade < 70 {
                return "60~69分 - 差"
            } else if student.grade < 80 {
                return "70~79分 - 中等"
            } else if student.grade < 90 {
                return "80~89分 - 良好"
            } else {
                return "90分以上 - 优秀"
            }
        })
    }
}

extension GrouperSampleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].index
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = groups[indexPath.section].elements[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as StudentInfoCell
        cell.nameLabel.text = student.name
        cell.ageLabel.text = "年龄: \(student.age)"
        cell.gradeLabel.text = "成绩: \(student.grade)"
        cell.roomLabel.text = "宿舍: \(student.room)"
        return cell
    }
}

class StudentInfoCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
}
