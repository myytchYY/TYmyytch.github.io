import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Dimension;
import java.awt.Color;

public class MazeGUI extends JPanel
{
    GridBagConstraints gbc;
    
    private Square [][] squares;

    private Location startLocation;
    private Location goalLocation;
    
    public MazeGUI(Maze maze)
    {	
	int rows = maze.getNumRows();
	int cols = maze.getNumColumns();
	squares = new Square[rows][cols];

	// Initializes the GUI
	gbc = new GridBagConstraints();
	setLayout(new GridBagLayout());

	/* Sets up the grid */
	for (int row = 0; row < rows; ++row)
	{
	    for (int col = 0; col < cols; ++col)
	    {
		gbc.gridx = col;
		gbc.gridy = row;

		Square sqr = new Square(600/cols, 600/rows);
		Location loc = new Location(row, col);
		char symbol = maze.getSquare(loc);
		
		if (maze.isWall(symbol))
		    sqr.setColor(Color.BLACK);
		else if (maze.isStart(symbol))
		{
		    sqr.setColor(Color.GREEN);
		    startLocation = new Location(row, col);
		}
		else if (maze.isGoal(symbol))
		{
		    sqr.setColor(Color.RED);
		    goalLocation = new Location(row, col);
		}
		
		add(sqr, gbc);
		squares[row][col] = sqr;
	    }
	}
    }

    /*
     * Called when a location added to agenda in solveMaze
     */
    public void addLocToAgenda(Location loc)
    {
	if ((!loc.equals(startLocation)) && (!loc.equals(goalLocation)))
	    squares[loc.getRow()][loc.getColumn()].setColor(Color.DARK_GRAY);
    }

    /*
     * Called after a location has been visited in solveMaze
     */
    public void visitLoc(Location loc)
    {
	if ((!loc.equals(startLocation)) && (!loc.equals(goalLocation)))
	    squares[loc.getRow()][loc.getColumn()].setColor(Color.LIGHT_GRAY);
    }

    /* 
     * Called as solution path constructed in solveMaze
     */
    public void addLocToPath(Location loc)
    {
	if ((!loc.equals(startLocation)) && (!loc.equals(goalLocation)))
	    squares[loc.getRow()][loc.getColumn()].setColor(Color.YELLOW);
    }

    public void pause()
    {
	try
	{
	    Thread.sleep(900);
	}
	catch (InterruptedException ie)
	{
	}
    }

    /*
     * Print out a usage message instead of erroring
     * with incorrect number or values for arguments to main
     */
    public static void printUsage()
    {
	System.out.println("Usage: java MazeGUI <maze file> <maze type> <agenda type>");
	System.out.println("\tWhere maze type should be t (for text) or n (for number)");
	System.out.println("\tAnd agenda type should be s (for stack) or q (for queue)");
    }
    
    public static void main(String [] args)
    {
	if (args.length != 3)
	{
	    printUsage();
	    System.exit(1);
	}
	
	JFrame frame = new JFrame("Maze Solver");

	// Create a new maze of the appropriate type
	// based on type specified and maze file given
	Maze maze = null;
	if (args[1].equalsIgnoreCase("t"))
	    maze = new Maze(args[0]);
	else if (args[1].equalsIgnoreCase("n"))
	    maze = new NumberMaze(args[0]);
	else
	{
	    printUsage();
	    System.exit(1);
	}
	
	// Now setup the GUI
	MazeGUI mazeGraphics = new MazeGUI(maze);
	
	frame.getContentPane().add("Center", mazeGraphics);

	mazeGraphics.setFocusable(true);
	mazeGraphics.requestFocusInWindow();

	frame.setSize(600, 600);
	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	frame.setVisible(true);

	// Create an appropriate type of Agenda and a MazeSolver
	// Then solve the maze
	Agenda agenda = null;

	if (args[2].equalsIgnoreCase("s"))
	    agenda = new StackAgenda();
	else if (args[2].equalsIgnoreCase("q"))
	    agenda = new QueueAgenda();
	else
	{
	    printUsage();
	    System.exit(1);
	}
	
	MazeSolver solver = new MazeSolver(agenda);
	solver.solveMaze(maze, mazeGraphics);
    }
}
