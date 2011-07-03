package uk.co.baremedia.gnomo.utils
{
	public class DecreaseIncreaseRate
	{
	
		public static function findRates(origValue:Number, newValue:Number):RateVO
	    {
	        var rate:Number;
	        var increase:Boolean;
	        var values:RateVO = new RateVO()
	        
	        if(origValue != newValue)
	        {
	            if(origValue > newValue)
	            {
	                rate = (((origValue - newValue) / origValue) * 1);
	                increase = false;	
	            }
	            else
	            {
	                rate = (((newValue - origValue) / origValue) * 1);
	                increase = true;
	            }
	            
	            if(rate != -1 && rate != false)
	            {
	                values.rate = rate
					values.increaseNotDecrease = increase;
	            }
	        }
	        
	        return values;
	    }
		
		
	}
}