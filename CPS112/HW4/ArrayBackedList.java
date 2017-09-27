import java.util.AbstractList;
import java.lang.reflect.Array;
import java.util.Random;

/*
 * DO NOT MODIFY  CONSTRUCTORS OR RESIZE METHOD
 */
public class ArrayBackedList <T> extends AbstractList <T> //section 1 part a).
{
    protected int capacity;
    protected T [] items;
    protected Class <T[]> clazz;

    public ArrayBackedList(Class<T[]> c)
    {
	// Call parameterized version of constructor
	this(c, 10);
    }

    public ArrayBackedList(Class<T[]> c, int initialCapacity)
    {
	super();

	capacity = initialCapacity;
	clazz = c;
	items = clazz.cast(Array.newInstance(clazz.getComponentType(), capacity));
    }

    private void resize()
    {
	// Copy items to temporary array
	T [] tmp =  clazz.cast(Array.newInstance(clazz.getComponentType(), capacity));
	int oldCapacity = capacity;
	
	for (int i = 0; i < capacity; i++)
	    tmp[i] = items[i];

	// Update capacity
	capacity = (capacity * 3) / 2 + 1;
	items = clazz.cast(Array.newInstance(clazz.getComponentType(), capacity));

	// Copy items back to items array
	for(int i = 0; i < oldCapacity;i++)
	    items[i] = tmp[i];
    }

    //section 1 part d).
    @Override
	public boolean add(T item)
    {
	add(size(), item);
	return true;
    }

    @Override
	public void add(int index, T item)
    {
	if (modCount == capacity)
	    resize();


	// Shift right
	for (int i = this.size() - 1; i >= index; i--)
	    items[i+1] = items[i];

	items[index] = item;
	++modCount;
    }

    @Override
	public T remove(int index)
    {
	T item = items[index];

	// Shift items left
	for (int i = index + 1; i < this.size(); i++)
	    items[i-1] = items[i];

	--modCount;
	
	return item;
    }

    @Override
	public T get(int index)
    {
	return items[index];
    }

    //section 2 part c).
    public boolean isEmpty()
    {	if (modCount==0)
	   return true;
	else
	    return false;
    }

    public int size()
    {
	return modCount;
    }

    //section 1 part e).
    @Override
	public T set(int index, T item)
    {
	T previous = items[index];
	items[index] = item;
	return previous;
    }

    //section 2 part a
    @Override
	public int indexOf (Object item)
	{
	    int idex = -1;
	    for (int i =0; i<capacity;i++)
		{
		    if(items[i] == item)
			{
			    idex = i;
			    break;
			}
		}
	    return idex;
	}

    //section 2 part b
    @Override
	public boolean equals(Object obj)    
    {
	if (obj == null)     
	    return false; 
	else if (!(obj instanceof ArrayBackedList))     
	    return false;
	else if (this == obj)    
	    return true;
        else{
	     ArrayBackedList theList = (ArrayBackedList) obj;
	     boolean same = true;		
	     if(modCount!=theList.size())
		 {
		     same = false;
		 }
	     else
		 {
		 for (int i =0; i<capacity;i++)
		     {
			 if(items[i]!=theList.get(i))
			     {same = false; 
				 break;}
		     }
		 }
	     return same;
	}
    }

    /*section 2 part c
     *input: None; output: None; 
     *efficiency: O(n).
     */
    public void shuffle()
    {
	Random rand = new Random(); 
	for (int i = modCount-1;i>0;i--)
	    {
		int newIdx = rand.nextInt(i);
		T temp = items[newIdx]; 
	        items[newIdx] = items[i];
		items[i] = temp;
	    }
    }
    
    /*section 2 part d
     *input: None; output: T[]
     *efficiency: O(n)
     */
    public ArrayBackedList reverse()
    {
	ArrayBackedList copy = new ArrayBackedList(clazz, this.capacity);
	for (int i =0;i<modCount;i++)
	    {
		copy.add(items[modCount-1-i]);
	    }
	return copy;
    }
}
