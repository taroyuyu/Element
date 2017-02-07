import Cocoa
@testable import Utils
/**
 * Try to make SwitchSlider and SwitchCheckButton and SwitchButton, with each having seperate parts of the Component logic. Inspired by CheckButton,HSlider and Button, but less complex
 */
class DEPRECATEDSwitch:HSlider,ICheckable{
    var thumbAnimator:Animator?
    var bgAnimator:Animator?
    var progressAnimator:Animator?
    var bgProgressAnimator:Animator?
    let green:NSColor = NSColorParser.nsColor(UInt(0x39D149))
    let grey:NSColor = NSColorParser.nsColor(UInt(0xDCDCDC))
    var offColor:NSColor = NSColor.white
    var disableMouseUp:Bool = false
    //var tempThumbWidth:CGFloat
    //override var thumbWidth:CGFloat {get{return thumb?.getWidth() ?? 0}set{_ = newValue}}
    private var isChecked:Bool
    init(_ width:CGFloat, _ height:CGFloat, _ thumbWidth:CGFloat = NaN,_ isChecked:Bool = false, _ parent:IElement? = nil, _ id:String? = nil, _ classId:String? = nil) {
        //self.tempThumbWidth = thumbWidth.isNaN ? height:thumbWidth
        self.isChecked = isChecked
        Swift.print("isChecked: " + "\(isChecked)")
        super.init(width,height,thumbWidth,isChecked ? 1:0,parent,id)
    }
    override func createThumb() {
        thumb = addSubView(SwitchButton(thumbWidth, height,self))
        Swift.print("isChecked: " + "\(isChecked)")
        setProgressValue(isChecked ? 1:0)
    }
    let initW:CGFloat = 140
    //let endW:CGFloat = 140 - 80
    let initH = 80
    let initFillet = 40
    let initOffsetX = 140/2
    let initOffsetY = 80/2
    /**
     * Progress changes from 0 - 1
     */
    func interpolateColor(_ value:CGFloat){
        let progress = value.clip(0,1)//avoids bounce
        /*bg*/
        let sizeMultiplier = 1 - progress//we need values from 1 to 0
        let style:IStyle = StyleModifier.clone(skin!.style!,skin!.style!.name)/*We clone the style so other Element instances doesnt get their style changed aswell*/// :TODO: this wont do if the skin state changes, therefor we need something similar to DisplayObjectSkin
        var widthProp = style.getStyleProperty("width",1)
        widthProp!.value = initW * sizeMultiplier//CGFloatParser.interpolate(initW,0,progress)
        var heightProp = style.getStyleProperty("height",1)
        heightProp!.value = initH * sizeMultiplier
        var cornerRadiusProp = style.getStyleProperty("corner-radius",1)
        cornerRadiusProp!.value = initFillet * sizeMultiplier
        var offsetProp = style.getStyleProperty("offset",1)//center align the scaling of the white bg graphic
        offsetProp!.value = [initOffsetX * progress, initOffsetY * progress]
        skin!.setStyle(style)/*updates the skin*/
        
        
        
        /*if(styleProperty != nil){//temp
         let color:NSColor = offColor.blended(withFraction: progress, of: green)!
         styleProperty!.value = color
         
         }*/
        
        /*Thumb*/
        let thumbStyle:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var thumbStyleProperty = thumbStyle.getStyleProperty("line",1) /*edits the style*/
        if(thumbStyleProperty != nil){//temp
            let color:NSColor = grey.blended(withFraction: progress, of: green)!
            thumbStyleProperty!.value = color
            thumb!.skin!.setStyle(thumbStyle)/*updates the skin*/
        }
    }
    override func onThumbMove(event:NSEvent) -> NSEvent{
        //let event = super.onThumbMove(event: event)
        self.progress = HSliderUtils.progress(event.localPos(self).x, tempThumbMouseX, width, thumbWidth)
        //Swift.print("onThumbMove() progress: " + "\(progress)")
        //interpolateColor()
        
        if(progress == 1 && !isChecked){
            setChecked(true)
            disableMouseUp = true
        }else if(progress == 0 && isChecked){
            setChecked(false)
            disableMouseUp = true
        }
        return event
    }
    override func onThumbDown() {
        super.onThumbDown()
        Swift.print("onThumbDown: isChecked: " + "\(isChecked)")
        let style:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var widthProp = style.getStyleProperty("width",1)
        widthProp!.value = 80
        var marginProp = style.getStyleProperty("margin-left",1) /*edits the style*/
        marginProp!.value = progress == 1 ? 20  : 0
        thumb!.skin!.setStyle(style)/*updates the skin*/
        
        /*Thumb Anim*/
        if(thumbAnimator != nil){thumbAnimator!.stop()}
        thumbAnimator = Animator(Animation.sharedInstance,0.2,0,1,thumbAnim,Linear.ease)
        thumbAnimator!.start()
        
        /*bg Anim*/
        
        if(bgAnimator != nil){bgAnimator!.stop()}
        bgAnimator = Animator(Animation.sharedInstance,0.4,0,1,bgAnim,Linear.ease)
        bgAnimator!.start()
        
        interpolateColor(progress)//ticks the thumb line to be the correct color, or else the line would be derived from css
    }
    /**
     * NOTE: We need to get the event after mouseUpEvent, which is either upInside or upOutside. 
     * NOTE: If we use up event then another call gets made to the style and the properties we set doesn't attach, this is a bug
     * NOTE: onThumbUp is fired before ..inside and ...outside, thats why this method exists, it fires after
     */
    func onThumbUpAfter() {
        let style:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        
        var lineProp = style.getStyleProperty("line",1)
        lineProp!.value = isChecked ? green : grey
        
        var widthProp = style.getStyleProperty("width",1)
        widthProp!.value = 100
        var marginProp = style.getStyleProperty("margin-left",1) /*edits the style*/
        marginProp!.value = 0
        
        /**/
        thumb!.skin!.setStyle(style)/*updates the skin*/
        /*Thumb Anim*/
        if(thumbAnimator != nil){thumbAnimator!.stop()}
        thumbAnimator = Animator(Animation.sharedInstance,0.2,1,0,thumbAnim,Linear.ease)
        thumbAnimator!.start()
        
        /*Bg Anim*/
        if(progress == 0){//must be in off state
            if(bgAnimator != nil){bgAnimator!.stop()}
            bgAnimator = Animator(Animation.sharedInstance,0.4,1,0,bgAnim,Linear.ease)
            bgAnimator!.start()
        }else{
            offColor = NSColor.red//temp fix
        }
    }
    /**
     *
     */
    func onThumbUpInside(){
        Swift.print("onThumbUpInside isChecked: " + "\(isChecked)")
        onThumbUpAfter()
        
        //don't setChecked if progress threshold has been crossed: 0.5
        
        if(!disableMouseUp){
            setChecked(!isChecked)
        }
        disableMouseUp = false//reset
    }
    /**
     *
     */
    func onThumbUpOutside(){
        Swift.print("onThumbUpOutside isChecked: " + "\(isChecked)")
        onThumbUpAfter()
        disableMouseUp = false//reset
    }
    func bgAnim(value:CGFloat){
        Swift.print("bgAnim: " + "\(value)")
        
        let style:IStyle = StyleModifier.clone(skin!.style!,skin!.style!.name)/*we clone the style so other Element instances doesnt get their style changed aswell*/// :TODO: this wont do if the skin state changes, therefor we need something similar to DisplayObjectSkin
        var fillProp = style.getStyleProperty("fill",1) /*edits the style*/
        //let curColor:NSColor = fillProp!.value as! NSColor
        if(isChecked){
            Swift.print("initColor : grey")
            Swift.print("endColor : grey")
        }else{
            Swift.print("initColor : white")
            Swift.print("endColor : grey")
        }
        let initColor = isChecked ? grey : NSColor.white
        let endColor = isChecked ? NSColor.white : grey
        offColor = initColor.blended(withFraction: value, of: endColor)!
        fillProp!.value = offColor
        skin!.setStyle(style)
        //continue here:
            //set some print flags and figure it out
    }
    func thumbAnim(value:CGFloat){
        //Swift.print("thumbAnim: " + "\(value)")
        let style:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var marginProp = style.getStyleProperty("margin-left",1) /*edits the style*/
        marginProp!.value = isChecked ? 20 * (1-value) : 0
        var widthProp = style.getStyleProperty("width",1)
        widthProp!.value = 80 + (20 * value)
        //Swift.print("thumbStyleProperty!.value: " + "\(thumbStyleProperty!.value)")
        thumb!.skin!.setStyle(style)
    }
    func progressAnim(value:CGFloat){
        //Swift.print("progressAnim.value: " + "\(value)")
        setProgressValue(value)//moves the thumb
        
    }
    /**
     *
     */
    func bgProgressAnim(value:CGFloat){
        interpolateColor(value)
    }
    
