package views {
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Sorabh
	 */
    dynamic public class ProductText extends MovieClip {
        //element in flash
        public var title_txt:TextField;
        public var desc_txt:TextField;

        public function ProductText() {
            addFrameScript(0, frame1);
        }

        function frame1() {
			try {
				title_txt.htmlText = MovieClip(parent).loadText("title");
				desc_txt.htmlText = MovieClip(parent).loadText("desc");
			} catch (e:Error) {
				trace(e);
			}
        }
    }
}