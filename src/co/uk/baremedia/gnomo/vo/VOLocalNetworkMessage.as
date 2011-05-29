package co.uk.baremedia.gnomo.vo
{
	public class VOLocalNetworkMessage
	{
		public var deviceType:String;
		public var roleAsked:String;
		
		public function VOLocalNetworkMessage(roleAsked:String, deviceType:String)
		{
			this.roleAsked 	= roleAsked;
			this.deviceType = deviceType;
		}
	}
}