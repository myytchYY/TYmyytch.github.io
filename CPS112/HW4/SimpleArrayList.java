import java.util.ListIterator;

public class SimpleArrayList extends SimpleAbstractList implements Iterable<Integer>
{
    protected int capacity;
    protected int [] items;

    public SimpleArrayList()
    {
	this(10);
    }

    public SimpleArrayList(int initialCapacity)
    {
	super();

	capacity = initialCapacity;
	items = new int[capacity];
    }

    private void resize()
    {
	// Copy items to temporary array
	int[] tmp =  new int[capacity];
	for (int i = 0; i < capacity; i++)
	    tmp[i] = items[i];

	// Update capacity
	capacity = (capacity * 3) / 2 + 1;
	items = new int[capacity];

	for(int i = 0; i < tmp.length; i++)
	    items[i] = tmp[i];
    }
	    
    public void add(int item)
    {
	add(size(), item);
    }

    public void add(int index, int item)
    {
	if (numItems == capacity)
	    resize();

	// Shift right
	for (int i = numItems - 1; i >= index; i--)
	    items[i+1] = items[i];

	items[index] = item;
	++numItems;
    }

    public int remove(int index)
    {
	int item = items[index];

	// Shift items left
	for (int i = index + 1; i < numItems; i++)
	    items[i-1] = items[i];

	--numItems;
	
	return item;
    }

    public int get(int index)
    {
	return items[index];
    }

    public ListIterator <Integer> iterator()     
    { return new SimpleArrayIterator (this);     }

    public ListIterator <Integer> iterator(int c)     
    { return new SimpleArrayIterator (c,this);     }

    public SimpleArrayList reverse()
    {
	SimpleArrayList copyList = new SimpleArrayList(this.capacity);
	ListIterator iter = iterator(size()-1); 
	while(iter.hasPrevious())  
	    {int newValue = (int) iter.previous();
		copyList.add(newValue);
	        }
	return copyList;
    }
    
    public static void main(String [] args)     
    {
	SimpleArrayList testList = new SimpleArrayList();
	for (int i = 0; i<10;i++)
	    {
		testList.add(i*2);
	    }

	System.out.println("** USING FOR LOOP **"); 
	for (Integer item : testList)     
	    System.out.println(item);

	System.out.println("\n** USING WHILE LOOP **"); 
	ListIterator iter = testList.iterator(); 
	while(iter.hasNext())     
	    System.out.println(iter.next());

	System.out.println("\n**REVERSE USING FOR LOOP **");
	SimpleArrayList reverseList = testList.reverse();

	//System.out.println(reverseList);

	for (Integer item: reverseList)
	    System.out.println(item);
	
    } 


}


class SimpleArrayIterator implements ListIterator<Integer>
{
    private SimpleArrayList thelist;
    private int position;

    public SimpleArrayIterator (SimpleArrayList myArrayList)
    {
	thelist = new SimpleArrayList();
	for (int i = 0; i< myArrayList.size();i++)
	    thelist.add(myArrayList.get(i));

        position = 0;
    }

    public SimpleArrayIterator (int index,SimpleArrayList myArrayList)
    {
	thelist = new SimpleArrayList();
	for (int i = 0; i< myArrayList.size();i++)
	    thelist.add(myArrayList.get(i));

        position = index;
    }

    @Override
    public boolean hasNext()
    {
        return position <thelist.size();
     }

   
    @Override
    public Integer next()
    {
	int value = thelist.get(position);
	++position;
	return value;
    }

    @Override
    public boolean hasPrevious()
    {
        return position >= 0;
     }

   
    @Override
    public Integer previous()
    {
	int value = thelist.get(position);
	--position;
	return value;
    }

    @Override
    public void remove()
    {
  	throw new UnsupportedOperationException("remove not supported");
    }

    @Override
    public int nextIndex()
    {
	throw new UnsupportedOperationException("nextIndex not supported");
    }
    
    @Override
    public int previousIndex()
    {
	throw new UnsupportedOperationException("nextIndex not supported");
    }

    @Override
    public void set(Integer i)
    {
	throw new UnsupportedOperationException("set not supported");
    }

    @Override
    public void add(Integer i)
    {
	throw new UnsupportedOperationException("add not supported");
    }
}
    

  	
