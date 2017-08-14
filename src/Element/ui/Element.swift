import Cocoa
@testable import Utils
/**
 * This class serves as a base class for the Element GUI framework
 * NOTE: It seems NSViews aren't drawn until their NSView parent gets the drawRect call (Everything is drawn in one go)
 * NOTE: Currently we use InteractiveView, we could complicate things by making it only extend View, but for simplicity we use InteractiveView. (Optimization may be required, thus this may be revocated and maybe we will make a method named InteractiveElement etc.)
 * NOTE: Subclasing over 1 or 2 deep is hard so try to simplify the dependencies !KISS!
 * NOTE: w,h,x,y are stored in the frame instance
 * TODO: ⚠️️ The width,height,x,y could be stored in a deeper super class. As it's not related to Styling per se
 */
protocol Initiable{//consider renaming to Configurable
    var size:CGSize {get set}//eventual size should be let not var
    var parent:ElementKind? {get set}
    var id:String? {get set}
}
protocol InitDecoratable:Initiable{
    var initial:Initiable {get set}
}
extension InitDecoratable{
    var size:CGSize {get{return initial.size}set{initial.size = newValue}}
    var parent:ElementKind? {get{return initial.parent}set{initial.parent = newValue}}
    var id:String? {get{return initial.id}set{initial.id = newValue}}
}
struct Initial:Initiable {var size:CGSize = CGSize(NaN,NaN),parent:ElementKind? = nil,id:String? = nil}
class Element:InteractiveView,ElementKind {
    
    var initial:Initiable//this doesnt need to be exposes subclass will already have it from their init
    //TODO: ⚠️️ move bellow to a deprecated extension
    var width:CGFloat {get{return self.initial.size.width}set{self.initial.size.width = newValue}}
    var height:CGFloat {get{return self.initial.size.height}set{self.initial.size.height = newValue}}
    var parent:IElement? {get{return self.initial.parent}set{self.initial.parent = newValue}}
    var id:String? {get{return self.initial.id}set{self.initial.id = newValue}}/*css selector id, TODO: ⚠️️ Should only be able to be "" not nil*/
    /*State */
    var state:String = SkinStates.none
    var skin:ISkin?//TODO: ⚠️️ make this lazy
    var isDisabled:Bool = false
    var isFocused:Bool = false
    override var frame:CGRect {get{return CGRect(super.frame.x,super.frame.y,width.isNaN ? 0 : width,height.isNaN ? 0 : height)}set{super.frame = newValue}}/*this allows you to store NaN values in the frame, TODO: ⚠️️ Should probably be removed */
    //⚠️️ TODO: deprecate this init
    init(_ width:CGFloat, _ height:CGFloat, _ parent:ElementKind? = nil,_ id:String? = nil){
//        self.parent = parent
        initial = Initial.init(size: CGSize(width,height),parent: parent,id: id)
//        self.id = id
//        self.width = width
//        self.height = height
        super.init(frame: NSRect(0,0,width.isNaN ? 0 : width,height.isNaN ? 0 : height))
        resolveSkin()
    }
    //new,this must be in class because if not subclasses cant reach it
    init(initial:Initiable){
        self.initial = initial
        super.init(frame: NSRect(0,0,initial.size.width.isNaN ? 0 : initial.size.width,initial.size.height.isNaN ? 0 : initial.size.height))
        resolveSkin()
    }
    /**
     * Draws the graphics
     */
    func resolveSkin() {
        self.skin = addSubView(SkinResolver.skin(self))
    }
    /**
     * NOTE: This is the function that we need to toggle between css style sheets and have them applied to all Element instances
     * TODO: ⚠️️ Explain the logic of having this var in this class and also in the skin class, I think its because you need to access the skinstate before the skin is created or initiated in the element.
     */
    func getSkinState() -> String {// :TODO: the skin should have this state not the element object!!!===???
        return state
    }
    /**
     * Sets the current state of the button, which determins the current drawing of the skin
     * NOTE: This can't be moved to an util class, as it may need to be over-ridden
     * NOTE: You cant name this method to setSkinState because this name will be occupied if you have a variable named skinState
     */
    func setSkinState(_ state:String) {
        skin?.setSkinState(state)
    }
    /**
     * Sets the width and height of the skin and this instance.
     */
    func setSize(_ width:CGFloat, _ height:CGFloat) {// :TODO: should probably be set to an abstract fuction returning an error. Maybe not. abstract classes confuses people
        self.width = width//<--I'm not sure these are correct? i get that we have to store size somewhere but frame is such a central variable fro appkit
        self.height = height
        self.skin?.setSize(width, height)
    }
    func getWidth()->CGFloat{
        return skin != nil ? skin!.getWidth() : NaN
    }
    func getHeight()->CGFloat{
        return skin != nil ? skin!.getHeight() : NaN
    }
    /**
     * Returns the class type of the Class instance
     * NOTE: if a class subclasses Element that sub-class will be the class type
     * NOTE: override this function in the first subClass and that subclass will be the class type for other sub-classes
     * NOTE: to return a specific class type: String(TextEditor)
     */
    func getClassType()->String{
        return "\(type(of: self))"
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}/*Required by NSView*/
}
extension Element{
//    convenience 
}
