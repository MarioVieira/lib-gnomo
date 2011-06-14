package uk.co.baremedia.gnomo.roles
{
	import uk.co.baremedia.gnomo.enums.EnumsLocalNetwork;
	
	public class RolesReceiver
	{
		public static function canClaimReceiverRole(clientDeviceType:String, broadcasterDeviceType:String, forceAccept:Boolean = true):Boolean
		{
			//for debugging
			if(forceAccept) return forceAccept;
			
			//mobiles can always receive 
			if(clientDeviceType == EnumsLocalNetwork.TYPE_MOBILE)
			{
				return true;
			}
				//PCs can only receive from Mobiles, never form PCs (else users can have a PC to PC 4 free)
			else if(clientDeviceType == EnumsLocalNetwork.TYPE_PC)
			{
				return (broadcasterDeviceType == EnumsLocalNetwork.TYPE_MOBILE);
			}
			
			return false;
		}
	}
} 