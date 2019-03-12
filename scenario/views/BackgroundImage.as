package views 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Sorabh
	 */
	public dynamic class BackgroundImage extends MovieClip {
		public var default_mc:MovieClip;
        public var imageArea:MovieClip;
        public var imageLoader:Loader;
		
		public function BackgroundImage() {
			addFrameScript(0, frame1);
        }

        function frame1() {
			try {
				default_mc.visible = false;
				imageLoader = MovieClip(parent).loadPicture(0);
				imageArea.addChild(imageLoader);
				imageArea.width = stage.stageWidth;
				imageArea.height = stage.stageHeight;
				imageArea.x = 0;
				imageArea.y = 0;
			} catch (e:Error) {
				trace(e);
			}
        }
	}
}