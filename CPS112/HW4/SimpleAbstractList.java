public abstract class SimpleAbstractList
{
    protected int numItems;

    public SimpleAbstractList()
    {
	numItems = 0;
    }

    public int size()
    {
	return numItems;
    }

    public boolean isEmpty()
    {
	return numItems == 0;
    }

    public abstract void add(int item);

    public abstract void add(int index, int item);

    public abstract int remove(int index);

    public abstract int get(int index);
}
