import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
public final static int NUM_MINES = 100;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
       for(int c = 0; c < NUM_ROWS; c++){
           buttons[r][c] = new MSButton(r,c);
       }
    }
    setMines();
 
}
public void setMines()
{
  while(mines.size() < NUM_MINES){
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
    background( 0 );

    
}
public boolean isWon()
{
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
         if(!mines.contains(buttons[i][j])){
           if(buttons[i][j].clicked == false){
             return false;
           }
         }
      }
    }
    return true;
}
public void displayLosingMessage(){
    fill(255,0,0);
    textAlign(CENTER);
    textSize(50);
    text("Loser Loser Poopy Eater", 400,400);
    textSize(15);
}
public void displayWinningMessage()
{
    fill(0,255,0);
    textAlign(CENTER);
    textSize(50);
    text("Winner Winner Chicken Dinner!", 400,400);
    textSize(15);
}
public boolean isValid(int r, int c)
{
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        if(i == r && j == c){
          return true;
        }
      }
    }
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i < row + 2; i++ ){
      for(int j = col-1; j < col + 2; j++){
        if(isValid(i,j)){
          if(mines.contains(buttons[i][j])){
            numMines++;
        }
      }
    }
  }
  if(mines.contains(buttons[row][col])){
    numMines--;
  }
   return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(flagged == false){
            clicked = false;  
          }
        }
        else if(mines.contains(this)){
          displayLosingMessage();
        }
        else if(countMines(myRow,myCol) > 0){
          setLabel(countMines(myRow, myCol));
        }
        else{
          for(int i = myRow-1; i < myRow +2; i++){
            for(int j = myCol- 1; j < myCol +2; j++){
              if(isValid(i,j) && buttons[i][j].clicked == false){
                buttons[i][j].mousePressed(); 
              }
            }
          }
        }  
    }
    public void draw () 
    {    
          if(isWon() == true)
        displayWinningMessage();
        
            for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
         if(mines.contains(buttons[i][j])){
           if(buttons[i][j].clicked == true && buttons[i][j].isFlagged() == false ){
             displayLosingMessage();
           }
         }
      }
    }
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
