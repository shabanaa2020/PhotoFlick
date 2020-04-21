//
//  DetailViewController.swift
//  PhotoFlick
//
//  Created by Shabana Sheik on 20/04/20.
//  Copyright © 2020 Shabana Sheik. All rights reserved.
//

import UIKit

enum Details: Int {
    case image = 0
    case graph = 1
    case comments = 2
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailsTableVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Image Title"
        registerNibs()
        detailsTableVw.rowHeight = UITableView.automaticDimension
        detailsTableVw.estimatedRowHeight = 400
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension DetailViewController {
    
    func registerNibs() {
        detailsTableVw.register(DetailImageCell.nib, forCellReuseIdentifier: DetailImageCell.identifier)
        detailsTableVw.register(GraphCell.nib, forCellReuseIdentifier: GraphCell.identifier)
        detailsTableVw.register(CommentsCell.nib, forCellReuseIdentifier: CommentsCell.identifier)
    }
}

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Details.image.rawValue:
            let imageCell = tableView.dequeueReusableCell(withIdentifier:DetailImageCell.identifier) as? DetailImageCell
            return imageCell!
        case Details.graph.rawValue:
            let graphCell = tableView.dequeueReusableCell(withIdentifier:GraphCell.identifier) as? GraphCell
            return graphCell!
        case Details.comments.rawValue:
            let commentsCell = tableView.dequeueReusableCell(withIdentifier:CommentsCell.identifier) as? CommentsCell
            return commentsCell!
        default:
            return UITableViewCell()
        }
    }
}
