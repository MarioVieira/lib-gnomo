package uk.co.baremedia.gnomo.utils
{
	import org.as3.mvcsInjector.utils.Tracer;
	import org.as3.mvcsInjector.utils.UtilsWriteFile;
	import org.as3.serializer.Serializer;
	import org.as3.serializer.utils.ObjectDescriptor;
	
	import uk.co.baremedia.gnomo.descriptors.DescriptorLanguage;
	
	public class UtilsLocale
	{
		public static function writeLanguageFile(vo:DescriptorLanguage, id:int):void
		{
			Tracer.log(UtilsLocale, "writeLanguageFile - file name: "+ObjectDescriptor.getClassName(vo) + "_" +id.toString());
			UtilsWriteFile.saveUTF8FileToDesktop(ObjectDescriptor.getClassName(vo) + "_" +id.toString(), Serializer.serialize(vo), null, ".xml" );
		}
	}
}