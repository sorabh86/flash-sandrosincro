package views {
	import flash.display.Loader;
	import flash.display.MovieClip;
    
	/**
	 * ...
	 * @author Sorabh
	 */
    dynamic public class ProductImage extends MovieClip {
		public var default_mc:MovieClip;
        public var imageArea:MovieClip;
        public var imageLoader:Loader;

        public function ProductImage() {
            addFrameScript(0, frame1);
        }

        function frame1() {
			default_mc.visible = false;
			
			try {
				imageLoader = MovieClip(parent).loadPicture(2);
				imageArea.addChild(imageLoader);
				imageArea.width = 551;
				imageArea.height = 310;
				imageArea.x = 0;
				imageArea.y = 0;
			} catch (e:Error) {
				trace(e);
			}
        }
    }
}