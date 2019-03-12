package views
{
	import flash.display.MovieClip;
	import flash.text.TextField;
    
	/**
	 * ...
	 * @author Sorabh
	 */
    dynamic public class SloganText extends MovieClip {
        public var external_txt:TextField;

        public function SloganText() {
            addFrameScript(0, frame1);
        }

        function frame1() {
			try {
				external_txt.htmlText = MovieClip(parent).loadText("promote");
			} catch (e:Error) {
				trace(e);
			}
        }
    }
}