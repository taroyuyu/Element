import Cocoa
@testable import Utils

protocol ISliderList:IList,ISlidable {/*Convenience*/
    func scroll(_ theEvent:NSEvent)
}
extension ISliderList{
    
    //Continue here:
        //move the scroll into Scrollable
    
    
}
class SliderListUtils{
    /**
     * Returns the progress og the sliderList (used when we scroll with the scrollwheel/touchpad)
     */
    static func progress(_ deltaY:CGFloat,_ sliderInterval:CGFloat,_ sliderProgress:CGFloat)->CGFloat{
        let scrollAmount:CGFloat = (deltaY/30)/sliderInterval/*_scrollBar.interval*/
        var currentScroll:CGFloat = sliderProgress - scrollAmount/*The minus sign makes sure the scroll works like in OSX LION*/
        currentScroll = NumberParser.minMax(currentScroll, 0, 1)/*Clamps the num between 0 and 1*/
        return currentScroll
    }
}