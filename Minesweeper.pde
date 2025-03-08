// IM TRYING TO DEBUG AHHH
// if a comment has "DC" in it, it means "double check the code underneath if there
// are errors"
// i am currently: on step 13, else recusively call mousePressed with the valid, unclicked neighboring buttons in all 8 directions
import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private int NUM_MINES = (int)(Math.random()*30) + 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new <MSButton> ArrayList(); //ArrayList of just the minesweeper buttons that are mined
// helps decide whether to put a game over screen on or not
private boolean tryAgainScreen = false;
// hover feature
private color hoverColor = color(0, 0, 0, 30);

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++) {
      for(int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    setMines();
}
public void setMines()
{
  //your code
  // no +1 cuz row indexes start at 0, end at num_rows -1 and whatnot
  while(mines.size() < NUM_MINES) {
    int randRow = (int)(Math.random()*NUM_ROWS);
    int randCol = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[randRow][randCol])) {
      mines.add(buttons[randRow][randCol]);
      //System.out.println("rand row: " + randRow);
      //System.out.println("rand col: " + randCol);
    }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true) {
        displayWinningMessage();     
    }
}
// DC this
public boolean isWon()
{
    //your code here
    for(int i = 0; i < mines.size(); i++) {
      if (mines.get(i).flagged == false) {
        return false;
      }
    }
    return true;
}
// DC. I changed clicked because when its clicked it should turn red
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < mines.size(); i++) {
      mines.get(i).clicked = true;
    }
    //System.out.println("you lost" );
    tryAgainScreen = true;
}
// DC this stuffff what does it mean use setLabel to change the labels of the buttons?
public void displayWinningMessage()
{
    //your code here
    //System.out.println("You won !!");
    tryAgainScreen = true;
}
public boolean isValid(int r, int c)
{
    //your code here
    if(r >= 0 && r < NUM_ROWS)
      if(c >= 0 && c < NUM_COLS)
        return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int r = row-1; r <= row+1; r++) {
      for(int c = col-1; c <= col+1; c++) {
        if(isValid(r, c) == true && !(r == row && c == col)) {
          if(mines.contains(buttons[r][c])) {
            numMines++;
          }
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    private color myColor;
    
    public MSButton ( int row, int col )
    {
         width = 600/NUM_COLS;
         height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        if(myRow % 2 ==0) {
          if(myCol % 2 == 0) {
            // pink #1
            myColor = color(255, 163, 227);
          } else {
            // pink #2
            myColor = color(255, 209, 238);
          }
        } else {
            if(myCol % 2 == 0) {
              // pink #2
              myColor = color(255, 209, 238);
          } else {
            // pink #1
            myColor = color(255, 163, 227);
          }
        }
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
        //if(tryAgainScreen == true) {
        //    if(mouseX >= 175 && mouseX <= 425) {
        //    if(mouseY >= 320 && mouseY <= 395) {
        //      // restart
        //      //System.out.println("Restart");
        //      NUM_MINES = (int)(Math.random()*30) + 20;
        //      for(int i = 0; i < mines.size(); i++) {
        //        mines.remove(i);
        //      }
        //      setMines();
        //      for(int r = 0; r < NUM_ROWS; r++) {
        //        for(int c = 0; c < NUM_COLS; c++) {
        //          buttons[r][c].clicked = false;
        //          buttons[r][c].flagged = false;
        //          buttons[r][c].myLabel = "";
        //        }
        //      }
        //       // code from setup
        //      tryAgainScreen = false;
        //  }
        //}    
        //}
    }
    public void draw () 
    {
      stroke(117, 46, 91);
        if (flagged)
            fill(148, 46, 110);
        else if(clicked && mines.contains(this)) 
            fill(184, 2, 2);
        else if(clicked)
            fill( 161, 84, 132 );
        else 
            fill( myColor );

        rect(x, y, width, height);
        fill(0);
        stroke(0);
        textSize(10);
        text(myLabel,x+width/2,y+height/2);
        
          // display game over screen
      if(tryAgainScreen == true) {
      fill(255);
      rect(100, 150, 400, 300);
      fill(#ffb8f1);
      rect(175, 320, 250, 75);
      fill(0);
      if(isWon() == false) {
      textSize(30);
      text("You lost !", 300, 250);
      textSize(25);
      text("Try again? ;(", 300, 355);
      } else {
      textSize(30);
      text("You won !", 300, 250);
      textSize(25);
      text("Play again? ;)", 300, 355);
      }
      }
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
} // end of MS Button class
