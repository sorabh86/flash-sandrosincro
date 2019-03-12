package views
{
	import com.Console;
	import com.math.MaintainRatio;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Sorabh
	 */
	public class PreviewContainer extends MovieClip {
		//elements in flash
		public var bg_mc:MovieClip;
		public var preloader_mc:MovieClip;
		//
		private var _url:String = "";
		private var loader:Loader
		
		public function PreviewContainer() {
			preloader_mc.visible = false;
		}
		
		public function get url():String {
			return _url;
		}
		public function set url(value:String):void {
			preloader_mc.visible = true;
			_url = value;
			loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler)
		}
		private function onImageLoadComplete(e:Event):void {
			preloader_mc.visible = false;
			var prop:Point = MaintainRatio.getNewRatio(e.currentTarget.content.width, e.currentTarget.content.height,
														bg_mc.width - 3, bg_mc.height - 3);
			addChild(loader);
			loader.width = prop.x;
			loader.height = prop.y;
			loader.x = bg_mc.width / 2 - loader.width / 2;
			loader.y = bg_mc.height / 2 - loader.height / 2;
		}
		private function onIOErrorHandler(e:IOErrorEvent):void {
			Console.log('unable to load image');
		}
	}
}