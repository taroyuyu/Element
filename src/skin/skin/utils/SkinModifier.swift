import Cocoa
/**
 * // :TODO: Make the methods more Element cetric less skin centric
 */
class SkinModifier {
    /**
     * Aligns @param view
     */
    class func align(skin:ISkin, _ positional:IPositional,_ depth:Int = 0)->IPositional {
        //Swift.print("SkinModifier.align() positional: " + "\(positional)")
        //var offset:CGPoint = StylePropertyParser.offset(skin,depth);
        //var padding:Padding2 = StylePropertyParser.padding(skin,depth);
        let margin:Margin = StylePropertyParser.margin(skin,depth);
        //var floatType:String = SkinParser.float(skin,depth);
        //if(floatType == CSSConstants.LEFT || floatType == "" || floatType == null) DisplayObjectModifier.position(displayObject, new Point(margin.left + offset.x, margin.top + offset.y));
        //else if(floatType == CSSConstants.RIGHT) DisplayObjectModifier.position(displayObject, new Point(padding.right + margin.right + offset.x, margin.top + padding.top + offset.y));
        //else /*floatType == CSSConstants.NONE*/
        
        positional.setPosition(CGPoint(margin.left/* + offset.x*/, margin.top/* + offset.y*/))// :TODO: this is temp for testing
        return positional
    }
    func float(skin:Skin){
    
    }
}
private class Utils{
    
}