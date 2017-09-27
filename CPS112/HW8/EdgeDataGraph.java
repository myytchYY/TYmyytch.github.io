import java.util.HashMap;
import java.util.ArrayList;

class EdgeDataGraph extends Graph
{
    protected HashMap<ArrayList<String>, String> edgeData;

    public EdgeDataGraph()
    {
	// FILL IN
	super();
	edgeData= new HashMap<ArrayList<String>, String>();
    }

    public void addEdge(String actor1, String actor2, String movie)
    {
	// FILL IN
	addEdge(actor1,actor2);

	ArrayList<String> key = new ArrayList<String>();
	key.add(actor1);
	key.add(actor2);

	if(!isAdjacent(actor1,actor2))
	    { edgeData.put(key, movie);
		adjList.get(actor1).add(actor2);
	    }

    }

    public String getEdgeData(String actor1, String actor2)
    {
	// FILL IN
	if (isAdjacent(actor1,actor2))
	    {
		ArrayList<String> key = new ArrayList<String>();
		key.add(actor1);
		key.add(actor2);
		return edgeData.get(key);
	    }
	else
	    return null;             
    }
}
