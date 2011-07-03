package uk.co.baremedia.gnomo.utils
{
	[Bindable]
	public class SizeVO
	{
		public function SizeVO(width:Number = 0, height:Number = 0, label:String = null)
		{
			this.width = width;
			this.height = height;
			this.label = label;
		}
		
		public var label:String;
	    public var width:Number;
		public var height:Number;
	}
}