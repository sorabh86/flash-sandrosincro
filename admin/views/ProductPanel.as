package views {
	import com.Console;
	import com.PM;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sorabh
	 */
	public class ProductPanel extends MovieClip {
		//elements in flash
		public var title_input:TextField;
		public var desc_input:TextField;
		public var price_input:TextField;
		public var discount_input:TextField;
		public var promote_input:TextField;
		
		public var add_btn:SimpleButton;
		public var cancel_btn:SimpleButton;
		
		public var img_uploader:FileUploader;
		public var img_preview_mc:PreviewContainer;
		
		public var bg_uploader:FileUploader;
		public var bg_preview_mc:PreviewContainer;
		
		public var logo_uploader:FileUploader;
		public var logo_preview_mc:PreviewContainer;
		
		//
		private var _activity:String = "add";
		private var _target:Object;
		
		public function ProductPanel(activity:String, target:Object) {
			title_input.text = "";
			desc_input.text = "";
			price_input.text = "";
			discount_input.text = "";
			promote_input.text = "";
			
			_activity = activity;
			_target = target;
			
			if (_activity == 'edit')
				data = _target.data;
			
			add_btn.addEventListener(MouseEvent.CLICK, addEditItemHandler);
			cancel_btn.addEventListener(MouseEvent.CLICK, function():void { PM.remove(); } );
			
			img_uploader.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onImageUploadCompleteHandler);
			bg_uploader.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onImageUploadCompleteHandler);
			logo_uploader.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onImageUploadCompleteHandler);
		}
		
		public function onImageUploadCompleteHandler(e:DataEvent):void {
			var xml:XML = new XML(e.data);
			Console.log(xml.source);
			if (xml.@name == 'product')
				img_preview_mc.url = xml.source;
			else if (xml.@name == 'background')
				bg_preview_mc.url = xml.source;
			else if (xml.@name == 'logo')
				logo_preview_mc.url = xml.source;
		}
		
		private function addEditItemHandler(e:MouseEvent):void {
			if (_activity == "add") {
				_target.addItem(data);
			} else if (_activity == "edit") {
				_target.data = data;
			}
			PM.remove();
		}
		public function set data(xml:XML):void {
			title_input.text = xml.object.(@name == 'title')[0].source;
			desc_input.text = xml.object.(@name == 'desc')[0].source.split('<br/>').join('\r');
			price_input.text = xml.object.(@name == 'price')[0].source;
			discount_input.text = xml.object.(@name == 'discount')[0].source;
			promote_input.text = xml.object.(@name == 'promote')[0].source;
			img_preview_mc.url = xml.object.(@name == 'product')[0].source;
			bg_preview_mc.url = xml.object.(@name == 'background')[0].source;
			logo_preview_mc.url = xml.object.(@name == 'logo')[0].source;
		}
		public function get data():XML {
			return new XML('<product>' +
					'<object name="background" type="picture">'+
						'<source>'+bg_preview_mc.url+'</source>'+
					'</object>'+
					'<object name="logo" type="picture">'+
						'<source>'+logo_preview_mc.url+'</source>'+
					'</object>'+
					'<object name="product" type="picture">'+
						'<source>'+img_preview_mc.url+'</source>'+
					'</object>'+
					'<object name="promote" type="text">'+
						'<source><![CDATA['+promote_input.text+']]></source>'+
					'</object>'+
					'<object name="discount" type="text">'+
						'<source><![CDATA['+discount_input.text+']]></source>'+
					'</object>'+
					'<object name="title" type="text">'+
						'<source><![CDATA['+title_input.text+']]></source>'+
					'</object>'+
					'<object name="desc" type="text">'+
						'<source><![CDATA['+desc_input.text.split('\r').join('<br/>')+']]></source>'+
					'</object>'+
					'<object name="price" type="text">'+
						'<source><![CDATA['+price_input.text+']]></source>'+
					'</object>'+
				'</product>');
		}
	}
}