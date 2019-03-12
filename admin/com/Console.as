package com {
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author sorabh
	 */
	public class Console {
		public static function log(...args):void {
			if(ExternalInterface.available)
				ExternalInterface.call('console.log', args);
			trace(args);
		}
	}
}