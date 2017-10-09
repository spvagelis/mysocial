//
//  Post.swift
//  mysocial
//
//  Created by vagelis spirou on 9/10/17.
//  Copyright © 2017 vagelis spirou. All rights reserved.
//

import Foundation

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String! // Ειναι ουσιαστικά το postid (π.χ: 345rfgg)
    
    var caption: String {
        
        return _caption
    }
    
    var imageUrl: String {
        
        return _imageUrl
    }
    
    var likes: Int {
        
        return _likes
    }
    
    var postKey: String {
        
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        
    }
    
    // Μετατρέπουμε τα data που παίρνουμε απο την firebase σε data μορφή που θέλουμε.
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            
            self._likes = likes
        }
        
    }
    
    
}





















