public class SolveMaze
{
    public static void main(String[] args) 
    {
	    Maze newMaze = new Maze(args[0]);
	    MazeGUI gui = new MazeGUI(newMaze);
	    String option = args[1];
	    if (option.equals("s"))
		{
		    StackAgenda agendaS = new StackAgenda();
		    MazeSolver mazeS = new MazeSolver(agendaS); 
		    System.out.println(mazeS.solveMaze(newMaze,gui));
		}
	    else if (option.equals("q"))
		{
		    QueueAgenda agendaQ = new QueueAgenda();
		    MazeSolver mazeS = new MazeSolver(agendaQ); 
		    System.out.println(mazeS.solveMaze(newMaze,gui));
		}
	    else 
		System.out.println("ERROR!");
    }
}
