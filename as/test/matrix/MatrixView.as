package test.matrix
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author Andre Michelle
	 */
	public final class MatrixView extends Sprite
		implements IMatrixModelObserver
	{
		private var _model : MatrixModel;
		private var _cellSize : Number;
		
		private var _width: Number;
		private var _height: Number;
		
		private var _paintValue: Boolean;

		public function MatrixView( cellSize: Number = 32 )
		{
			_cellSize = cellSize;
			
			addEventListener( Event.ADDED_TO_STAGE, addedToStage );
			addEventListener( Event.REMOVED_FROM_STAGE, removedFromStage );
			
			update();
		}

		public function get model() : MatrixModel
		{
			return _model;
		}

		public function set model( value : MatrixModel ) : void
		{
			if( _model != value )
			{
				if( null != _model )
					_model.removeObserver( this );
				
				_model = value;
				
				if( null != _model )
					_model.addObserver( this );
					
				update();
			}
		}

		public function onMatrixModelChanged( model : MatrixModel ) : void
		{
			update();
		}
		
		public function dispose(): void
		{
			if( null != _model )
			{
				_model.removeObserver( this );
				_model = null;
			}
		}
		
		private function addedToStage( event : Event ) : void
		{
			stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}

		private function removedFromStage( event : Event ) : void
		{
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
		}

		private function mouseDown( event : MouseEvent ) : void
		{
			if( null == _model )
				return;
			
			const x: Number = mouseX;
			const y: Number = mouseY;
			
			const xi: int = x / _cellSize;
			const yi: int = y / _cellSize;
				
			if( 0 <= xi && _model.numCols > xi && 0 <= yi && _model.numRows > yi )
			{
				_paintValue = !_model.getCellValue( xi, yi );
				_model.setCellValue( xi, yi, _paintValue );
				
				stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
				stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
			}
		}

		private function mouseMove( event : MouseEvent ) : void
		{
			if( null == _model )
				return;
			
			const xi: int = mouseX / _cellSize;
			const yi: int = mouseY / _cellSize;
			
			if( 0 <= xi && _model.numCols > xi && 0 <= yi && _model.numRows > yi )
			{
				_model.setCellValue( xi, yi, _paintValue );
			}
		}

		private function mouseUp( event : MouseEvent ) : void
		{
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUp );
		}

		private function update() : void
		{
			graphics.clear();
			
			if( null == _model )
				return;
				
			_width = _cellSize * model.numCols;
			_height = _cellSize * model.numRows;
			
			const yn: int = _model.numRows;
			const xn: int = _model.numCols;
			
			var xi: int;
			var yi: int;
			
			for( yi = 0 ; yi < yn ; ++yi )
			{
				for( xi = 0 ; xi < xn ; ++xi )
				{
					paintCell( xi * _cellSize, yi * _cellSize, _model.getCellValue( xi, yi ) );
				}
			}
		}

		private function paintCell( x : Number, y : Number, value : Boolean ) : void
		{
			const padding: Number = 2.0;
			const size: Number = _cellSize - padding * 2.0;
			
			graphics.beginFill( value ? 0xFFCC00 : 0x333333 );
			graphics.drawRoundRectComplex( x + padding, y + padding, size, size, 4.0, 4.0, 4.0, 4.0 );
			graphics.endFill();
		}
	}
}