    override func onEvent(_ event:Event) {
        //Swift.print("\(self.dynamicType)" + ".onEvent() event: " + "\(event)")
        if(event.origin === thumb && event.type == ButtonEvent.upInside){onThumbUpInside()}
        else if(event.origin === thumb && event.type == ButtonEvent.upOutside){onThumbUpOutside()}
        super.onEvent(event)/*forward events, or stop the bubbeling of events by commenting this line out*/
    }
    /**
     * PARAM: progress (0-1)
     */
    override func setProgressValue(_ progress:CGFloat){/*Can't be named setProgress because of objc*/
        Swift.print("progress: " + "\(progress)")
        //We dont want to clip the progress, because we want the bounceBack anim
        self.progress = progress//.clip(0,1)/*If the progress is more than 0 and less than 1 use progress, else use 0 if progress is less than 0 and 1 if its more than 1*/
        thumb!.x = HSliderUtils.thumbPosition(self.progress, width, thumbWidth)
        //thumb?.applyOvershot(progress)/*<--We use the unclipped scalar value*/
    }
    /**
     * Sets the self.isChecked variable (Toggles between two states)
     */
    func setChecked(_ isChecked:Bool) {
        Swift.print("setChecked: " + "\(isChecked)")
        if(progressAnimator != nil){progressAnimator!.stop()}
        if(bgProgressAnimator != nil){bgProgressAnimator!.stop()}
        if(self.isChecked && !isChecked){
            progressAnimator = Animator(Animation.sharedInstance,0.5,1,0,progressAnim,Back.easeOut)/*Animate setProgress from 1 - 0*/
            bgProgressAnimator = Animator(Animation.sharedInstance,0.2,1,0,bgProgressAnim,Quad.easeOut)/*Animate setProgress from 1 - 0*/
        }else if (!self.isChecked && isChecked){
            progressAnimator = Animator(Animation.sharedInstance,0.5,0,1,progressAnim,Back.easeOut)/*Animate setProgress from 0 - 1*/
            bgProgressAnimator = Animator(Animation.sharedInstance,0.3,0,1,bgProgressAnim,Quad.easeOut)/*Animate setProgress from 0 - 1*/
        }
        progressAnimator!.start()
        bgProgressAnimator!.start()
        self.isChecked = isChecked
        //setSkinState(getSkinState())
    }
    func getChecked() -> Bool {
        return isChecked
    }
    override func getSkinState() -> String {
        return isChecked ? SkinStates.checked + " " + super.getSkinState() : super.getSkinState()
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}

/*
 if(progress < 0.5 && isChecked){
 setChecked(false)//set disable
 }else if(progress > 0.5 && !isChecked){
 setChecked(true)//set enable
 }*/

class SwitchButton:Button{
    override func mouseDown(_ event: MouseEvent) {
        super.mouseDown(event)
    }
    override func mouseUp(_ event: MouseEvent) {
        super.mouseUp(event)
    }
    override func mouseUpInside(_ event: MouseEvent) {
        super.mouseUpInside(event)
    }
    /*override func getClassType() -> String {
     return "\(Button.self)"
     }*/
}