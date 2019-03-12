package views {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Sorabh
	 */
    dynamic public class MainTimeline extends MovieClip {
		//element in flash
		public var wait_mc:MovieClip;
		
		//
		public var myXML:XML;
        public var curSlide:int;
        public var numSlides:int;
        public var slidesURLs:Array;
        public var pictures:Array;
        public var slideObjects:Array;
        public var fonts:Array;
        public var imageLoader:Loader;
        public var slideCount:int;
        public var objectCount:int;
        public var fontLoader:Loader;
        public var fontCount:int;
        public var numLoadingObjects:int;
        public var counterLoadingObjects:int;
        public var rectangle:Shape;
        public var field1:TextField;
        public var format:TextFormat;
        public var paramObj:Object;
        public var contentsPath:String;
        public var date:Date;
        public var nocache:String;
        public var myLoader:URLLoader;

        public function MainTimeline() {
			stop();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
            
			wait_mc.x = stage.stageWidth / 2 - wait_mc.width / 2;
			wait_mc.y = stage.stageHeight / 2 - wait_mc.height / 2;
			
			addFrameScript(0, frame1, 2, frame3, 281, frame282);
        }

        public function processXML(event:Event) : void {
            myXML = new XML(event.target.data);
            myXML.ignoreWhite = true;
            numSlides = myXML.product.length();
			
            for each (var product:XML in this.myXML.product) {
                var productUrlArr:Array = new Array();
                for each (var object:XML in product.object) {
                    if (object.@type == "picture") {
                        productUrlArr[objectCount] = object.source;
                        objectCount = objectCount + 1;
                    }
                    /*if (object.@type == "text" || object.@type == "textarea") {
                        var _loc_2:Array = object.source.split("face=\"");
                        var i:int = 1;
                        while (i < _loc_2.length) {
                            var _loc_3:Array = _loc_2[i].split("\"");
                            if (fonts.indexOf(_loc_3[0]) < 0) {
                                fonts.push(_loc_3[0]);
                            }
                            i++;
                        }
                    }*/
                }
                if (fonts.indexOf("verdana") < 0) {
                    //fonts.push("verdana");
                }
                slidesURLs[slideCount] = productUrlArr;
                
                slideCount = slideCount + 1;
                numLoadingObjects = numLoadingObjects + objectCount;
                objectCount = 0;
            }
            numLoadingObjects = numLoadingObjects + fonts.length;
            slideCount = 0;
            objectCount = 0;
			
			loadNextFont();
            /*fontLoader = new Loader();
            fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoaded);
            fontLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressListener);
            fontLoader.load(new URLRequest(contentsPath + "fonts/" + fonts[0] + ".swf"));*/
        }

        public function imageLoaded(event:Event) : void {
            if (event.target.content != null) {
                event.target.content.smoothing = true;
            }
            this.slideObjects.push(Loader(event.currentTarget.loader as Loader));
            counterLoadingObjects = counterLoadingObjects + 1;
            loadNextImage();
        }

        public function loadNextImage() : void {
            objectCount = objectCount + 1;
			
            if (objectCount > (slidesURLs[slideCount].length - 1)) {
                objectCount = 0;
                slideCount = slideCount + 1;
                pictures.push(slideObjects);
                slideObjects = new Array();
            }
            if (slideCount > (slidesURLs.length - 1)) {
                if (contentsPath.length > 0) {
                    removeChild(field1);
                    removeChild(rectangle);
                }
				wait_mc.visible = false;
                play();
            } else {
                imageLoader = new Loader();
                imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
                imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressListener);
                imageLoader.load(new URLRequest(contentsPath + slidesURLs[slideCount][objectCount] +
									(contentsPath.length > 0 ? (nocache) : (""))));
            }
        }

        public function progressListener(event:ProgressEvent) : void {
            field1.text = "Loading pictures and fonts, " + counterLoadingObjects + " of " + 
							numLoadingObjects + "  " + int(event.bytesLoaded / event.bytesTotal * 100) + "%";
        }

        public function fontLoaded(e:Event) : void {
            var FontLibrary:Class = e.target.applicationDomain.getDefinition(getQualifiedClassName(e.target.content)) as Class;
            try {
				Font.registerFont(FontLibrary.externalFont);
            } catch (e:Error) {
				trace("navadn " + e.message);
				Font.registerFont(FontLibrary.externalFontBold);
            } catch (e:Error) {
				trace("bold " + e.message);
				Font.registerFont(FontLibrary.externalFontItalic);
            } catch (e:Error) {
				trace("italic " + e.message);
				Font.registerFont(FontLibrary.externalFontBoldItalic);
            } catch (e:Error) {
				trace("boldItalic " + e.message);
            }
			
            counterLoadingObjects = counterLoadingObjects + 1;
            loadNextFont();
        }

        public function loadNextFont():void {
            fontCount = fontCount + 1;
            if (fontCount < fonts.length) {
                fontLoader = new Loader();
                fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoaded);
                fontLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressListener);
                fontLoader.load(new URLRequest(contentsPath + "fonts/" + fonts[fontCount] + ".swf"));
            } else {
                imageLoader = new Loader();
                imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
                imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressListener);
                imageLoader.load(new URLRequest(contentsPath + slidesURLs[0][0] + 
										(contentsPath.length > 0 ? (nocache) : (""))));
            }
        }

        public function nextSlide() : void {
            curSlide = (curSlide + 1);
            if (curSlide == numSlides) {
                curSlide = 0;
            }
        }

        public function getCurSlide() : int {
            return curSlide;
        }

        public function loadPicture(index:int) : Loader {
            return pictures[curSlide][index];
        }

        public function loadText(str:String) : String {
            var str:String = myXML.product[curSlide].object.(@name==str)[0].source;
            return str;
        }

        public function getImageURL(param1:int) : String {
            return myXML.product[curSlide].object[param1].source;
        }

        public function getBackgroundURL() : String {
            return myXML.product[curSlide].@background;
        }

        public function str_replace(param1:String, param2:String, param3:String) {
            var _loc_4:* = param1.split(param2);
            return param1.split(param2).join(param3);
        }

        public function loadBackground() {
            return myXML.product[curSlide].background;
        }

        function frame1() {
            curSlide = -1;
            slidesURLs = new Array();
            pictures = new Array();
            slideObjects = new Array();
            fonts = new Array();
            slideCount = 0;
            objectCount = 0;
            fontCount = 0;
            numLoadingObjects = 0;
            counterLoadingObjects = 1;
            stop();
			
            rectangle = new Shape();
            field1 = new TextField();
            format = new TextFormat();
            paramObj = LoaderInfo(this.root.loaderInfo).parameters;
            contentsPath = paramObj["tempEdit"] ? (String(paramObj["tempEdit"])) : ("");
            date = new Date();
            nocache = "?nocache=" + date.hours + date.minutes + date.seconds + date.milliseconds;
			
            if (contentsPath.length > 0) {
                rectangle.graphics.beginFill(0);
                rectangle.graphics.drawRect(-1000, -1000, 5000, 5000);
                rectangle.graphics.endFill();
                rectangle.alpha = 0.8;
                addChild(rectangle);
				
                field1.x = 10;
                field1.y = 10;
                field1.width = 1280;
                field1.height = 250;
                format.color = 8961006;
                format.size = 20;
                format.font = "Comic Sans MS";
                field1.defaultTextFormat = this.format;
                field1.text = "Loading...";
                addChild(field1);
            }
            myLoader = new URLLoader();
            myLoader.load(new URLRequest(contentsPath + "scenario.xml" + 
								(contentsPath.length > 0 ? (nocache) : (""))));
            myLoader.addEventListener(Event.COMPLETE, processXML);
        }

        function frame3() {
            nextSlide();
        }

        function frame282() {
            gotoAndPlay(3);
        }
    }
}