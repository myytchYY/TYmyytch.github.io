import java.util.HashMap;
import java.util.ArrayList;

/**
 * Basic Graph data structure
 * Uses adjacency list representation
 * 
 * The key is an Object (i.e., vertex)
 * The value is an ArrayList of vertices
 * that are adjacent to the key
 */
class Graph
{
    protected HashMap<Object, ArrayList<Object>> adjList;
    
    public Graph()
    {
	adjList = new HashMap<Object, ArrayList<Object>>();
    }

    /**
     * Adds a vertex to the graph if it is not
     * Already in the graph.
     */
    public void addVertex(Object vertex)
    {
	if (!adjList.containsKey(vertex))
	    adjList.put(vertex, new ArrayList<Object>());
    }

    /** 
     * Add the edge denoted by endpoints vertex1 and
     * vertex2.  Make sure the vertices are in the
     * graph first
     */
    public void addEdge(Object vertex1, Object vertex2)
    {
	addVertex(vertex1);
	addVertex(vertex2);

	if (!isAdjacent(vertex1, vertex2))
	    adjList.get(vertex1).add(vertex2);
    }

    /**
     * Determine if two vertices are adjacent to each other
     */
    public boolean isAdjacent(Object vertex1, Object vertex2)
    {
	if (!adjList.containsKey(vertex1))
	    return false;
	else if (!adjList.containsKey(vertex2))
	    return false;
	else
	    return adjList.get(vertex1).contains(vertex2);
    }

    /**
     * Returns all neighbors of given vertex.
     * Returns as list of Strings where Strings
     * represent the vertex label or name
     */
    public ArrayList<String> getNeighbors(Object vertex)
    {
	ArrayList<String> neighbors = new ArrayList<String>();

	for (Object v : adjList.get(vertex))
	    neighbors.add(v.toString());

	return neighbors;
    }

     /**
     * Returns all vertices in the graph.
     * Returns as list of Strings where Strings
     * represent the vertex label or name
     */
    public ArrayList<String> getVertices()
    {
	ArrayList<String> vertices = new ArrayList<String>();

	for (Object v : adjList.keySet())
	    vertices.add(v.toString());

	return vertices;
    }

     /**
     * Returns all edges in a graph.
     * Returns as list of pairs of vertices
     */
    public ArrayList<Pair<String, String>> getEdges()
    {
	ArrayList<Pair<String, String>> edges = new ArrayList<Pair<String, String>>();
	for (Object v1 : adjList.keySet())
	{
	    String vert1 = v1.toString();
	    for (Object v2 : adjList.get(v1))
	    {
		String vert2 = v2.toString();
		edges.add(new Pair(vert1, vert2));
	    }
	}

	return edges;
    }
}
