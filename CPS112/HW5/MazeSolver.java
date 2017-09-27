import java.util.LinkedList;
import java.util.HashMap;

class MazeSolver
{
    static Agenda agenda;
    public MazeSolver(Agenda given)
    {
	agenda = given;
	agenda.clear();
    }

    public static LinkedList solveMaze(Maze myMaze, MazeGUI gui)
    {
	LinkedList result = new LinkedList<Location>();
        LinkedList marked = new LinkedList<Location>();
	HashMap<Location, Location> map = new HashMap<Location, Location>();
	
	Location start = myMaze.getStartLocation();
	System.out.println(agenda);
	agenda.addLocation(start);
	marked.add(start);

	//boolean solved = false;
	//boolean answer = false;
	while (!agenda.isEmpty())
	    {
		Location curr = agenda.getLocation();
		gui.pause();
		gui.visitLoc(curr);
		if(curr.equals(myMaze.getGoalLocation()))
		    {
			Location current = curr;
			while (!current.equals(start))
			    {
				result.add(current);
				gui.addLocToPath(current);
				current = map.get(current);
			    }		
			return result;
		    }
		else
		    {
		        int curR = curr.getRow();
			int curC = curr.getColumn();
			//north
			if (curR>0)
			    { Location north =new Location(curR-1,curC);
				if (! marked.contains(north) && (!myMaze.isWall(myMaze.getSquare(north))))
				    {
					marked.add(north);
					agenda.addLocation(north);
					gui.addLocToAgenda(north);
					map.put(north,curr);}}
			//south
			if (curR < myMaze.getNumRows()-1)
			    { Location south =new Location(curR+1,curC);
				if (!marked.contains(south) &&  (!myMaze.isWall(myMaze.getSquare(south))))
				    {marked.add(south);
					agenda.addLocation(south);
					gui.addLocToAgenda(south);
					map.put(south,curr);}}
			//east
			if (curC< myMaze.getNumColumns()-1)
			    { Location east =new Location(curR,curC+1);
				if (!marked.contains(east) &&  (!myMaze.isWall(myMaze.getSquare(east))))
				    {marked.add(east);
					agenda.addLocation(east);
					gui.addLocToAgenda(east);
					map.put(east,curr);}}
			//west
			if (curC>0)
			    { Location west =new Location(curR,curC-1);
				if (!marked.contains(west) &&  (!myMaze.isWall(myMaze.getSquare(west))))
				    {marked.add(west);
					agenda.addLocation(west);
					gui.addLocToAgenda(west);
				    	map.put(west,curr);}}
		    }
	    }
	return new LinkedList();
	/*
		if (answer)
		    {
			Location current = myMaze.getGoalLocation();
			while (!current.equals(start))
			    {
				result.add(current);
				current = map.get(current);
			    }		
			return result;
		    }
		else
		    {return new LinkedList();}	
	*/	
    }
}   
    
