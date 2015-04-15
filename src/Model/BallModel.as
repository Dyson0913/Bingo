package Model 
{
	/**
	 * ...
	 * @author hhg
	 */
	public class BallModel 
	{
		
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="BallNum")]
		public var CurrentBallNum:int;
		
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="best_remain")]
		public var best_remain:int;
		
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="second_remain")]
		public var second_remain:int;
		
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="opened_ball_num")]
		public var opened_ball_num:int;
		
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="best_list")]		
		public var best_list:Array;
		
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="second_list")]		
		public var second_list:Array;
		
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="opened_history")]		
		public var opened_history:Array;
		
		
		public function BallModel() 
		{
			
		}
		
	}

}