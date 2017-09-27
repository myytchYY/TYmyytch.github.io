public class Location
{
    int row;
    int col;

    public Location(int r, int c)
    {
	row = r;
	col = c;
    }

    public int getRow()
    {
	return row;
    }

    public int getColumn()
    {
	return col;
    }
    
    @Override
    public boolean equals(Object obj)
    {
	if (obj == null)
	    return false;
	else if (this == obj)
	    return true;
	else if (!(obj instanceof Location))
	    return false;

	Location other = (Location) obj;
	return this.getRow() == other.getRow() &&
	       this.getColumn() == other.getColumn();
    }

    @Override
    public String toString()
    {
	String s = "(" + Integer.toString(getRow()) + " ," + Integer.toString(getColumn()) + ")";

	return s;
    }
}
