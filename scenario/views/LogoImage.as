package views {
	import flash.display.Loader;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Sorabh
	 */
    dynamic public class LogoImage extends MovieClip {
		public var default_mc:MovieClip
        public var imageArea:MovieClip;
        public var imageLoader:Loader;

        public function LogoImage() {
            addFrameScript(0, this.frame1);
        }

        function frame1() {
			default_mc.visible = false;
			
			try {
				imageLoader = MovieClip(parent).loadPicture(1);
				imageArea.addChild(imageLoader);
				imageArea.width = 200;
				imageArea.height = 133;
				imageArea.x = 0;
				imageArea.y = 0;
			} catch (e:Error) {
				trace(e);
			}
        }
    }
}