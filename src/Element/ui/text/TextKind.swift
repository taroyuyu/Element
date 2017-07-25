import Cocoa
@testable import Utils

typealias IText = TextKind
protocol TextKind:IElement {
    func setText(_ text:String)
    func getTextField()->NSTextField
    var initText:String{get}
}
extension TextKind{
    var textField:NSTextField{get{return (skin as! ITextSkin).textField}}
    /**
     * Sets text to the textfield, remember to set textformat after
     * NOTE: to access htmlText: ITextSkin2(_skin).textField.htmlText = htmlText;
     * NOTE: Apperently setText() is occupied by obj-c, use var text {get set} in the future
     */
    func setText(_ text:String){//<--- rename to setText, figure out away to either rename the text or rename setText, like setTheText or alike, setTextValue
        (skin as! TextSkin).setText(text)
    }
    /**
     * Returns the textField text and
     */
    func getText()->String{
        return getTextField().stringValue
    }
    func getTextField()->NSTextField{
        return (skin as! ITextSkin).textField
    }
}