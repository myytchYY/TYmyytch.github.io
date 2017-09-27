import org.junit.Test;
import org.junit.Before;
import static org.junit.Assert.*;

import static org.junit.runner.JUnitCore.runClasses;
import org.junit.runner.Result;

/**
 * Test cases for ArrayBackedList class
 *
 * Note: Not explicitly testing isEmpty and get methods
 *       isEmpty should not need to be checked as long as size is working.
 *
 *       Even though size is simple to implement, it is checked as an
 *       additional check on the add/remove methods.
 * 
 *       The get method is used in many of the tests so if those test
 *       fail it is possible it is due to get not working.
 *       many of the test cases use this functionality
 */
public class TestList
{
    ArrayBackedList<Integer> intList;

    /**
     * Resets the list to be empty
     */
    @Before
    public void reinitializeList()
    {
	intList = new ArrayBackedList<Integer>(Integer[].class);
    }

    /**
     * Test the size method
     */
    @Test
    public void testSize()
    {
	assertEquals("Size of list is not 0", 0, intList.size());

	// Add one item and make sure size is okay
	intList.add(12);
	assertEquals("Size of list is not correct, should be 1", 1, intList.size());

	// Remove the item
	intList.remove(0);
	assertEquals("Size of list after remove is not 0", 0, intList.size());
    }

    /**
     * Testing to make sure
     * add (the append version) in a basic sense works
     */
    @Test
    public void testAdd1()
    {
	intList.add(1);
	assertEquals("Only item in list is not correct", new Integer(1), intList.get(0));

	intList.add(2);
	assertEquals("Either item was not added to end of list or get is wrong", new Integer(2), intList.get(1));	
    }
    
    /**
     * Testing to make sure resize works correctly with
     * add (the append version)
     */
    @Test
    public void testAdd2()
    {
	for (int i = 0; i < 12; i++)
	    intList.add(i);

	assertEquals("Resize probably did not work correctly", 12, intList.size());
	assertEquals("Resize problem, wrong value at end of list", new Integer(11), intList.get(11));
    }

    /**
     * Testing add(index, item) for basic functionality
     */
    @Test
    public void testAdd3()
    {
	// First add a bunch of items via append
	for(int i = 0; i < 5; i++)
	    intList.add(i);

	intList.add(2, 14);

	assertEquals("Size is incorrect after inserting item", 6, intList.size());
	assertEquals("Item not inserted into correct position", new Integer(14), intList.get(2));
	assertEquals("Item not shifted correctly", new Integer(2), intList.get(3));
	assertEquals("Last item not shifted correctly", new Integer(4), intList.get(5));
    }

    /**
     * Testing add(index, item) with resize
     */
    @Test
    public void testAdd4()
    {
	// First add a bunch of items via prepend
	for(int i = 0; i < 12; i++)
	    intList.add(0, i);

	assertEquals("add(index, item) method probably did not resize", 12, intList.size());
	
    }

    /**
     * Testing remove(index) method
     */
    @Test
    public void testRemove()
    {
	for (int i = 0; i < 6; i++)
	    intList.add(i*2);

	int item = intList.remove(2);

	assertEquals("Item not returned or wrong item returned", 4, item);
	assertEquals("Size incorrect after remove", 5, intList.size());
	assertEquals("Items not shifted on remove", new Integer(6), intList.get(2));
    }
    
    /**
     * Testing set(index,item)
     */
    @Test
    public void testSet()
    {
	for(int i = 0; i < 6; i++)
	    intList.add(i);
	
	intList.set(0,10);
	int newItem = intList.get(0);
	assertEquals("set(index, item) fails", 10, newItem);
    }

    /**
     * Testing indexOf(index) and reverse()
     */
    @Test
    public void testIndexReverse()
    {
	for (int i = 0; i < 6; i++)
	    {    intList.add(i);
	    }
	//test indexOf
	int idx =  intList.indexOf(4);
	assertEquals("Get wrong Index", 4, idx);

	//test reverse 
        ArrayBackedList newList=intList.reverse();
	for (int i = 0; i<newList.size();i++)
	    {
		System.out.println(newList.get(i));
	    }
    }

     /**
     * Testing equals()
     */
    @Test
    public void testEquals()
    {
	for (int i = 0; i < 6; i++)
	    intList.add(i);
	assertEquals("Different types return true", false, intList.equals(5));

        ArrayBackedList newList=intList.reverse();
	assertEquals("reversed list returns true", false, intList.equals(newList));

	ArrayBackedList copyNewList=intList.reverse();
	assertEquals("Same lists return false", false, intList.equals(newList));
    }

   /**
     * Testing shuffle()
     */
    @Test
    public void testShuffle()
    {
	for (int i = 0; i < 6; i++)
	    {    
		intList.add(i);
	    }
	System.out.println("Shuffle Time");
	intList.shuffle();
	for (int i = 0; i<intList.size();i++)
	    {
		System.out.println(intList.get(i));
	    }
    }

    public static void main(String [] args)
    {
	Result res = runClasses(TestList.class);
	System.out.println("Tests run = " + res.getRunCount() +
			   "\nTests failed = " + res.getFailures());
    }
}
    
		
   
