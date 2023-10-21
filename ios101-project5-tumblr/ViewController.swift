//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TumblrCell", for: indexPath) as! TumblrCell
        
        let post = posts[indexPath.row]
        
        if let photo = post.photos.first {
            let url = photo.originalSize.url
              
            // Load the photo in the image view via Nuke library...
            Nuke.loadImage(with: url, into: cell.cImageView)
        }
        
        print("🍏 \(post.caption)")
        cell.summaryLabel.text = post.summary
        //cell.captionLabel.text = post.caption
        
        return cell
    }
    
    private var posts: [Post] = []

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "")
        tableView.refreshControl = refreshControl
        
        fetchPosts()
    }
    
    @objc func refreshData() {
        // Fetch new data or perform a data refresh operation here
        fetchPosts()
    }

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/onestarbookreview/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts


                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    
                    self?.posts = posts
                    self?.refreshControl.endRefreshing()
                    self?.tableView.reloadData()
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
