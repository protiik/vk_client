//
//  PictureViewController.swift
//  loginForm
//
//  Created by prot on 29.02.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import RealmSwift
class PictureViewController: UIViewController {
    
    let photoService: PhotosServiceRequest = PhotosRequest(parser: SwiftyJSONParserPhotos())
    var photosList: [PhotosVK] = []
    var photosCached = [UIImage]()
    
    
    @IBOutlet weak var imagesFriendOne: UIImageView!
    @IBOutlet weak var imagesFriendTwo: UIImageView!
    //
    @IBOutlet weak var img2TopConstr: NSLayoutConstraint!
    @IBOutlet weak var img2BottomConstr: NSLayoutConstraint!
    //
    @IBOutlet weak var img1TopConstr: NSLayoutConstraint!
    @IBOutlet weak var img1BottomConstr: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanImg1(_:)))
        imagesFriendOne.isUserInteractionEnabled = true
        imagesFriendOne.addGestureRecognizer(recognizer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        imagesFriendOne.addGestureRecognizer(tapGesture)
        
        let recognizer2 = UIPanGestureRecognizer(target: self, action: #selector(onPanImg2(_:)))
        imagesFriendTwo.isUserInteractionEnabled = true
        imagesFriendTwo.addGestureRecognizer(recognizer2)
        imagesFriendTwo.isHidden = true
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(onTap2(_:)))
        imagesFriendTwo.addGestureRecognizer(tapGesture2)
        
        photoService.loadData()
        loadData()
        
        
        for i in self.photosList {
            let photo = Session.shared.getImage(url: i.photo)
            self.photosCached.append(photo!)
        }
        let images = self.photosCached[self.count]
        
        self.imagesFriendOne.image = images
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
    }
    
    func loadData () {
        do{
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "Нет данных в БД")
            let photos = realm.objects(PhotosVK.self)
            photosList = Array( photos )
        }catch{
            print(error.localizedDescription)
        }

    }
    
    
    var count = 0
    
    var interactiveAnimate: UIViewPropertyAnimator!
    
    // Анимация первой картинки
    @objc func onPanImg1 (_ recognizer: UIPanGestureRecognizer){
    
        print(#function)
        self.imagesFriendTwo.isHidden = true
        self.imagesFriendTwo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.imagesFriendTwo.alpha = 0.5
        self.img2TopConstr.constant = 50
        self.img2BottomConstr.constant = 146
        
        switch recognizer.state {
        case .began:
            interactiveAnimate?.startAnimation()
            
            interactiveAnimate = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6, animations: {
            })
            interactiveAnimate.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            imagesFriendOne.transform = CGAffineTransform(translationX: translation.x / 2, y: 0)
        case .ended:
            interactiveAnimate.stopAnimation(true)
            
            if imagesFriendOne.frame.minX >= 100 {
                
                count -= 1
                if count >= 0 && count < photosList.count {
                        let images = photosCached[self.count]
                        self.imagesFriendTwo.image = images
                        
                    self.imagesFriendTwo.isHidden = false
                    interactiveAnimate.addAnimations {
                        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
                            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                                self.imagesFriendOne.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                            })
                            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                                self.imagesFriendTwo.transform = .identity
                                self.imagesFriendTwo.alpha = 1
                            })
                            UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 0.5, animations: {
                                self.imagesFriendOne.transform = CGAffineTransform(translationX: -(self.view.frame.width), y: 0)
                            })
                        })
                        
                    }
                }else {
                    count = 0
                    interactiveAnimate.addAnimations {
                        self.imagesFriendOne.transform = .identity
                    }
                }
                
            }else if imagesFriendOne.frame.minX <= -100 {
                count += 1
                if count < photosCached.count {
                    let images = photosCached[self.count]
                    self.imagesFriendTwo.image = images
                               
                           
                    self.imagesFriendTwo.isHidden = false
                    interactiveAnimate.addAnimations {
                        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
                            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                                self.imagesFriendOne.transform = CGAffineTransform(translationX: -(self.view.frame.width), y: 0)
                            })
                            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                                self.imagesFriendTwo.alpha = 1
                                self.imagesFriendTwo.transform = CGAffineTransform(scaleX: 1, y: 1)
                            })
                            UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 0.5, animations: {
                                self.imagesFriendOne.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                            })
                        })
                    }
                    
                }else{
                    count = photosCached.count - 1
                    self.imagesFriendOne.transform = .identity
                }
                
                
            }else{
                interactiveAnimate.addAnimations {
                    self.imagesFriendOne.transform = .identity
                }
            }
            interactiveAnimate.startAnimation()
            
        default:
            return
        }
    }
    
    
    // Анимация второй картинки
    @objc func onPanImg2 (_ recognizer: UIPanGestureRecognizer){
        
        let images = photosCached[count]
        imagesFriendOne.image = images
        
        
        print(#function)
        self.imagesFriendOne.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.imagesFriendOne.alpha = 0.5
        self.imagesFriendOne.isHidden = true
        self.img1TopConstr.constant = 50
        self.img1BottomConstr.constant = 146
        
        switch recognizer.state {
        case .began:
            interactiveAnimate?.startAnimation()
            
            interactiveAnimate = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.6, animations: {
                self.imagesFriendTwo.transform = .identity
            })
            interactiveAnimate.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            imagesFriendTwo.transform = CGAffineTransform(translationX: translation.x / 2, y: 0)
        case .ended:
            
            
            
            interactiveAnimate.stopAnimation(true)
            
            if imagesFriendTwo.frame.minX >= 100 {
                count -= 1
                if count >= 0 && count < photosList.count {
                   let images = photosCached[self.count]
                    self.imagesFriendOne.image = images
                              
                           
                    self.imagesFriendOne.isHidden = false
                    
                    interactiveAnimate.addAnimations {
                        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
                            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                                self.imagesFriendTwo.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                            })
                            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                                self.imagesFriendOne.transform = .identity
                                self.imagesFriendOne.alpha = 1
                            })
                            UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 0.5, animations: {
                                self.imagesFriendTwo.transform = CGAffineTransform(translationX: -(self.view.frame.width), y: 0)
                            })
                        })
                    }
                }else {
                    count = 0
                    interactiveAnimate.addAnimations {
                        self.imagesFriendTwo.transform = .identity
                    }
                }
                
                //
                
                
            }else if imagesFriendTwo.frame.minX <= -100 {
                count += 1
                if count < photosList.count {
                    let images = photosCached[self.count]
                    self.imagesFriendOne.image = images
                              
                    self.imagesFriendOne.isHidden = false
                    
                    interactiveAnimate.addAnimations {
                        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
                            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                                self.imagesFriendTwo.transform = CGAffineTransform(translationX: -(self.view.frame.width), y: 0)
                            })
                            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                                self.imagesFriendOne.transform = .identity
                                self.imagesFriendOne.alpha = 1
                            })
                            
                            
                        })
                    }
                    
                }else{
                    count = photosList.count - 1
                    self.imagesFriendTwo.transform = .identity
                }
                
                
            }else{
                interactiveAnimate.addAnimations {
                    self.imagesFriendTwo.transform = .identity
                }
            }
            interactiveAnimate.startAnimation()
            
        default:
            return
        }
        
        
    }
    
    @objc func onTap (_ gesture: UITapGestureRecognizer){
        print(#function)
        self.view.layoutIfNeeded()
        if img1TopConstr.constant == 0 {
            UIView.animate(withDuration: 1, animations: {
                self.img1TopConstr.constant = 50
                self.img1BottomConstr.constant = 146
                self.view.layoutIfNeeded()
            })
        }else {
            UIView.animate(withDuration: 1, animations: {
                self.img1TopConstr.constant = 0
                self.img1BottomConstr.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    @objc func onTap2 (_ gesture: UITapGestureRecognizer){
        print(#function)
        self.view.layoutIfNeeded()
        if img2TopConstr.constant == 0 {
            UIView.animate(withDuration: 1, animations: {
                self.img2TopConstr.constant = 50
                self.img2BottomConstr.constant = 146
                self.view.layoutIfNeeded()
            })
        }else {
            UIView.animate(withDuration: 1, animations: {
                self.img2TopConstr.constant = 0
                self.img2BottomConstr.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
}
