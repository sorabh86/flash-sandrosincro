package com.scrollbar 
{
	import com.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Sorabh
	 * target container must set
	 * target container must have two container container_mc and mask_mc
	 * updateThumb function must call on adding item or deleting item in container_mc in target object
	 */
	public class ScrollBar extends MovieClip {
		//element in flash
		public var thumb_mc:MovieClip;
		public var track_mc:MovieClip;
		//
		public var range:Number;
		public var target:Object;
		
		public function ScrollBar() {
			thumb_mc.buttonMode = true;
			thumb_mc.mouseEnabled = true;
			track_mc.buttonMode = true;
			track_mc.mouseEnabled = true;
			
			thumb_mc.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDownHandler);
			track_mc.addEventListener(MouseEvent.MOUSE_DOWN, onTrackDownHandler);
			addEventListener(Event.CHANGE, onUpdateScrollBarHandler);
		}
		
		private function onUpdateScrollBarHandler(e:Event):void {
			target.container_mc.y = -(target.container_mc.height - target.mask_mc.height) * range;
		}
		
		private function onTrackDownHandler(e:MouseEvent):void {
			var nPos:Number = track_mc.mouseY - thumb_mc.height / 2;
			if (nPos > track_mc.height - thumb_mc.height) nPos = track_mc.height - thumb_mc.height;
			if (nPos < 0) nPos = 0;
				
			TweenLite.to(thumb_mc, 0.1, { y:nPos, onUpdate:function():void { onChangeScrollPos(null) }} );
			
			thumb_mc.startDrag(false, new Rectangle(0, 0, 0, track_mc.height-thumb_mc.height));
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onChangeScrollPos);
		}
		
		private function onThumbDownHandler(e:MouseEvent):void {
			thumb_mc.startDrag(false, new Rectangle(0, 0, 0, track_mc.height-thumb_mc.height));
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onChangeScrollPos);
		}
		
		private function onThumbUpHandler(e:MouseEvent):void {
			thumb_mc.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onChangeScrollPos);
		}
		
		private function onChangeScrollPos(e:MouseEvent):void {
			range = thumb_mc.y / (track_mc.height - thumb_mc.height);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function updateThumb():void {
			var itemHeight:Number = target.container_mc.height;
			var maskHeight:Number = target.mask_mc.height;
			if(itemHeight/maskHeight >= 1) {
				thumb_mc.height = track_mc.height / (itemHeight / maskHeight);
				if(thumb_mc.y + thumb_mc.height > track_mc.height)
					thumb_mc.y = track_mc.height - thumb_mc.height;
			} else {
				thumb_mc.height = track_mc.height;
				thumb_mc.y = 0;
			}
			onChangeScrollPos(null);
		}
	}
}