package uk.co.baremedia.gnomo.utils
{
	/**
	 * @author Mario Vieira
	 */
	public class UtilsDate
	{
		public static function getReabeableDate(stringDate:Number):String
		{
			var date:Date = new Date(stringDate);
			var month:String = (String(date.month).length == 1) ? "0"+String(date.month) : String(date.month);
			return date.date+"/"+month+"/"+String(date.fullYear).substr(2);
		}
		
		public static function getReabeableTime(stringDate:Number):String
		{
			var date:Date = new Date(stringDate);
			var hours:String = (String(date.hours).length == 1) ? "0"+String(date.hours) : String(date.hours);
			var min:String = (String(date.minutes).length == 1) ? "0"+String(date.minutes) : String(date.minutes);
			var sec:String = (String(date.seconds).length == 1) ? "0"+String(date.seconds) : String(date.seconds);
			
			return hours+":"+min+":"+sec;
		}
		
		public static function getReabeableDateAndTime(stringDate:Number):String
		{
			return getReabeableTime(stringDate)  + " - " + getReabeableDate(stringDate);
		}
		
		
		
		public static function getSevenDaysAgoDate() : Date
		{
			var now:Date = new Date();
			now.setTime( now.getTime() - (1000 * 60 * 60 * 24 * 7) );
			
			return now;
		}
		
		public static function getDaysFromNow(numberOfDays:int) : Date
		{
			var now:Date = new Date();
			now.setTime( now.getTime() + (1000 * 60 * 60 * 24 * numberOfDays) );
			
			return now;
		}
		
		public static function getHoursAndDaysFromNow(hoursFromNow:int, daysFromNow:int) : Date
		{
			var now:Date = new Date();
			now.setTime( now.getTime() + (1000 * 60 * 60 * hoursFromNow * daysFromNow) );
			
			return now;
		}
		
		public static function getHoursFromNow(numberOfHours:int) : Date
		{
			var now:Date = new Date();
			now.setTime( now.getTime() + (1000 * 60 * 60 * numberOfHours) );
			
			return now;
		}
		
		public static function getMinutesFromNow(numberOfMinutes:int) : Date
		{
			var now:Date = new Date();
			now.setTime( now.getTime() + (1000 * 60 * numberOfMinutes) );
			
			return now;
		}
		
		public static function getReleaseDate() : Date
		{
			return new Date(Date.UTC(2009, 1, 1, 0, 0, 0, 0 ));
		}
	}
}
