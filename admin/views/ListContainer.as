package views {
	import com.scrollbar.ScrollBar;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Sorabh
	 */
	public class ListContainer extends MovieClip {
		//elements in flash
		public var mask_mc:MovieClip;
		public var container_mc:MovieClip;
		public var scroll_bar:ScrollBar;
		//
		
		//constructor
		public function ListContainer() {
			container_mc.mask = mask_mc;
			scroll_bar.target = this;
		}
		
		public function set dataProvider(xml:XMLList):void {
			for (var i:int = 0; i < xml.length(); i++) {
				var item:ProItem = new ProItem();
				container_mc.addChild(item);
				item.data = xml[i];
				item.y = item.height * i;
			}
			scroll_bar.updateThumb();
		}
		public function get dataProvider():XMLList {
			var xml:XMLList = new XMLList();
			var i:int = -1; while (++i < container_mc.numChildren) {
				var item:ProItem = container_mc.getChildAt(i) as ProItem;
				xml[i] = (item.data);
			}
			return xml;
		}
		public function addItem(xml:XML):void {
			var item:ProItem = new ProItem();
			container_mc.addChild(item);
			item.data = xml;
			item.y = item.height * (container_mc.numChildren - 1);
			scroll_bar.updateThumb();
		}
		public function updateIndex(index:int):void {
			while (index < container_mc.numChildren) {
				var item:ProItem = container_mc.getChildAt(index) as ProItem;
				item.y = item.height * index;
				item.sn_txt.text = (index + 1).toString();
				index++;
			}
			scroll_bar.updateThumb();
		}
	}
}