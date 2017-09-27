import java.util.LinkedList;

abstract class Agenda
{
    LinkedList<Location> agenda;
    int length;

    public abstract void addLocation(Location loc);
 
    public abstract Location getLocation();

    public abstract boolean isEmpty();

    public abstract void clear();
    
}

class StackAgenda extends Agenda
{
    public StackAgenda()
    {
	length = 0;
	agenda = new LinkedList<Location>();
    }
    public void addLocation(Location loc)
    {
	agenda.add(loc);
	++length;
    }
 
    public Location getLocation()
    {
	--length;
	return agenda.removeLast();
    }

    public boolean isEmpty()
    {
	return length==0;
    }

    public void clear()
    {
	while (! isEmpty())
	    {
		agenda.removeFirst();
		--length;
	    }
    }
}

class QueueAgenda extends Agenda
{
    public QueueAgenda()
    {
	length = 0;
	agenda = new LinkedList<Location>();
    }
    public void addLocation(Location loc)
    {
	agenda.add(loc);
	++length;
    }
 
    public Location getLocation()
    {
	--length;
	return agenda.removeFirst();
    }

    public boolean isEmpty()
    {
	return length==0;
    }

    public void clear()
    {
	while (! isEmpty())
	    {
		agenda.removeFirst();
		--length;
	    }
    }


}











