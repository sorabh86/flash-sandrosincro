package com {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import views.admin;
	
	public class PM {
		public static const POP_ADD:String = "pop_add";
		public static const POP_REMOVE:String = "pop_remove";
		
		public static var content:DisplayObject;
		private static var time:Number = 0.2;
		
		public static function add(item:DisplayObject):void {
			if(content) {
				remove();
				setTimeout(function():void {
						content = item;
						admin.instance.popUpContainer.addChild(content);
						addEffect();
						admin.instance.dispatchEvent(new Event(POP_ADD));
					}, time * 1000);
			} else {
				content = item;
				admin.instance.popUpContainer.addChild(content);
				addEffect();
				admin.instance.dispatchEvent(new Event(POP_ADD));
			}
		}
		
		public static function onResizeHandler(e:Event = null):void {
			if (!content) return;
			content.x = admin.instance.width/2-content.width/2;
			content.y = admin.instance.height / 2 - content.height / 2;
		}
		
		private static function addEffect(e:Event=null):void {
			if(!content) return;
			
			content.x = -content.width;
			content.y = admin.instance.height/2-content.height/2;
			TweenLite.to(content, time, { x:admin.instance.width/2-content.width/2 } );
			TweenLite.to(admin.instance.popUpBG, time, { alpha:0.4 });
		}
		
		private static function removeEffect():void {
			admin.instance.popUpContainer.removeChild(content);
			content = null;
			admin.instance.dispatchEvent(new Event(POP_REMOVE));
		}
		
		public static function remove():void {
			admin.instance.popUpContainer.removeEventListener(Event.RESIZE, onResizeHandler);
			TweenLite.to(content, time, { x:admin.instance.width, onComplete:removeEffect});
			TweenLite.to(admin.instance.popUpBG, time, {alpha:0 });
		}
	}
}