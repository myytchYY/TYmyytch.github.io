import java.util.HashMap;
import java.util.ArrayList;
import java.util.ArrayDeque;  // Use this as a Queue
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.Arrays;
import java.util.Collections;  // Has reverse method for lists
import java.util.PriorityQueue;
import java.util.Comparator;

class KevinBacon
{
    /*
     * Reads the file line-by-line and builds the graph
     * where vertices are actors and edges are movies
     */

    public static EdgeDataGraph createActorGraph(String fileName)
    {
	EdgeDataGraph g = new EdgeDataGraph();
	File inFile = new File(fileName);
	Scanner input = null;

	try 
	    {    
		input = new Scanner(inFile); 
	    } 
	catch (FileNotFoundException fnf)
	    {
		System.err.println("Input file not found");     
		System.exit(1); }

	String currentM = null;
	ArrayList<String> actorsHere = null;

	while(input.hasNext())
	    { 
		String line = input.nextLine();
		String [] words = line.split(": "); 
		if(words[0].equals("Movie"))
		    {currentM = words[1];
			actorsHere = new ArrayList<String>();
			//System.out.println(currentM);
		    }
		else		    
		    {
			String currentA = words[1];
			//System.out.println(currentA);
			if(actorsHere.size()>0)
			    {
				for(String a: (ArrayList<String>) actorsHere)
				    {
					g.addEdge(a,currentA,currentM);
					g.addEdge(currentA,a,currentM);
				    }
			    }
			actorsHere.add(words[1]);
		    }
	    }
	//System.out.println(g.getNeighbors("Kevin Bacon"));
	return g;
    }

    /*
     * Uses BFS to find the shortest path between two actors
     * If no path exists, returns null
     */
    public static ArrayList<String> findShortestPath(EdgeDataGraph g, String fromActor, String toActor)
    {
	// No path between the two actors;
	ArrayList<String> result = new ArrayList<String>();

        HashMap<String,String> visited = new HashMap<String,String>();
        ArrayDeque<String> queue = new ArrayDeque<String>();

	if(g.isAdjacent(fromActor,toActor))
	    { 
		result.add(fromActor);
		result.add(toActor);
		return result;
	    }
	else if(fromActor.equals(toActor))
	    {result.add(toActor);
		return result;}
	else{
	    queue.add(fromActor);
	    boolean found = false;
	    String currentActor = queue.removeFirst();
	    while (!found)
		{
		    for(String a: (ArrayList<String>) g.getNeighbors(currentActor))
			if(!visited.containsKey(a))
			{
			    queue.add(a);
			    visited.put(a,currentActor);
			} 
		    if(queue.isEmpty()) //no path found
			return null;
		    String nextA = queue.removeFirst();
		    if(nextA.equals(toActor))
			{
			result.add(toActor);
			found = true;}
		else
		    currentActor = nextA;
		}
	    String pre = visited.get(toActor);
	    result.add(0,pre);
	    while(!pre.equals(fromActor))
		{
		    String curr = visited.get(pre);
		    result.add(0,curr);
		    pre = curr;
		}
	    return result;
	}
    }

    /* 
     * Returns a list where each element (i.e., position) i containst
     * the number of vertices i steps away from a given vertex
     */
    public static ArrayList<Integer> getDistanceDistribution(EdgeDataGraph g, String actor)
    {
	ArrayList<Integer> result = new ArrayList<Integer>();
	//initialize returning list
	result.add(1);

	HashMap<String,Integer> distance = new HashMap<String,Integer>();
	distance.put(actor,0);
	HashMap<String,String> pred = new HashMap<String,String>();

        ArrayDeque<String> queue = new ArrayDeque<String>();
	queue.add(actor);

	ArrayList<String> near = null;
	String curr = null;
	int count = 0;
	int currD = 1;
	while (!queue.isEmpty())
	    {
		curr = queue.removeFirst();
		near = g.getNeighbors(curr);

		for (String a: (ArrayList<String>) near){
		    if(!pred.containsKey(a))
			{
			    int length = distance.get(curr)+1;
			    queue.add(a);
			    pred.put(a,curr);
			    distance.put(a,length);
			    if(length==currD)
				{++count;}
			    //else if (length<currD)
			    //System.out.println("bug!");
			    else{
				result.add(count);
				count = 1;
				currD = length;}
			}
		}  
	    }
	result.add(count);
	//System.out.println(result.toString());
	return result;
    }

    /*
     * Returns the path from fromActor to toActor of length pathLength
     * with the maximum sum of degrees of vertices along the path
     */

    public static ArrayList<String> findFamousPath(EdgeDataGraph g, String fromActor, String toActor, int pathLength)
    {
	return null;
    }

    /*
     * Returns the path from fromActor to toActor that has the smallest
     * sum of degrees among the vertices in the path
     */

