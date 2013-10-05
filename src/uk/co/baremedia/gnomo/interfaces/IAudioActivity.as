package uk.co.baremedia.gnomo.interfaces
{
	import flash.net.NetStream;
	
	import org.robotlegs.core.IInitializer;

	public interface IAudioActivity extends IInitializer
	{
		function get hasBroadcasterAudioActivity():Boolean;
	}
}