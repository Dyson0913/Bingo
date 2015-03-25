package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import View.InterFace.IVew;
	import View.componentLib.util.utilFun;
	/**
	 * ...
	 * @author hhg
	 */
	public class LoadingView extends Sprite implements IVew
	{
		//主容器
		public var BgContainer:MovieClip;
		
		
		public var _LoadingView:MovieClip;		
		
		
			//[MessageDispatcher]
        //public var dispatcher:Function;
		//
		//[MessageBinding(messageProperty="_View",type="ViewEnum")]
		//public var user:int = 0;
		
		public function LoadingView()  
		{
			utilFun.Log("first load");
			BgContainer = utilFun.GetClassByString("mc_BgContainer");
			addChild(BgContainer);
			_LoadingView = utilFun.GetClassByString("Loadingbg");
			BgContainer.addChild(_LoadingView);
			utilFun.Log("first load 2");
			utilFun.Log("LoadingView");
		}
		
		public function FirstLoad():void
		{
			
			
		}
		
		//[MessageHandler(type = "ViewEnum", messageProperties = "_View")]
		//public function handleMessage4(msg:int):void
        //{
            //Debug.trace("msg 1-3=" + msg);
        //}
		//
		//[MessageHandler(type="ViewEnum")]
		//public function handleMessage2(msg:ViewEnum):void
        //{
            //Debug.trace("msg 1-2=" + msg._View);
        //}
		
		//[MessageHandler]
		//
		public function EnterView (View:int):void
		{
			
			
			
			
		}
		
		public function ExitView():void
		{
			
		}
		
		
	}

}