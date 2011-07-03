package uk.co.baremedia.gnomo.utils
{
	import flash.geom.Rectangle;

	public class Resizer
	{
		public function Resizer(){}
		
		//public static function 
		
		public static function resizeMaintainingAspectRatio(origWidth:Number, origHeight:Number, newHeight:Number, newWidth:Number):Rectangle
		{
			var sizes:Rectangle = new Rectangle();
			var rate:RateVO;
			
			//first we try filling the container width, the height should not exceed the provided height 
			rate = DecreaseIncreaseRate.findRates(origWidth, newWidth);
			sizes.width = Math.round(scaleIt(origWidth, rate));
			sizes.height = Math.round(scaleIt(origHeight, rate));
			
			//if by filling the width the height exceeds the container height we know that we need to fill the heigth
			if(sizes.width > newWidth)
			{
				rate = DecreaseIncreaseRate.findRates(origHeight, newHeight);
				sizes.width = Math.round(scaleIt(origWidth, rate));
				sizes.height = Math.round(scaleIt(origHeight, rate));
			}
			
			return sizes; 		
		}
		
		public static function scaleByAspectRatio(origWidth:Number, origHeight:Number, newHeight:Number = 0, newWidth:Number = 0, rate:RateVO = null):Rectangle
		{
			var sizes:Rectangle = new Rectangle();
			var rate:RateVO;
			var origValue:Number;
			var newValue:Number;
			
			//if no container size is provided, respect either horizontal, or vertical length 			
			if(newHeight == 0)
			{
				origValue = origWidth;
				newValue = newWidth
			}
			else
			{
				origValue = origHeight;
				newValue = newHeight;
			}
			
			rate = (!rate) ? DecreaseIncreaseRate.findRates(origValue, newValue) : rate;
			
			sizes.width = scaleIt(origWidth, rate);
			sizes.height = scaleIt(origHeight, rate);
			
			return sizes;
		}
		
		public static function scaleIt(sizeOrig:Number, rateValues:RateVO):Number
		{
			return (rateValues.increaseNotDecrease) ? sizeOrig + (sizeOrig * rateValues.rate) : sizeOrig - (sizeOrig * rateValues.rate);
		}
	}
}