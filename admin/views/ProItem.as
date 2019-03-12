package views
{
	import com.PM;
	import com.TweenLite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sorabh
	 */
	public class ProItem extends MovieClip {
		//elements in flash
		public var sn_txt:TextField;
		public var title_txt:TextField;
		public var desc_txt:TextField;
		public var price_txt:TextField;
		public var discount_txt:TextField;
		public var up_btn:SimpleButton;
		public var down_btn:SimpleButton;
		public var edit_btn:SimpleButton;
		public var del_btn:SimpleButton;
		//
		private var bgURL:String = "";
		private var logoURL:String = "";
		private var productURL:String = "";
		private var promoteText:String = "";
		
		public function ProItem() {
			up_btn.addEventListener(MouseEvent.CLICK, onUpBtnClickHandler);
			down_btn.addEventListener(MouseEvent.CLICK, onDownBtnClickHandler);
			edit_btn.addEventListener(MouseEvent.CLICK, onEditClickHandler);
			del_btn.addEventListener(MouseEvent.CLICK, onDeleteClickHandler);
		}
		
		private function onDeleteClickHandler(e:MouseEvent):void {
			var removeIndex:int = this.parent.getChildIndex(this);
			this.parent.removeChild(this);
			admin.instance.list_mc.updateIndex(removeIndex);
		}
		private function onEditClickHandler(e:MouseEvent):void {
			var productPanel:ProductPanel = new ProductPanel('edit', this);
			PM.add(productPanel);
		}
		private function onDownBtnClickHandler(e:MouseEvent):void {
			var curIndex:int = this.parent.getChildIndex(this);
			var newIndex:int = curIndex + 1;
			if (newIndex > parent.numChildren-1) newIndex = parent.numChildren-1;
			parent.setChildIndex(this, newIndex);
			
			var yPre:Number = this.y;
			var yNew:Number = parent.getChildAt(curIndex).y;
			TweenLite.to(this, 0.2, { y:yNew } );
			TweenLite.to(parent.getChildAt(curIndex), 0.2, { y:yPre } );
			sn_txt.text = (parent.getChildIndex(this) + 1).toString();
			Object(parent.getChildAt(curIndex)).sn_txt.text = (parent.getChildIndex(parent.getChildAt(curIndex)) +1).toString();
		}
		private function onUpBtnClickHandler(e:MouseEvent):void {
			var curIndex:int = this.parent.getChildIndex(this);
			var newIndex:int = curIndex - 1;
			if (newIndex <= 0) newIndex = 0;
			parent.setChildIndex(this, newIndex);
			
			var yPre:Number = this.y;
			var yNew:Number = parent.getChildAt(curIndex).y;
			TweenLite.to(this, 0.2, { y:yNew } );
			TweenLite.to(parent.getChildAt(curIndex), 0.2, { y:yPre } );
			sn_txt.text = (parent.getChildIndex(this) + 1).toString();
			Object(parent.getChildAt(curIndex)).sn_txt.text = (parent.getChildIndex(parent.getChildAt(curIndex)) +1).toString();
		}
		public function set data(value:XML):void {
			sn_txt.text = String(this.parent.getChildIndex(this)+1);
			
			if (!value.object) return;
			
			bgURL = value.object.(@name == 'background')[0].source;
			logoURL = value.object.(@name == 'logo')[0].source;
			productURL = value.object.(@name == 'product')[0].source;
			
			promoteText = value.object.(@name == 'promote')[0].source;
			
			title_txt.text = value.object.(@name == 'title')[0].source;
			desc_txt.text = value.object.(@name == 'desc')[0].source.split('<br/>').join('\r');
			price_txt.text = value.object.(@name == 'price')[0].source;
			discount_txt.text = value.object.(@name == 'discount')[0].source;
		}
		public function get data():XML {
			var xml:XML = <product />;
			xml.object[0] = new XML(<object name="background" type="picture"/>);
			xml.object[0].source = bgURL;
			
			xml.object[1] = new XML(<object name="logo" type="picture"/>);
			xml.object[1].source = logoURL;
			
			xml.object[2] = new XML(<object name="product" type="picture"/>);
			xml.object[2].source = productURL;
			
			xml.object[3] = new XML(<object name="promote" type="text"/>);
			xml.object[3].source = new XML("<source><![CDATA[" + promoteText + "]]\></source>");
			
			xml.object[4] = new XML(<object name="discount" type="text"/>);
			xml.object[4].source = new XML("<source><![CDATA[" + discount_txt.text + "]]\></source>");
			
			xml.object[5] = new XML(<object name="title" type="text"/>);
			xml.object[5].source = new XML("<source><![CDATA[" + title_txt.text + "]]\></source>");
			
			xml.object[6] = new XML(<object name="desc" type="text"/>);
			xml.object[6].source = new XML("<source><![CDATA[" + desc_txt.text.split('\r').join('<br/>') + "]]\></source>");
			
			xml.object[7] = new XML(<object name="price" type="text"/>);
			xml.object[7].source = new XML("<source><![CDATA[" + price_txt.text + "]]\></source>");
			return xml;
		}
	}
}