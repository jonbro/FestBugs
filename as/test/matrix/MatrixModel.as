package test.matrix
{
	/**
	 * Simple data structure for 2D Boolean Pattern (Like ToneMatrix)
	 * 
	 * @author Andre Michelle
	 */
	public final class MatrixModel
	{
		private var _numCols : int;
		private var _numRows : int;
		
		private var _data: Vector.<Vector.<Boolean>>;
		
		private var _observers: Vector.<IMatrixModelObserver>;

		public function MatrixModel( numCols : int, numRows : int )
		{
			_numRows = numRows;
			_numCols = numCols;
			
			init();
		}
		
		public function setCellValue( x: int, y: int, value: Boolean ): void
		{
			if(
				0 > x ||
				0 > y ||
				_numCols <= x ||
				_numRows <= y
			)
			{
				throw new RangeError();
			}
			
			if( _data[y][x] != value )
			{
				_data[y][x] = value;
				
				notify();
			}
		}
		
		public function getCellValue( x: int, y: int ): Boolean
		{
			if(
				0 > x ||
				0 > y ||
				_numCols <= x ||
				_numRows <= y
			)
			{
				throw new RangeError();
			}
			
			return _data[y][x];
		}
		
		public function addObserver( observer: IMatrixModelObserver ): void
		{
			if( -1 < _observers.indexOf( observer ) )
				throw new Error( 'Observer already exists.' );
			
			_observers.push( observer );
		}
		
		public function removeObserver( observer: IMatrixModelObserver ): void
		{
			const deleteIndex: int = _observers.indexOf( observer );
			
			if( -1 == deleteIndex )
				throw new Error( 'Observer does not exists.' );
			
			_observers.splice( deleteIndex, 1 );
		}

		public function get numCols() : int
		{
			return _numCols;
		}

		public function get numRows() : int
		{
			return _numRows;
		}
		
		private function init(): void
		{
			_data = new Vector.<Vector.<Boolean>>( _numRows, true );
			
			for( var i: int = 0 ; i < _numRows ; ++i )
				_data[i] = new Vector.<Boolean>( _numCols, true );
			
			_observers = new Vector.<IMatrixModelObserver>();			
		}

		private function notify() : void
		{
			var i: int = _observers.length;
			
			while( --i > -1 )
				_observers[i].onMatrixModelChanged( this );
		}
	}
}
