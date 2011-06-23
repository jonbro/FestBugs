package test.matrix
{
	/**
	 * @author Andre Michelle
	 */
	public interface IMatrixModelObserver
	{
		function onMatrixModelChanged( model: MatrixModel ): void;
	}
}
