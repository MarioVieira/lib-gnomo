//////////////////////////////////////////////////////////////////////////////////////
//
//	Copyright 2011 Piotr Walczyszyn (http://riaspace.com | @pwalczyszyn)
//	
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//	
//		http://www.apache.org/licenses/LICENSE-2.0
//	
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//	
//////////////////////////////////////////////////////////////////////////////////////

package uk.co.baremedia.gnomo.utils.transitions
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ViewNavigator
	{
		private static const ADD_CHILD		:String = "addChild";
		private static const ADD_ELEMENT	:String = "addElement";
		private static const REMOVE_CHILD	:String = "removeChild";
		private static const REMOVE_ELEMENT	:String = "removeElement";
		protected var parent:Sprite;
		
		protected var views:Vector.<ViewReference> = new Vector.<ViewReference>;
		
		protected var _poppedViewReturnedObject:Object;
		
		private var _poppedViewContext:Object;
		
		/**
		 * Views transition duration, default value is 0.5s.
		 */
		public var transitionTime:Number = 0.5;
		
		
		/**
		 * ViewNavigator constructor.
		 * 
		 * @param parent - parent application Sprite.
		 * @param firstView - instance or Class of the view to add. It must inherit from DisplayObject at some point.
		 * @param firstViewProps - associative array of properties and values to set on the view. Especially usefull if 
		 * view is passed as Class.
		 * @param firstViewContext - object that can be passed to the view if it implements IView. It also will be returned
		 * by ViewNavigator's poppedViewContext property no matter if the view implements IView or not.
		 * @param transition - enum value from <code>ViewTransition</code> class. Constructor by default has it is set to <code>ViewTransition.NONE</code>.
		 */
		public function ViewNavigator(parent:Sprite, firstView:Object = null, firstViewProps:Object = null, firstViewContext:Object = null, transition:String = "none")
		{
			this.parent = parent;
			parent.addEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
			
			if (firstView)
				pushView(firstView, firstViewProps, firstViewContext, transition);
		}
		
		protected function parent_addedToStageHandler(event:Event):void
		{
			parent.removeEventListener(Event.ADDED_TO_STAGE, parent_addedToStageHandler);
			parent.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}

		protected function stage_resizeHandler(event:Event):void
		{
			for each(var viewRef:ViewReference in views)
				if (viewRef.view is IView)
					IView(viewRef.view).resize();
		}
		
		/**
		 * Adds view on top of the stack. 
		 * 
		 * If added view implements IView interface it will also inject the reference to
		 * this navigator instance.
		 * 
		 * @see com.riaspace.as3viewnavigator.IView
		 * 
		 * @param view - instance or Class of the view to add. It must inherit from DisplayObject at some point.
		 * @param viewProps - associative array of properties and values to set on the view. Especially usefull if 
		 * view is passed as Class.
		 * @param context - object that can be passed to the view if it implements IView. It also will be returned
		 * by ViewNavigator's poppedViewContext property no matter if the view implements IView or not.
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 * 
		 * @return Returns pushed view.
		 */
		public function pushView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject
		{
			var dispObj:DisplayObject;
			
			// If view is a Class instantiating it
			if (view is Class)
				dispObj = new view();
			else
				dispObj = DisplayObject(view);
			
			// if pushed view is an IView setting navigator reference
			if (dispObj is IView)
			{
				IView(dispObj).resize();
				
				IView(dispObj).navigator = this;
				IView(dispObj).context = context;
			}
			
			// Setting view properties
			for(var prop:String in viewProps)
				if (dispObj.hasOwnProperty(prop))
					dispObj[prop] = viewProps[prop];
			
			// Getting width of the stage
			var stageWidth:Number = parent.stage.stageWidth;
			
			// Setting x position to the right outside the screen
			dispObj.x = stageWidth;
			// Setting y to the top of the screen
			dispObj.y = 0;
			
			// Adding view to the parent
			// ADDED BY MARIO VIEIRA
			addChild(dispObj);

			var currentView:ViewReference;
			if (views.length > 0)
			{
				// Getting current view from the stack
				currentView = views[views.length - 1];
				
				if (transition == ViewTransition.SLIDE)
					// Tweening currentView to the right outside the screen
					Tweener.addTween(currentView.view, {x : -stageWidth, time : transitionTime});
			}

			if (transition == ViewTransition.SLIDE)
			{
				// Tweening added view
				Tweener.addTween(dispObj, 
					{
						x : 0, 
						time : transitionTime, 
						onComplete:function():void
						{
							if (currentView)
							{
								removeChild(currentView.view);
							}
						}
						});
			}
			else
			{
				if (currentView)
					removeChild(currentView.view);
				dispObj.x = 0;
			}
			
			// Adding current view to the stack
			views.push(new ViewReference(dispObj, context));
			
			// Returning pushed view
			return dispObj;
		}
		
		/**
		 * Pops current view from the top of the stack.
		 * 
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack. 
		 */
		public function popView(transition:String = "slide"):DisplayObject
		{
			var currentView:ViewReference;
			if (views.length > 0)
			{
				// Getting current view from the stack
				currentView = views[views.length - 1];
				
				// Getting below view
				var belowView:ViewReference;
				if (views.length > 1)
					belowView = views[views.length - 2];
				
				// Getting width of the stage
				var stageWidth:Number = parent.stage.stageWidth;

				var removeCurrentFunction:Function = 
					function():void
					{
						// Removing top view from the stack
						views.pop();
						// Removing view from parent
						removeChild(currentView.view);
						
						// Setting context of popped view
						_poppedViewContext = currentView.context;
						
						// Getting popped view return object
						if (currentView is IView)
							_poppedViewReturnedObject = 
								IView(currentView.view).viewReturnObject;
						else
							_poppedViewReturnedObject = null;
					};
				
				if (transition == ViewTransition.SLIDE)
					// Tweening currentView to the right outside the screen
					Tweener.addTween(currentView.view, {x : stageWidth, time : transitionTime, onComplete : removeCurrentFunction});
				else
					removeCurrentFunction();
				
				if (belowView)
				{
					addChild(belowView.view);
					
					if (transition == ViewTransition.SLIDE)
						// Tweening view from below
						Tweener.addTween(belowView.view, {x : 0, time : transitionTime});
					else
						belowView.view.x = 0;
				}
			}
			// Returning popped view
			return currentView.view;
		}
		
		/**
		 * Pops to the first view from the very top.
		 * 
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		public function popToFirstView(transition:String = "slide"):DisplayObject
		{
			var topView:DisplayObject;
			if (views.length > 1)
			{
				// Removing views except the bottom and the top one
				if (views.length > 2)
					views.splice(1, views.length - 2);
				
				// Poping top view to have nice transition
				topView = popView(transition);
			}
			return topView;
		}
		
		/**
		 * Pops all views from the stack.
		 * 
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		public function popAll(transition:String = "slide"):DisplayObject
		{
			// Removing views except the top one
			views.splice(0, views.length - 1);
			
			// Poping top view to have nice transition
			return popView(transition);
		}
		
		/**
		 * Replaces view with the one passed as parameter.
		 * 
		 * @param view - instance or Class of the view to add. It must inherit from DisplayObject at some point.
		 * @param viewProps - associative array of properties and values to set on the view. Especially usefull if 
		 * view is passed as Class.
		 * @param context - object that can be passed to the view if it implements IView. It also will be returned
		 * by ViewNavigator's poppedViewContext property no matter if the view implements IView or not.
		 * @param transition - enum value from <code>ViewTransition</code> class. By default it is set to <code>ViewTransition.SLIDE</code>.
		 *  
		 * @return Returns the view that was on top of the stack.
		 */
		public function replaceView(view:Object, viewProps:Object = null, context:Object = null, transition:String = "slide"):DisplayObject
		{
			// Pushing view on top of the stack
			var dispObj:DisplayObject = pushView(view, viewProps, context, transition);
			
			// Removing view below
			if (views.length > 1)
				views.splice(views.length - 2, 1);
			
			// Returning pushed view
			return dispObj;
		}
		
		/**
		 * Returns object value returned by popped view. If multiple views were popped it is a value of the one that was on top.
		 * View has to implement IView interface in order to have this value returned.
		 */
		public function get poppedViewReturnedObject():Object
		{
			return _poppedViewReturnedObject;
		}
		
		/**
		 * Returns number of views managed by this navigator.
		 */
		public function get length():int
		{
			return views.length;
		}

		/**
		 * Returns context object returned by popped view. If multiple views were popped it is a value of the one that was on top.
		 * View doesn't have to implement IView interface in order to have this value returned.
		 */
		public function get poppedViewContext():Object
		{
			return _poppedViewContext;
		}
		
		protected function removeChild(object:DisplayObject):void
		{
			if(parent.hasOwnProperty(REMOVE_ELEMENT)) parent[REMOVE_ELEMENT].call(null, object); 
			else								 	  parent.addChild(object);
		}

		protected function addChild(object:DisplayObject):void
		{
			if(parent.hasOwnProperty(ADD_ELEMENT)) parent[ADD_ELEMENT].call(null, object);
			else								   parent.addChild(object);								   	 
		}

	}
}
import flash.display.DisplayObject;

internal class ViewReference
{
	public var view:DisplayObject;
	public var context:Object;
	public function ViewReference(view:DisplayObject, context:Object)
	{
		this.view = view;
		this.context = context;
	}
}