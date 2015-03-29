package Model 
{
	/**
	 * ...
	 * @author hhg4092
	 */
	public class PlayerModel
	{
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="uuid")]
		public var uuid:int;
		
		[MessageBinding(type="Model.valueObject.StringObject",messageProperty="stringValue",selector="nickname")]
		public var nickName:String;
		
		public function PlayerModel() 
		{
			
		}
		
	}

}