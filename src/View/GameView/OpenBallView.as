package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import View.componentLib.ViewBase.ViewBase;
	
	import View.InterFace.IVew;
	import View.componentLib.util.utilFun;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class OpenBallView extends ViewBase 
	{
		
		public var OpenBall:MovieClip;
		
		public var WinHint:MovieClip;
		public var SwitchPan:MovieClip;		
		public var OpenBallList:Array = [];
		public var Open3BallList:Array = [];
		
		public var DynamicArea:MovieClip;
		public var BestPanContainer:MovieClip;
		
		public var BallPan:MovieClip;
		
		public function OpenBallView()  
		{
			
		}
		
		[MessageHandler(selector="Enter")] 
		override public function EnterView(View:ViewState):void
		{
			if (View._view != ViewState.openball) return;
			//清除前一畫面
			
			//OpenBallList.length = 0;
			//Open3BallList.length = 0;
			
			//載入新VIEW
			OpenBall = utilFun.GetClassByString("BallView");
			addChild(OpenBall);
			
			WinHint = OpenBall["BingCongratulation"];
			WinHint.visible = false;
			
			var mc:MovieClip = OpenBall["CurrentOpenBall"];
			mc.visible = false;
			
			//動態區畫面
			DynamicArea = OpenBall["DynamicArea"];
			BallPan = utilFun.GetClassByString("AllBallPan");
			DynamicArea.addChild(BallPan);
			
			BestPanContainer = OpenBall["BestPan"];
			utilFun.ClearContainerChildren(BestPanContainer);
			
			//存入betmodel,好處理
			//var arr:Array = betModel.GetBetTableNo();
			//for (var i:int = 0; i < arr.length; i++)
			//{
				//var tableBall:Array = Tableinfo.GetBallByIdx(arr[i]);
				//ToolsFunction.Log("tableBall = " + tableBall);
				//betModel.CommfirmAdd(tableBall);
			//}			
			
			//各盤勢一開始就new出,只是hide,全移除再切回很麻煩
			//if ( betModel.GetBetTableNo().length != 0)
			//{
				//DynamicArea.visible = false;
				//BestPanContainer.visible = true;
				//
				//PanProcess( -1, 24);				
			//}
			//else
			//{
				//DynamicArea.visible = true;
				//BestPanContainer.visible = false;
			//}
			//
			
				
			
			//5盤大小
			//ToolsFunction.scaleXY(BestPanContainer, 0.661, 0.661);
			
			//換盤BTN
			//SwitchPan = OpenBallView["switchPan"];
			//ToolsFunction.AddMouseListen(SwitchPan, SwitchPanEvent)
		}
		
		[MessageHandler(selector="Leave")]
		override public function ExitView(View:ViewState):void
		{
			
		}
		
		
	}

}