import Cocoa
@testable import Utils

/**
 * TODO: Continue adding methods here
 */
extension IList {
    /*Parsers*/
    var selected:ISelectable?{fatalError("not implemented yet")}/*Convenience*/
    var selectedIndex:Int{return 0}/*Convenience*/
    //var itemsHeight:CGFloat {fatalError("not implemented yet")}/*Convenience*/
    /*Modifiers*/
    func selectAt(_ index:Int){/*convenience*/
        fatalError("not implemented yet")
    }
    var dp:DataProvider {return self.dataProvider}/*convenience*/
    var itemsHeight: CGFloat {return dp.count * itemHeight}//👈 new
    
}
