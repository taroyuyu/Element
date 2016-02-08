import Foundation

class TextInput :Element{
    var text : Text?
    var inputTextArea : TextArea?
    var textString:String
    var inputString:String
    init(_ width : CGFloat, _ height : CGFloat, _ textString:String, _ inputString:String, _ parent : IElement? = nil,  id:String? = nil) {
        self.textString = textString
        self.inputString = inputString
        super.init(width, height, parent, id)
    }
    override func resolveSkin() {
        super.resolveSkin();
        //isInteractive = true//<-- only the textField should be interactive
        text = addSubView(Text(0,0,textString,self)) as? Text
        inputTextArea = addSubView(TextArea(0,0,inputString,self)) as? TextArea;
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
