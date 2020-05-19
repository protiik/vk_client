//
//  TabBarController.swift
//  loginForm
//
//  Created by prot on 12.05.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let newsService: NewsServiceRequest = NewsRequest(parser: SwiftyJSONParserNews())
    let friendService: FriendsServiceRequest = FriendRequest(parser: SwiftyJSONParserFriends())
    let groupsService: GroupsServiceRequest = GroupsRequest(parser: SwiftyJSONParserGroups())
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        
        newsService.loadData { }
        friendService.loadData { }
        groupsService.loadData { }
        
    }
}
