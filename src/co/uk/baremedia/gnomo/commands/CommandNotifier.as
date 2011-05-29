package co.uk.baremedia.gnomo.commands
{
	import co.uk.baremedia.gnomo.signals.SignalNotifier;
	import co.uk.baremedia.gnomo.vo.VONotifierInfo;
	
	import org.as3.mvcsc.utils.Tracer;
	import org.robotlegs.mvcs.SignalCommand;

	public class CommandNotifier extends SignalCommand
	{
		[Inject]
		public var notifierInfo:VONotifierInfo;
		
		override public function execute():void
		{
			Tracer.log(this, "execute() - notifierInfo.notificationType: "+notifierInfo.notificationType);
		}
	}
}