package util.time 
{
	import Date;
	import flash.globalization.DateTimeFormatter;
	/**
	 * time_format
	 * @author hhg4092
	 */
	public class time_format 
	{		
		
		public function time_format() 
		{
			
		}
		
		public static function get_time(data_format:String, shift_days:int = 0, shift_hours:int = 0, shfit_min:int = 0):String		
		{
			var now:Date = new Date();
			now.date += shift_days;
			now.hours += shift_hours;
			now.minutes += shfit_min;
            var dtf:DateTimeFormatter = new DateTimeFormatter("zh-TW");			
            dtf.setDateTimePattern(data_format);
            var str:String = dtf.format(now);   
			//Log("time = " + str);
			
			return str;
		}
	}

}