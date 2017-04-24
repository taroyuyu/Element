import Cocoa
@testable import Utils

class SelectModifier {
    /**
     * Unselects all in PARAM: items except PARAM: target
     */
    static func unSelectAllExcept(_ exceptionItem:ISelectable, _ selectables:[ISelectable]) {// :TODO: refactor this function// :TODO: rename to unSelectAllExcept
        selectables.forEach{
            if $0 !== exceptionItem && $0.getSelected() {
                $0.setSelected(false)
            }
        }
    }
    static func selectAll(_ selectables:[ISelectable],_ isSelected:Bool = true) {
        selectables.forEach{$0.setSelected(isSelected)}
    }
    static func unSelectAllExceptThese(_ selectables:[ISelectable], exceptions:[ISelectable]) {
        let unSelectedItems:[ISelectable] = ArrayParser.difference(selectables, exceptions)
        for unSelectedItem in unSelectedItems {if(unSelectedItem.getSelected()){unSelectedItem.setSelected(false)}}
        for selectedItem in exceptions { 
            if(!selectedItem.getSelected()) {
                selectedItem.setSelected(true)
            }
        }
    }
    /**
     * Selects all selectables within a range (from, to)
     * // :TODO: use the Range class here!?!?
     */
    static func selectRange(_ selectables:[ISelectable], _ from:Int, _ to:Int,_ isSelected:Bool = true) {
        for i in from...to{//swift 3 support, was-> for (var i : Int = from; i <= to; i++) {
            let selectable:ISelectable = selectables[i]
            if(!selectable.getSelected()) {
                selectable.setSelected(isSelected)
            }
        }
    }
}
extension SelectModifier{
    /**
     * Supports NSView
     */
    static func unSelectAllExcept(_ exceptionItem:ISelectable, _ view:NSView){
        let selectables:[ISelectable] = SelectParser.selectables(view)
        unSelectAllExcept(exceptionItem,selectables)
    }
    static func selectAll(_ view:NSView,_ isSelected:Bool = true) {
        view.subviews.filter() {$0 is ISelectable}.forEach{($0 as! ISelectable).setSelected(isSelected)}
    }
}
