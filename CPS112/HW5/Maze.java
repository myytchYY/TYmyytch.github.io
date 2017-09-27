import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Maze
{
    Scanner input;
    int rows;
    int cols;;
    char[][] mazeCh;
    Location start;
    Location goal;
    public Maze(String file)
    {
	File inFile = new File(file);
	try 
	    {    
	input = new Scanner(inFile); } 
	catch (FileNotFoundException fnf)
	    {
		System.err.println("Input file not found");     
		System.exit(1); }

	String[] numbs = input.nextLine().split(" ");
	rows = Integer.parseInt(numbs[0]);
	cols = Integer.parseInt(numbs[1]);
	mazeCh = new char[rows][cols+1];

	for (int row = 0; row < rows; ++row)
	{
	    String line =  input.nextLine();
	    for (int c = 0; c<cols+1; ++c)
		{
		    if (c<cols){
			char curr =line.charAt(c);
			mazeCh[row][c]= curr;
			if (curr == 'o')
			    start = new Location(row,c);
			else if (curr=='*')
			    goal = new Location(row,c);}
		    else if (c ==cols && row!=rows-1)
			mazeCh[row][c] = '\n';
			}
	}
	input.close();
    }


    public int getNumColumns()
    {
	return cols;
    }
    public int getNumRows()
    {    
	return rows;
    }
    public Location getStartLocation()
    {
	return start;
    } 
  
    public Location getGoalLocation()
    {
	return goal;
    }    
    public char getSquare(Location loc)
    {
	int c = loc.getColumn();
	int r = loc.getRow();
        return mazeCh[r][c];
    }
    public boolean isWall(char c)
    {
	return c=='#';
    }
    public boolean isOpen(char c)
    {
	return c=='.';
    }
    public boolean isStart(char c)    {
	return c=='o';
    }
    public boolean isGoal(char c)
    {
	return c=='*';
    }
    public String toString()
    {	
	String maze = "";
	for (int i = 0; i<rows;i++)
	    for(int j = 0; j<cols+1;j++)
		{	     
		    maze+= Character.toString(mazeCh[i][j]);
		}	
	return maze;
    }
    
    public static void main(String[]args)
    {	
	NumberMaze test = new NumberMaze(args[0]);
	System.out.println(test.getNumRows());
	System.out.println(test.toString());
    }
}
class NumberMaze extends Maze
{
    public NumberMaze(String file)
    {
	super(file);
	/*
	File inFile = new File(file);
	try 
	    {    
	input = new Scanner(inFile); } 
	catch (FileNotFoundException fnf)
	    {
		System.err.println("Input file not found");     
		System.exit(1); }

	String numbs = input.nextLine();
	rows = Character.getNumericValue(numbs.charAt(0));
	cols = Character.getNumericValue(numbs.charAt(2));
	mazeCh = new char[rows][cols+1];

	for (int row = 0; row < rows; ++row)
	{
	    String line =  input.nextLine();
	    for (int c = 0; c<cols+1; ++c)
		{
		    if (c<cols){
			char curr =line.charAt(c);
			mazeCh[row][c]= curr;
			if (curr == '2')
			    start = new Location(row,c);
			else if (curr=='3')
			    goal = new Location(row,c);}
		    else if (c ==cols && row!=rows-1)
			mazeCh[row][c] = '\n';
			}
	}
	input.close();	
	*/
	    for (int row = 0; row < rows; ++row)
	    {
		for (int c = 0; c<cols+1; ++c)
		    {char curr = mazeCh[row][c];
			if (curr=='2')
			    start = new Location(row,c);
			else if (curr=='3')
			    goal = new Location(row,c);
			    }
	    }
	
    }
    @Override
    public boolean isWall(char c)
    {
	return c=='1';
    }
    @Override
    public boolean isOpen(char c)
    {
	return c=='0';
    }
    @Override
    public boolean isStart(char c)   
    {
	return c=='2';
    }
    @Override
    public boolean isGoal(char c)
    {
	return c=='3';
    }

}
