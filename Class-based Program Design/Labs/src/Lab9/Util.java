package Lab9;
import java.util.ArrayList;

class Utility{
	
	// Gets 0's row if pos = 0 or column if pos = 1;
	int get0Pos(ArrayList<ArrayList<Tile>> tiles, int pos) {
		for (int row = 0; row < 4; row++) {
			for (int col = 0; col < 4; col++) {
				if (tiles.get(row).get(col).value == 0) {
					if (pos == 0) {
						return row;
					} else if (pos == 1) {
						return col;
					} else {
						throw new IllegalArgumentException("Pos not accepted.");
					}
				}
			}
		}
		return 0;
	}
	
	// Swaps zeroth tile pos with swap tile pos in given list of tiles.
	  void swap(int row, int col, int sRow, int sCol, ArrayList<ArrayList<Tile>> tiles) {
		  if(sRow < 0 || sRow > 3 || sCol < 0 || sCol > 3) {
			  return;
		  }
		  Tile zero = tiles.get(row).get(col);
		  Tile swap = tiles.get(sRow).get(sCol);
		  
		  tiles.get(row).set(col, swap);
		  tiles.get(sRow).set(sCol, zero);
	  }
}