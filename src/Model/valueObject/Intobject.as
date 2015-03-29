package Model.valueObject 
{
	/**
	 * ...
	 * @author hhg
	 */
	public class Intobject 
	{
		public var InterValue:int;
		
		[Selector]
		public var selector:String
		
		public function Intobject(ob:int,selec:String) 
		{
			InterValue = ob;
			selector = selec;
		}
		
	}

}