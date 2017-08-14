import Cocoa
@testable import Utils
/**
 * TODO: ⚠️️ get rid of LableKind
 */
extension TextButton{
    struct TextButtonInitial:InitDecoratable{
        var initial: Initiable = Initial()
        var text:String = ""
    }
}
class TextButton:Button,LableKind {
    lazy var text:Text = self.createText()
    var textString:String {get{return self.initData.text}}/*Interim value*/
    var initData:TextButtonInitial {return super.initial as? TextButtonInitial ?? {fatalError("initial not aviable")}()}
    init(_ width:CGFloat, _ height:CGFloat, _ text:String = "defaultText", _ parent:IElement?, _ id:String? = nil) {
//        textString = text
        let initial = TextButtonInitial.init(initial:Initial(size:CGSize(width,height),parent:parent,id:id), text: text)
        super.init(initial:initial)
    }
    override init(initial: Initiable) {//temp
        super.init(initial: initial)
    }
    override func resolveSkin() {
        super.resolveSkin()
        _ = text
    }
    override func mouseDown(_ event:MouseEvent) {
        super.mouseDown(event)
        Swift.print(ElementParser.stackString(text))
    }
    override func setSkinState(_ skinState:String) {
        super.setSkinState(skinState)
        text.setSkinState(skinState)/*Why is this set directly to the skin and not to the element?, Text doesnt have a setSkin method so i guess thats why?, well it does actually, through it super class Element, so fix this*/
    }
    override func setSize(_ width:CGFloat, _ height:CGFloat) {
        super.setSize(width, height)
        text.setSize(width, height)
    }
    /**
     * Returns the text in the _text.textField.text
     */
    func getText()->String{
        return text.getText()
    }
    /**
     * Sets the text in the _text instance
     * NOTE: cant be named setText as its blocked by objc
     */
    func setTextValue(_ text:String){
        self.text.setText(text)
    }
    required init(coder:NSCoder) {fatalError("init(coder:) has not been implemented")}
}
extension TextButton {
    /**
     * Makes lazy var more organized
     */
    func createText()->Text{
        let text = self.addSubView(Text(self.width,self.height,self.textString,self))
        text.isInteractive = false
        return text
    }
}
