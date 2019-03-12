package com.math
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 
	 */
	public class MaintainRatio {
		
		public static function getNewRatio(itemW:Number, itemH:Number, parentW:Number, parentH:Number):Point {
			
			var pt:Point = new Point();
			var parentRatio:Number = parentW / parentH;
			var itemRatio:Number = itemW/itemH;
			if(itemRatio < parentRatio) {
				pt.x = parentH * itemRatio;
				pt.y = parentH;
			} else if(itemRatio > parentRatio) {
				pt.x = parentW;
				pt.y = parentW / itemRatio;
			} else if(itemRatio == parentRatio) {
				pt.x = parentH;
				pt.y = parentW;
			}
			return pt;
		}
		public static function resizeSizeToScale(widthHeight:Point, parent:Object):Point {
			
			var oW:Number = widthHeight.x;
 			var oH:Number = widthHeight.y;
 			
 			var cR:Number = (parent.width - 40) / (parent.height - 40);
			var oR:Number = oW / oH;
			
			var nW:Number;
			var nH:Number;
			
			var scaleW:Number;
			var scaleH:Number;
			
			if(cR > oR) {
				nH = parent.height - 40;
				nW = (oW * nH) / oH;
			} else {
				nW = parent.width - 40;
				nH = (nW * oH) / oW;
			}
			
			scaleW = (nW / oW);
			scaleH = (nH / oH);
			
			return new Point(scaleW, scaleH);
		}
	}
}