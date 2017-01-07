import Cocoa
/*
 * NOTE:  having seperate values: hasStyleChanged and :hasSizeChanged and hasSkinState changed is usefull for optimization
 * TODO: possibly add setPosition();
 * TODO: a sleeker way to refresh the skin is needed for now we use setState(SkinStates.NONE)
 * TODO: look to cssedit which takes priority the htm set width or the css set width?
 */
class Skin:InteractiveView2,ISkin{
    var decoratables:Array<IGraphicDecoratable> = []
    var style:IStyle?
    var state:String
    var width:CGFloat?
    var height:CGFloat?
    var element:IElement?
    var hasStyleChanged:Bool = false
    var hasStateChanged:Bool = false
    var hasSizeChanged:Bool = false
    init(_ style:IStyle? = nil, _ state:String = "", _ element:IElement? = nil){
        self.style = style
        self.state = state
        self.element = element
        width = element!.width//TODO: is this necessary?
        height = element!.height//TODO: is this necessary?
        super.init(frame:NSRect())/*<-this doesnt need a size*/
    }
    /**
     * Required by super class
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     * Resets skinState
     */
    func draw(){
        hasStyleChanged = false
        hasSizeChanged = false
        hasStateChanged = false
        //needsDisplay = true//Refereshes the graphics , THIS IS NEW!!!
    }
    /**
     * Sets the style instance to apply to the skin also forces a redraw.
     * NOTE: this is a great way to update an skin without querying StyleManager
     */
    func setStyle(style:IStyle){
        hasStyleChanged = true
        self.style = style
        draw()
    }
    /**
     * Sets the skin state and forces a redraw
     * NOTE: forces a lookup of the style in the StyleManager, since it has to look for the correct state of the style
     * TODO:rename to set_skinState() and blame swift for the underscore
     * TODO: Optionally rename state to skin_state since state may be used when implementing the NSEffectview for Translucency support
     */
    func setSkinState(state:String){//TODO: I think this method is save to rename back to setState now since ISKin etends class this problem is gone, or is it because skinState is named state?
        hasStateChanged = true
        self.state = state
        style = StyleResolver.style(element!)/*TODO: looping through the entire styleManager isn't a good idea for just a state change, you need some caching system to handle this better*/
        draw()
    }
    /**
    * Sets the width and height of skin also forces a redraw.
    * @Note similar to setStyle, this does not querry the styleManger when called
    */
    func setSize(width:CGFloat, _ height:CGFloat) {
        if(self.width != width || self.height != height){// :TODO: this is probably wrong, since we get width and height from SkinParser.width and SkinParser.height now (since wee need margin and padding in the tot calculation of the sizes)
            hasSizeChanged = true
            self.width = width
            self.height = height
            draw()
        }
    }
    /**
     * Returns the width that is generated by first looking to see if there is a width value in the style, and if that value is percentage then get the width from the parent skin or if there is no width value in style use the _width variable that originated from the construction of the skin
     * NOTE: these methods are an important part of the float system
     */
    func getWidth()->CGFloat{
        return StylePropertyParser.width(self) ?? self.width!//!isNaN(skin.width) ? skin.width : StylePropertyParser.width(skin)
    }
    func getHeight()->CGFloat{
        return StylePropertyParser.height(self) ?? self.height!//!isNaN(skin.height) ? skin.height : StylePropertyParser.height(skin)
    }
}