import Foundation
/**
 * NOTE: The reason we use array instead of object: a problem may be that the order will be different every time you read this object, random
 * EXAMPLE: print("StyleManager.getInstance().getStyle(Button): " + StyleManager.getInstance().getStyle("someText").getPropertyNames());//prints style names
 * // :TODO:  Could potentially extend StyleCollection and just implimnet the extra functions in this class?!?
 * // :TODO: This class can be a struct
 */
class StyleManager{
    static var cssFiles:Dictionary<String,String> = [:]
    static var styles:Array<IStyle> = []
    static var styleTree:[String:Any] = [:]
    static var isHashingStyles:Bool = true/*enable this if you want to hash the styles (beta)*/
    /**
     * Adds @param styles to @param styleTree
     */
    static func addStyle(inout styleTree:[String:Any],_ styles:[IStyle]) -> [String:Any]{
        for  style : IStyle in styles{ addStyle(style,&styleTree)}
        return styleTree
    }
    
    
    /**
     * Adds a style to the styleManager class
     * @param style: IStyle
     */
    static func addStyle(style:IStyle){
        styles.append(style)
    }
    /**
     *
     */
    static func removeStyle(name:String) -> IStyle? {
        let numOfStyles:Int = styles.count;
        for (var i : Int = 0; i < numOfStyles; i++){if(styles[i].name == name) {return styles.splice2(i,1)[0]}}
        return nil
    }
    /**
     * Locates and returns a Style by the @param name.
     * @return a Style
     */
    static func getStyle(name:String)->IStyle?{
        let numOfStyles:Int = styles.count;
        for(var i:Int = 0;i < numOfStyles;i++) {if((styles[i] as IStyle).name == name) {return styles[i]}}
        return nil
    }
}
//convenince methods
extension StyleManager{
    /**
     * Adds every style in a styleCollection to the stylemanager
     */
    static func addStyle(styles:Array<IStyle>){
        if(isHashingStyles){styles.forEach{StyleManagerUtils.hashStyle($0)}}
        self.styles += styles/*<- concats*/
    }
    /**
     * Removes styles
     */
    static func removeStyle(styles:Array<IStyle>){
        for style in styles{removeStyle(style.name)}
    }
    /**
     * Adds styles by parsing @param string (the string must comply to the Element css syntax)
     * // :TODO: add support for css import statement in the @param string
     */
    static func addStyle(var cssString:String){
        cssString = CSSLinkResolver.resolveLinks(cssString)
        cssString = RegExpModifier.removeComments(cssString)
        addStyle(/*&styleTree,*/CSSParser.styleCollection(cssString).styles)
    }
    /**
     * Adds styles by parsing a .css file (the css file can have import statements which recursivly are also parsed)
     * PARAM: liveEdit enables you to see css changes while an app is running
     * @Note to access files within the project bin folder use: File.applicationDirectory.url + "assets/temp/main.css" as the url
     */
    static func addStylesByURL(url:String,_ liveEdit:Bool = false) {
        let cssString:String = CSSFileParser.cssString(url)
        if(liveEdit){
            if(cssFiles[url] != nil){/*check if the url already exists in the dictionary*/
                let cssString:String = CSSLinkResolver.resolveLinks(cssFiles[url]!)
                let styles:[IStyle] = CSSParser.styleCollection(cssString).styles
                removeStyle(styles)/*if url exists it does then remove the styles that it represents*/
            }else{/*if the url wasn't in the dictionary, then add it*/
                cssFiles[url] = cssString
            }
        }
        addStyle(cssString)
    }
    static func getStyleAt(index:Int)->IStyle{
        return styles[index]
    }
}
