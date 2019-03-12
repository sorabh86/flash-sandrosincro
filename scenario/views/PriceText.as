package views
{
	import flash.display.MovieClip;
	import flash.text.TextField;
    
    dynamic public class PriceText extends MovieClip {
		//element in flash
		public var external_txt:TextField;

        public function PriceText() {
            addFrameScript(0, this.frame1);
        }

        function frame1() {
			try {
				external_txt.htmlText = MovieClip(parent).loadText("price");
			} catch (e:Error) {
				trace(e);
			}
        }
    }
}