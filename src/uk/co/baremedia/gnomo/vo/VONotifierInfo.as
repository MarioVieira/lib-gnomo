package uk.co.baremedia.gnomo.vo
{
	public class VONotifierInfo
	{
		public function VONotifierInfo(type:String, value:*)
		{
			notificationType 	= type;
			notificationValue 	= value;
		}
		
		public var notificationType		:String;
		public var notificationValue	:Object;
	}
}