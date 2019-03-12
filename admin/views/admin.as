package views {
	import com.Console;
	import com.PM;
	import com.util.Base64;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author Sorabh
	 */
	public class admin extends MovieClip {
		//singleton
		public static var instance:admin;
		
		//elements in flash
		public var panel_mc:MovieClip;
		public var list_mc:ListContainer;
		public var add_btn:SimpleButton;
		public var save_btn:SimpleButton;
		public var popUpBG:MovieClip;
		public var popUpContainer:MovieClip;
		public var wait_mc:MovieClip;
		//
		public var saveURL:String;
		public var actionUrl:String;
		public var xmlUrl:String;
		
		//constructor
		public function admin() {
			instance = this;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			if (Security.sandboxType == Security.LOCAL_TRUSTED) {
				saveURL = "http://localhost.www/Freelancer/sandrosincro/admin/bin/save.php";
				actionUrl = "http://localhost.www/Freelancer/sandrosincro/admin/bin/upload.php";
				xmlUrl = "scenario.xml";
			} else {
				saveURL = "save.php";
				actionUrl = 'upload.php';
				xmlUrl = "scenario.xml?r=" + Math.random();
			}
			
			var date:Date = new Date();
			var year:int = date.fullYearUTC;
			var month:int = date.monthUTC;
				
			/*if(year <= 2012 && month <= 10) {*/
				add_btn.addEventListener(MouseEvent.CLICK, onAddItemClickHandler);
				save_btn.addEventListener(MouseEvent.CLICK, onSaveBtnClickHandler);
				addEventListener(PM.POP_ADD, function():void { popUpBG.visible = true; } );
				addEventListener(PM.POP_REMOVE, function():void { popUpBG.visible = false; } );
				loadXML();
				drawPopUpBG();
			/*}*/
		}
		
		private function drawPopUpBG(isShow:Boolean = false):void {
			popUpContainer.mouseEnabled = false;
			popUpContainer.graphics.clear();
			popUpContainer.graphics.beginFill(0x000000, 0);
			popUpContainer.graphics.drawRect(0, 0, this.width, this.height);
			popUpContainer.graphics.endFill();
			
			popUpBG.graphics.clear();
			popUpBG.graphics.beginFill(0x000000, 0.6);
			popUpBG.graphics.drawRect(0, 0, this.width, this.height);
			popUpBG.graphics.endFill();
			
			popUpBG.visible = isShow;
		}
		
		private function onAddItemClickHandler(e:MouseEvent):void {
			var productPanel:ProductPanel = new ProductPanel('add', list_mc);
			PM.add(productPanel);
		}
		private function onSaveBtnClickHandler(e:MouseEvent):void {
			var xml:XML = new XML(<data />);
			xml.appendChild(list_mc.dataProvider);
			var encript:String = Base64.encode(xml);
			
			var decript:String = Base64.decode(encript);
			//Console.log(encript);
			//Console.log(decript);
			
			var urlVar:URLVariables = new URLVariables();
			urlVar.data = encript;
			
			var req:URLRequest = new URLRequest(saveURL);
			req.data = urlVar;
			req.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader(req);
			urlLoader.addEventListener(Event.COMPLETE, onSaveComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorHandler);
			
			wait_mc.visible = true;
		}
		private function onSaveComplete(e:Event):void {
			//Console.log(e.currentTarget.data);
			wait_mc.visible = false;
		}
		private function onIoErrorHandler(e:IOErrorEvent):void {
			trace('io error:' + e);
		}
		
		private function loadXML():void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(xmlUrl));
			urlLoader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		private function onLoadComplete(e:Event):void {
			wait_mc.visible = false;
			var xml:XML = new XML(e.currentTarget.data);
			list_mc.dataProvider = xml.product;
		}
		
		/****** override ********/
		override public function get width():Number {
			return stage.stageWidth;
		}
		override public function get height():Number {
			return stage.stageHeight;
		}
	}
}