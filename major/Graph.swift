import UIKit

class Graph: UIView {
    
    let AXISMAX_Y: CGFloat = 10
    
    var lineWidth:CGFloat = 1.0
    var lineColor:UIColor!
    var memoriMargin: CGFloat = 3
    var graphHeight: CGFloat = 180
    var graphDatas: [CGFloat] = []
    
    func GraphFrame(){
        self.backgroundColor = UIColor(red:0.1,  green:0.1,  blue:0.1, alpha:0)
        self.frame = CGRect(x:10 , y:0, width:checkWidth(), height:checkHeight())
    }
    
    //グラフの線を描画
    override func draw(_ rect: CGRect) {
        var count:CGFloat = 0
        let linePath = UIBezierPath()
        linePath.lineWidth = lineWidth
        lineColor.setStroke()
        
        for datapoint in graphDatas {
            if Int(count+1) < graphDatas.count {
                var nowY: CGFloat = datapoint / AXISMAX_Y * graphHeight + graphHeight/2
                nowY = graphHeight - nowY
                
                var nextY: CGFloat = 0
                nextY = graphDatas[Int(count+1)] / AXISMAX_Y * graphHeight + graphHeight/2
                nextY = graphHeight - nextY
                
                if Int(count) == 0 {
                    linePath.move(to: CGPoint(x: count * memoriMargin, y: nowY))
                }
                
                linePath.addLine(to: CGPoint(x: (count+1) * memoriMargin, y: nextY))
            }
            count += 1
        }
        linePath.stroke()
    }
    
    //グラフ横幅を算出
    func checkWidth() -> CGFloat{
        return CGFloat(graphDatas.count-1) * memoriMargin
    }
    
    //グラフ縦幅を算出
    func checkHeight() -> CGFloat{
        return graphHeight
    }
    
}
