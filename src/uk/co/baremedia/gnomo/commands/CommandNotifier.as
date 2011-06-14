package uk.co.baremedia.gnomo.commands
{
	import uk.co.baremedia.gnomo.vo.VONotifierInfo;
	import uk.co.baremedia.gnomo.interfaces.ICommand;

	public class CommandNotifier implements ICommand
	{
		public function execute(notifierInfo:Object):void
		{
			//Tracer.log(this, "execute() - notifierInfo.notificationType: "+notifierInfo.notificationType);
		}
	}
}