//
//  ViewController.swift
//  major
//
//  Created by 倉知諒 on 2017/04/08.
//  Copyright © 2017年 kurachi. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var accel_x: UIScrollView!
    @IBOutlet weak var accel_y: UIScrollView!
    @IBOutlet weak var accel_z: UIScrollView!
    
    @IBOutlet weak var speed_x: UIScrollView!
    @IBOutlet weak var speed_y: UIScrollView!
    @IBOutlet weak var speed_z: UIScrollView!
    
    let UPDATEINTERVAL:TimeInterval = 0.1
    let GRAPHDATASLIMIT = 100
    
    var accel_datas_x: [CGFloat] = []
    var accel_datas_y: [CGFloat] = []
    var accel_datas_z: [CGFloat] = []
    
    var speed_datas_x: [CGFloat] = []
    var speed_datas_y: [CGFloat] = []
    var speed_datas_z: [CGFloat] = []
    
    var myMotionManager: CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMotionManager = CMMotionManager()
        
        myMotionManager.accelerometerUpdateInterval = self.UPDATEINTERVAL
        
        
        myMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: {(accelerometerData, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = accelerometerData else {
                return
            }
            
            self.accel_datas_x.append(CGFloat(data.acceleration.x))
            self.accel_datas_y.append(CGFloat(data.acceleration.y))
            self.accel_datas_z.append(CGFloat(data.acceleration.z))
            
            var speed_data_x = CGFloat(data.acceleration.x)
            var speed_data_y = CGFloat(data.acceleration.y)
            var speed_data_z = CGFloat(data.acceleration.z)
            if self.speed_datas_x.endIndex != 0{    speed_data_x = speed_data_x + self.speed_datas_x[self.speed_datas_x.endIndex - 1]}
            if self.speed_datas_y.endIndex != 0{    speed_data_y = speed_data_y + self.speed_datas_y[self.speed_datas_y.endIndex - 1]}
            if self.speed_datas_z.endIndex != 0{    speed_data_z = speed_data_z + self.speed_datas_z[self.speed_datas_z.endIndex - 1]}
            self.speed_datas_x.append(speed_data_x)
            self.speed_datas_y.append(speed_data_y)
            self.speed_datas_z.append(speed_data_z)
            
            if self.accel_datas_x.count > self.GRAPHDATASLIMIT{    self.accel_datas_x.removeFirst()}
            if self.accel_datas_y.count > self.GRAPHDATASLIMIT{    self.accel_datas_y.removeFirst()}
            if self.accel_datas_z.count > self.GRAPHDATASLIMIT{    self.accel_datas_z.removeFirst()}
            if self.speed_datas_x.count > self.GRAPHDATASLIMIT{    self.speed_datas_x.removeFirst()}
            if self.speed_datas_y.count > self.GRAPHDATASLIMIT{    self.speed_datas_y.removeFirst()}
            if self.speed_datas_z.count > self.GRAPHDATASLIMIT{    self.speed_datas_z.removeFirst()}
            
            let accel_x = NSString(format:"%0.4f",round(self.accel_datas_x[self.accel_datas_x.endIndex - 1] * 1000) / 1000)
            let accel_y = NSString(format:"%0.4f",round(self.accel_datas_y[self.accel_datas_y.endIndex - 1] * 1000) / 1000)
            let accel_z = NSString(format:"%0.4f",round(self.accel_datas_z[self.accel_datas_z.endIndex - 1] * 1000) / 1000)
            let speed_x = NSString(format:"%0.4f",round(self.speed_datas_x[self.speed_datas_x.endIndex - 1] * 1000) / 1000)
            let speed_y = NSString(format:"%0.4f",round(self.speed_datas_y[self.speed_datas_y.endIndex - 1] * 1000) / 1000)
            let speed_z = NSString(format:"%0.4f",round(self.speed_datas_z[self.speed_datas_z.endIndex - 1] * 1000) / 1000)
            let log_accel = "accel_x[\(accel_x)],\t accel_y[\(accel_y)],\t accel_z[\(accel_z)]"
            let log_speed = "speed_x[\(speed_x)],\t speed_y[\(speed_y)],\t speed_z[\(speed_z)]"
            print(NSString.localizedStringWithFormat("%@\t%@", log_accel,log_speed))
            
            for view:UIView in self.accel_x.subviews{    view.removeFromSuperview()}
            for view:UIView in self.accel_y.subviews{    view.removeFromSuperview()}
            for view:UIView in self.accel_z.subviews{    view.removeFromSuperview()}
            for view:UIView in self.speed_x.subviews{    view.removeFromSuperview()}
            for view:UIView in self.speed_y.subviews{    view.removeFromSuperview()}
            for view:UIView in self.speed_z.subviews{    view.removeFromSuperview()}
            
            let accel_graphVeiw_x = Graph()
            let accel_graphVeiw_y = Graph()
            let accel_graphVeiw_z = Graph()
            let speed_graphVeiw_x = Graph()
            let speed_graphVeiw_y = Graph()
            let speed_graphVeiw_z = Graph()
            
            accel_graphVeiw_x.lineColor = UIColor.cyan
            accel_graphVeiw_y.lineColor = UIColor.cyan
            accel_graphVeiw_z.lineColor = UIColor.cyan
            speed_graphVeiw_x.lineColor = UIColor.red
            speed_graphVeiw_y.lineColor = UIColor.red
            speed_graphVeiw_z.lineColor = UIColor.red
            
            accel_graphVeiw_x.graphDatas = self.accel_datas_x
            accel_graphVeiw_y.graphDatas = self.accel_datas_y
            accel_graphVeiw_z.graphDatas = self.accel_datas_z
            speed_graphVeiw_x.graphDatas = self.speed_datas_x
            speed_graphVeiw_y.graphDatas = self.speed_datas_y
            speed_graphVeiw_z.graphDatas = self.speed_datas_z
            
            self.accel_x.addSubview(accel_graphVeiw_x)
            self.accel_y.addSubview(accel_graphVeiw_y)
            self.accel_z.addSubview(accel_graphVeiw_z)
            self.speed_x.addSubview(speed_graphVeiw_x)
            self.speed_y.addSubview(speed_graphVeiw_y)
            self.speed_z.addSubview(speed_graphVeiw_z)
            
            self.accel_x.contentSize = CGSize(width:accel_graphVeiw_x.checkWidth() + 20,height:accel_graphVeiw_x.checkHeight())
            self.accel_y.contentSize = CGSize(width:accel_graphVeiw_y.checkWidth() + 20,height:accel_graphVeiw_y.checkHeight())
            self.accel_z.contentSize = CGSize(width:accel_graphVeiw_z.checkWidth() + 20,height:accel_graphVeiw_z.checkHeight())
            self.speed_x.contentSize = CGSize(width:speed_graphVeiw_x.checkWidth() + 20,height:speed_graphVeiw_x.checkHeight())
            self.speed_y.contentSize = CGSize(width:speed_graphVeiw_y.checkWidth() + 20,height:speed_graphVeiw_y.checkHeight())
            self.speed_z.contentSize = CGSize(width:speed_graphVeiw_z.checkWidth() + 20,height:speed_graphVeiw_z.checkHeight())
            
            accel_graphVeiw_x.GraphFrame()
            accel_graphVeiw_y.GraphFrame()
            accel_graphVeiw_z.GraphFrame()
            speed_graphVeiw_x.GraphFrame()
            speed_graphVeiw_y.GraphFrame()
            speed_graphVeiw_z.GraphFrame()
            
            let accel_offset_x: CGPoint = CGPoint(
                x: max(-self.accel_x.contentInset.left, self.accel_x.contentSize.width - self.accel_x.frame.width + self.accel_x.contentInset.right),
                y: self.accel_x.contentOffset.y)
            let accel_offset_y: CGPoint = CGPoint(
                x: max(-self.accel_y.contentInset.left, self.accel_y.contentSize.width - self.accel_y.frame.width + self.accel_y.contentInset.right),
                y: self.accel_y.contentOffset.y)
            let accel_offset_z: CGPoint = CGPoint(
                x: max(-self.accel_z.contentInset.left, self.accel_z.contentSize.width - self.accel_z.frame.width + self.accel_z.contentInset.right),
                y: self.accel_z.contentOffset.y)
            let speed_offset_x: CGPoint = CGPoint(
                x: max(-self.speed_x.contentInset.left, self.speed_x.contentSize.width - self.speed_x.frame.width + self.speed_x.contentInset.right),
                y: self.speed_x.contentOffset.y)
            let speed_offset_y: CGPoint = CGPoint(
                x: max(-self.speed_y.contentInset.left, self.speed_y.contentSize.width - self.speed_y.frame.width + self.speed_y.contentInset.right),
                y: self.speed_y.contentOffset.y)
            let speed_offset_z: CGPoint = CGPoint(
                x: max(-self.speed_z.contentInset.left, self.speed_z.contentSize.width - self.speed_z.frame.width + self.speed_z.contentInset.right),
                y: self.speed_z.contentOffset.y)
            
            self.accel_x.setContentOffset(accel_offset_x, animated: false)
            self.accel_y.setContentOffset(accel_offset_y, animated: false)
            self.accel_z.setContentOffset(accel_offset_z, animated: false)
            self.speed_x.setContentOffset(speed_offset_x, animated: false)
            self.speed_y.setContentOffset(speed_offset_y, animated: false)
            self.speed_z.setContentOffset(speed_offset_z, animated: false)
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

