import Foundation
class StyleModifier {
    /**
     * Clones a style
     * CSSParser.as, StyleHeritageResolver.as uses this function
     * // :TODO: explain what newSelectors does
     */
    class func clone(style:IStyle, _ newName:String? = nil)->IStyle{
        let returnStyle:IStyle = Style(newName ?? style.name);
        for styleProperty : IStyleProperty in style.styleProperties{
            returnStyle.addStyleProperty(StyleProperty(styleProperty.name, styleProperty.value));
        }
        return returnStyle;
    }
    /**
    *
    */
    class func overrideStyleProperty(inout style:IStyle, _ styleProperty:IStyleProperty){// :TODO: argument should only be a styleProperty
        let stylePropertiesLength:Int = style.styleProperties.count;
        for (var i:Int=0; i<stylePropertiesLength; i++) { // :TODO: use fore each
            if((style.styleProperties[i] as IStyleProperty).name == styleProperty.name){
                style.styleProperties[i] = styleProperty;
                break//was return
            }
        }
        Swift.print("\(String(style))"+" PROPERTY BY THE NAME OF "+styleProperty.name+" WAS NOT FOUND IN THE PROPERTIES ")//this should throw error
    }
    
    /**
    * Combines @param a and @param b
    * @Note: if similar styleProperties are found @param b takes precedence
    * TODO: you can speed this method up by looping with a  better algo. dont check already checked b's etc
    * TODO: maybe use map or filter to speed this up?
    */
    class func combine(inout a:IStyle,_ b:IStyle){
        Swift.print("combining initiated")
        let len:Int = b.styleProperties.count
        for (var i:Int=0; i < len; i++) {
            let stylePropB : IStyleProperty = b.styleProperties[i]
            let matchIndex = Utils.matchAt(a, stylePropB)
            if(matchIndex != -1){//asserts true if styleProperty exist in both styles
                a.styleProperties[matchIndex] = stylePropB//styleProperty already exist so overide it
            }else{
                StyleModifier.append(&a,stylePropB)//doesnt exist so just add the style prop
            }
        }
    }
    /**
    *
    */
    class func merge(){
        //see old code
    }
    /**
    * Adds @param styleProperty to the end of the @param style.styleProperties array
    * @Note will throw an error if a styleProperty with the same name is allready added
    */
    class func append(inout style:IStyle,_ styleProperty:IStyleProperty){
        Swift.print("append happended")
        for styleProp:IStyleProperty in style.styleProperties{
            if(styleProp.name == styleProperty.name) {
                fatalError(String(style) + " STYLE PROPERTY BY THE NAME OF " + styleProperty.name + " IS ALREADY IN THE _styleProperties ARRAY: " + styleProperty.name)//checks if there is no duplicates in the list
            }
        }
        style.styleProperties.append(styleProperty)
    }
}


class Utils{
    private class func matchAt(style:IStyle, _ styleProperty:IStyleProperty)->Int{
        let len = style.styleProperties.count
        for (var i:Int=0; i < len; i++) {
            let styleProp:IStyleProperty = style.styleProperties[i]
            if(styleProperty.name == styleProp.name){
                return i
            }
        }
        return -1
    }
}