     public static ArrayList<String> findObscurePath(EdgeDataGraph g, String fromActor, String toActor)
    {
	ArrayList<String> obscures = new ArrayList<String>();
	HashMap<String,Integer> weights = new HashMap<String,Integer>();
        HashMap<String,String> visited = new HashMap<String,String>();
	ArrayList<String> path = new ArrayList<String>();
	if(g.isAdjacent(fromActor,toActor))
	    { 
		path.add(fromActor);
		path.add(toActor);
		return path;
	    }

	PriorityQueue<String> MPQ = new PriorityQueue<String>(g.getVertices().size(),new ByWeight(weights));	

	for (String actor: g.getVertices()){
	    int weight = g.getNeighbors(actor).size();
	    weights.put(actor,weight);
	    if(weight<100) 
		obscures.add(actor);
	}
	//System.out.println(weights.toString());
	MPQ.add(fromActor);
	String curr = null;
	boolean found = false;
	while(MPQ.size()!=0 && !found){
	    curr= MPQ.poll();
	    int currW = weights.get(curr);
	    //System.out.println(currW);
	    for(String a:(ArrayList<String>)g.getNeighbors(curr)){
		if(a.equals(toActor))
		    found=true;

		else if(!visited.containsKey(a) && obscures.contains(a))
		{
		    MPQ.add(a);
		    visited.put(a,curr);
		    int compareW = currW + weights.get(a);
		    if(compareW <weights.get(a)){
			MPQ.remove(a);
			weights.put(a,compareW);
			MPQ.add(a);
		    }}	
	    }
	}
	if (!found)
	    return null;
	String pre = visited.get(toActor);
	path.add(pre);
	while(!pre.equals(fromActor))
	    {
		String here = visited.get(pre);
		path.add(0,here);
		pre = here;
	    }
	    return path;
    }

    /*
     * Prompts user for an actor, checking to ensure the'
     * actor is in the database.  Re-prompts until it
     * has a valid actor
     */
    public static String actorInput(EdgeDataGraph g)
    {
	ArrayList<String> vertices = g.getVertices();
	Scanner in = new Scanner(System.in);
	System.out.print("Enter a new actor: ");
	String actor = in.nextLine();
	while (!vertices.contains(actor))
	{
	    System.out.println("Invalid actor, try again");
	    System.out.print("Enter a new actor: ");
	    actor = in.nextLine();
	}
	return actor;
    }

    /*
     * Nicely prints the path of actors
     */
    public static void printPath(EdgeDataGraph g, ArrayList<String> path)
    {
	for (int i = 0; i < path.size() - 1; i++)
	    System.out.println(path.get(i) + " and " + path.get(i+1) + " were in " + g.getEdgeData(path.get(i), path.get(i+1)));
	
    }

    /* 
     * Drives the whole program
     */
    public static void main(String [] args)
    {
	System.out.println("Creating actor graph ... This may take a few minutes");

	EdgeDataGraph g = createActorGraph("top250.txt");
	String center = "Kevin Bacon";
	boolean quit = false;

	Scanner userInput = new Scanner(System.in);
	String [] goodInput = {"s", "p", "f", "o", "c", "q"};
	
	while(!quit)
	{
	    System.out.println("\n=============================================");
	    System.out.println("Current center: " + center);
	    System.out.println("=============================================");
	    System.out.println("s) Get statistics for the center");
	    System.out.println("p) Find a path to another actor");
	    System.out.println("f) Find a famous path to another actor");
	    System.out.println("o) Find an abscure path to another actor");
	    System.out.println("c) Change the center");
	    System.out.println("q) Quit");

	    System.out .print("Please select an option: ");
	    String choice = userInput.next();
	    while (!Arrays.asList(goodInput).contains(choice))
	    {
		System.out.println("Invalid choice: please enter s, p, f, o, c, q");
		System.out .print("Please select an option: ");
		choice = userInput.next();
	    }

	    // Handle user choices
	    if (choice.equals("q"))
		quit = true;
	    else if (choice.equals("c"))
		center = actorInput(g);
	    else if (choice.equals("p"))
	    {
		String toActor = actorInput(g);
		ArrayList<String> path = findShortestPath(g, center, toActor);
		if (path == null)
		    System.out.println("No path found!");
		else
		{
		    int length = path.size() - 1;
		    System.out.println(toActor + "'s " + center + " number is: " + length);
		    printPath(g, path);
		}
	    }
	    else if (choice.equals("s"))
	    {
		ArrayList<Integer> dist = getDistanceDistribution(g, center);
		int sumDist = 0;
		int totalConnected = 0;

		for (int i = 0; i < dist.size(); i++)
		{
		    sumDist += (i*dist.get(i));
		    totalConnected += dist.get(i);
		}

		double avg = (double) sumDist / totalConnected;
		int maxDist = dist.size() - 1;
		double perc = 100.0 * totalConnected / g.getVertices().size();

		System.out.println("\nAverage distance: " + avg);
		System.out.println("Max distance: " + maxDist);
		System.out.println("Percent connected: " + perc);
	    }
	    else if (choice.equals("f"))
	    {
		String toActor = actorInput(g);
		ArrayList<String> shortPath = findShortestPath(g, center, toActor);
		if (shortPath == null)
		    System.out.println("No path found!");
		else
		{
		    ArrayList<String> path = findFamousPath(g, center, toActor, shortPath.size());
		    printPath(g, path);
		}
	    }
	    else if (choice.equals("o"))
	    {
		String toActor = actorInput(g);
		ArrayList<String> path = findObscurePath(g, center, toActor);
		if (path == null)
		    System.out.println("No path found!");
		else
		    printPath(g, path);	
	    }
	}
    }
}

class ByWeight implements Comparator<String>
{
    HashMap<String,Integer> weights;
    public ByWeight(HashMap<String,Integer> weights)
	{
	    this.weights=weights;
	}

    @Override
    public int compare(String a1, String a2)
    {
	// FILL IN 
	if( weights.get(a1)>weights.get(a2))
	    return 1;
	else if(weights.get(a1)<weights.get(a2))
	    return -1;
	else
	    return 0;
    }
}
