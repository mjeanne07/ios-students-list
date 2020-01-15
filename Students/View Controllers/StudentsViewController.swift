//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let studentController = StudentController()
    private var filteredAndSortedStudents: [Student] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        studentController.loadFromPersistentStore { (students, error) in
            guard error == nil else {
                print("Error loading students: \(error!)")
                return
            }
            
            guard let students = students else {
                print("Error: Students was nil!")
                return
            }
            
            DispatchQueue.main.async {
                self.filteredAndSortedStudents = students
            }
        }
        let intArray = [1, 2, 3, nil, 4, 5, 6]
        
        // filter
        let filteredArray = intArray.filter { ($0 ?? 0) % 2 == 0}
        print("Even array = \(filteredArray)")
        
        // sorted
        let sortedArray = intArray.sorted { ($0 ?? 0) > ($1 ?? 0) }
        print("Sorted array = \(sortedArray)")
        
        // map
        let mappedArray = intArray.map { ($0 ?? 0) * 2}
        print("Mapped array = \(mappedArray)")
        
        // flatMap or compactMap
        let flatMappedArray = intArray.flatMap { $0 }
        print("Flat mapped array = \(flatMappedArray)")
        
        let compactMappedArray = intArray.compactMap { $0 }
        print("Compact mapped array = \(compactMappedArray)")
        
        //Using compactMap to clean up an array
        let cleanFilteredArray = intArray.compactMap { $0 }
            .filter { $0 % 2 == 0}
        print("Even array = \(cleanFilteredArray)")
        
        // reduce - adding all values together
        let reducedArray = intArray
            .compactMap { $0 }
            .reduce(0) { (result, value) -> Int in
                return result + value
        }
        print("Reduced array = \(reducedArray)")
        
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        let filter = TrackType(rawValue: filterSelector.selectedSegmentIndex) ?? .none
        let sort = SortOption(rawValue: sortSelector.selectedSegmentIndex) ?? .firstName
        
        studentController.filter(with: filter, sortedBy: sort) { (students) in
            self.filteredAndSortedStudents = students
        }
    }
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        guard indexPath.row < filteredAndSortedStudents.count else { return cell }
        
        let student = filteredAndSortedStudents[indexPath.row]
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.course
        
        return cell
    }
}
