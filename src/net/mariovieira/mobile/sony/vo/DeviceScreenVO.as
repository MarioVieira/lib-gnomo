package net.mariovieira.mobile.sony.vo
{
	import mx.core.UIComponent;

	[Bindable]
	public class DeviceScreenVO
	{
		public var isDualScreen		:Boolean;
		public var screenCount		:int;
		public var screen1Height	:Number;
		public var screen2Height	:Number;
		public var screen2offSetY	:Number;
		
		public function DeviceScreenVO(isDualScreen:Boolean, screenCount:int = 1, screen1Height:Number = 0, screen2Height:Number = 0, screen2offSetY:Number = 0) 
		{
			this.isDualScreen 		= isDualScreen;
			this.screenCount  		= screenCount;
			this.screen1Height  	= screen1Height;
			this.screen2Height  	= screen2Height;
			this.screen2offSetY  	= screen2offSetY;
		}
	}
}