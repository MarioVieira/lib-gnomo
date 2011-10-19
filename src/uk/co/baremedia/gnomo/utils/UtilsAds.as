package uk.co.baremedia.gnomo.utils
{
	import uk.co.baremedia.gnomo.enums.EnumsLanguage;
	
	public final class UtilsAds
	{
		public static function getDefaultAdUrl(tests:Boolean):String
		{
			return (tests) ? UtilsResources.getKey(EnumsLanguage.AD_DEFAULT_URL_TEST) : UtilsResources.getKey(EnumsLanguage.AD_DEFAULT_URL);
		}
	}
}