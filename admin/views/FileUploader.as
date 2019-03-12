package views
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Sorabh
	 */
	public class FileUploader extends MovieClip {
		//elements in flash
		public var browse_btn:SimpleButton;
		public var upload_btn:SimpleButton;
		//
		public var file:FileReference;
		public var type:String;
		//
		
		public function FileUploader() {
			browse_btn.addEventListener(MouseEvent.CLICK, doBrowse);
			upload_btn.addEventListener(MouseEvent.CLICK, doUpload);
			
			enabledIt(upload_btn, false);
		}
		
		public function doBrowse(e:MouseEvent):void {
			file = new FileReference();
			file.browse([getImageTypeFilter()]);
			//listeners
			file.addEventListener(Event.COMPLETE, completeHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
		}
		private function getImageTypeFilter():FileFilter {
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
		private function completeHandler(e:Event):void {
			trace("completeHandler: " + e);
		}
		private function ioErrorHandler(e:IOErrorEvent):void {
			trace("ioErrorHandler: " + e);
		}
		private function progressHandler(e:ProgressEvent):void {
			var file:FileReference = FileReference(e.target);
			trace("progressHandler name=" + file.name + " bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
		}
		private function selectHandler(e:Event):void {
			var file:FileReference = FileReference(e.target);
			
			enabledIt(upload_btn, true);
			enabledIt(browse_btn, false);
		}
		private function doUpload(e:MouseEvent):void {
			var variable:URLVariables = new URLVariables();
			
			if (this.name == "img_uploader")
				variable.type = 'product';
			else if ( this.name == "bg_uploader")
				variable.type = 'background';
			else if (this.name == "logo_uploader")
				variable.type = 'logo';
			
			var urlRequest:URLRequest = new URLRequest(admin.instance.actionUrl);
			urlRequest.data = variable;
			urlRequest.method = URLRequestMethod.POST;
			
			file.upload(urlRequest, "Filedata", false);
			enabledIt(upload_btn, false);
			admin.instance.wait_mc.visible = true;
		}
		private function uploadCompleteDataHandler(e:DataEvent):void {
			trace('data complete:' + e.data);
			dispatchEvent(e);
			admin.instance.wait_mc.visible = false;
			
			enabledIt(browse_btn, true);
			enabledIt(upload_btn, false);
		}
		
		public static function enabledIt(item:Object, value:Boolean):void {
			item.mouseEnabled = value;
			item.alpha = value?1:0.5;
		}
	}
}