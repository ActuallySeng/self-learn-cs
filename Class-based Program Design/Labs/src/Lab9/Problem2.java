package Lab9;

import java.awt.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

import tester.*;
import javalib.impworld.*;
import javalib.worldimages.*;

// Represents an individual tile
class Tile {
  // The number on the tile.  Use 0 to represent the hole
  int value;
  WorldImage img;
  int SIZE = 20;
  int FONT_SIZE = 15;
  Color FONT_COLOR = Color.white;
  Color TILE_COLOR = Color.black;

  Tile(int value){
	  this.value = value;
	  img = new OverlayImage(new TextImage(Integer.toString(value), FONT_SIZE, Color.white), new RectangleImage(SIZE, SIZE, OutlineMode.SOLID, Color.BLACK));
	   
  }
  
  // Draws this tile onto the background at the specified logical coordinates
  WorldImage drawAt(int col, int row, WorldImage background) {
	  if (this.value == 0) {
		  return background;
	  }
	  
	  int x = col * SIZE;
	  int y = row * SIZE;
	  return new OverlayImage(img.movePinholeTo(new Posn(-x, -y)), background);
  }
  
}
 
class FifteenGame extends World {
  // represents the rows of tiles
  int SIZE = 80;
  Random RAND = new Random(1);
  ArrayList<ArrayList<Tile>> tiles;
  ArrayList<String> undoLog = new ArrayList<String>();

  FifteenGame(){
	  this.tiles = initTiles();
  }
  
  FifteenGame(ArrayList<ArrayList<Tile>> tiles){
	  this.tiles = tiles;
  }
  
  // Initializes 16 tiles
  ArrayList<ArrayList<Tile>> initTiles(){
      ArrayList<Integer> tileNums = 
              new ArrayList<Integer>(Arrays.asList(
                          0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15));
      
	  ArrayList<ArrayList<Tile>> result = new ArrayList<ArrayList<Tile>>();
	  
	  for (int i = 0; i < 4; i++) { // Columns
		  
		  ArrayList<Tile> eachRow = new ArrayList<Tile>();
		  
		  for (int j = 0; j < 4; j++) { // Rows
			  int valueIndex = RAND.nextInt(tileNums.size());
			  int value = tileNums.get(valueIndex);
			  tileNums.remove(valueIndex);
			  eachRow.add(new Tile(value));
		  }
		  
		  result.add(eachRow);
	  }
	  
	  return result;
  }
  
 
  // draws the game
  public WorldScene makeScene() {
	  WorldScene scene = new WorldScene(SIZE, SIZE);
	  WorldImage img = new EmptyImage();
	  
	  for (ArrayList<Tile> i: tiles) {
		  for (Tile j: i) {
			  img = j.drawAt(i.indexOf(j), tiles.indexOf(i), img);
		  }
	  }
	  
	  scene.placeImageXY(img, 10, 10);
	  return scene;
  }
  
  // handles keystrokes
  public void onKeyEvent(String k) {
    // needs to handle up, down, left, right to move the hole
    // extra: handle "u" to undo moves
	int row = new Utility().get0Pos(tiles, 0);
	int col = new Utility().get0Pos(tiles, 1);
	
    if (k.equals("up")) {
    	int sRow = row - 1;
    	int sCol = col;
    	new Utility().swap(row, col, sRow, sCol, tiles);
    	undoLog.add(k);
    	
    }
    
    if (k.equals("down")) {
    	int sRow = row + 1;
    	int sCol = col;
    	new Utility().swap(row, col, sRow, sCol, tiles);
    	undoLog.add(k);
    }
    
    if (k.equals("left")) {
    	int sRow = row;
    	int sCol = col - 1;
    	new Utility().swap(row, col, sRow, sCol, tiles);
    	undoLog.add(k);
    }
    
    if (k.equals("right")) {
    	int sRow = row;
    	int sCol = col + 1;
    	new Utility().swap(row, col, sRow, sCol, tiles);
    	undoLog.add(k);
    	
    }
    
    if (k.equals("u")) {
    	if (undoLog.size() > 0) {
    		int prevKeyIndex = undoLog.size() - 1;
    		String prevKey = undoLog.get(prevKeyIndex);
    		
        	if (prevKey.equals("up")) {
        		onKeyEvent("down");
        	}
        	if (prevKey.equals("down")) {
        		onKeyEvent("up");
        	}
        	if (prevKey.equals("left")) { 
        		onKeyEvent("right");
        	}
        	if (prevKey.equals("right")) {
        		onKeyEvent("left");
        	}
        	
        	undoLog.remove(prevKeyIndex);
        	undoLog.remove(prevKeyIndex);
    	}
    }
  }
}


class ExamplesFifteenGame {
	FifteenGame f1;
	
	void initTest() {
		ArrayList<Tile> row1 = new ArrayList<Tile>(Arrays.asList(new Tile(2), new Tile(4), new Tile(6), new Tile(7)));
		ArrayList<Tile> row2 = new ArrayList<Tile>(Arrays.asList(new Tile(3) , new Tile(5), new Tile(7), new Tile(9)));
		ArrayList<Tile> row3 = new ArrayList<Tile>(Arrays.asList(new Tile(1) , new Tile(10), new Tile(11), new Tile(12)));
		ArrayList<Tile> row4 = new ArrayList<Tile>(Arrays.asList(new Tile(0) , new Tile(13), new Tile(14), new Tile(15)));
		
		
		f1 = new FifteenGame(new ArrayList<ArrayList<Tile>>(Arrays.asList(row1, row2, row3, row4)));
	}
	
	void testFifteen(Tester t) {
		initTest();
		
		t.checkExpect(new Utility().get0Pos(f1.tiles, 0), 3);
		t.checkExpect(new Utility().get0Pos(f1.tiles, 1), 0);
		
		// Test swap "up"
		new Utility().swap(3, 0, 2, 0, f1.tiles);
		t.checkExpect(new Utility().get0Pos(f1.tiles, 0), 2);
		t.checkExpect(new Utility().get0Pos(f1.tiles, 1), 0);
		
		
		
		
	}
	
	  void testGame(Tester t) {
		initTest();
	    FifteenGame g = f1;
	    g.bigBang(120, 120);
	  }
	}