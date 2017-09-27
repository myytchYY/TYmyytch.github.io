/**
 * Simple class to hold pairs of objects.
 * Uses generics to hold pairs of any
 * type, not primitive data types.
 *
 * Note: x and y are public so they
 * can be accessed directly as in:
 *
 * Pair<String, Integer> p = new Pair<String, Integer>("Hi", new Integer(13));
 * String s = p.x;
 * Integer g = p.y;
 *
 *
 * ------------------------------------------------------------------
 * VERY VERY IMPORTANT: This class does not override hashCode
 * so it is NOT a good data structure to use as the key in a HashMap
 *-------------------------------------------------------------------
 */
public class Pair<X, Y>
{
    public final X x;
    public final Y y;

    public Pair(X x, Y y)
    {
	this.x = x;
	this.y = y;
    }
    
    @Override
    public boolean equals(Object obj)
    {
	if (obj == null)
	    return false;
	else if (this == obj)
	    return true;
	else if (!(obj instanceof Pair))
	    return false;

	Pair<X, Y> other = (Pair<X, Y>) obj;
	return this.x.equals(other.x) && this.y.equals(other.y);
    }

    @Override
    public String toString()
    {
	String s = "(" + x + ", " + y + ")";

	return s;
    }
}
