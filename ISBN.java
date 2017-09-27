/**
 * ISBN.java
 *
 * Part of homework 1, question 2
 */
import java.util.Scanner;// to read the input

public class ISBN
{

    /**
     *main function to promp the user for isbn (either 9-digit or 12-digit) and then call the correct function to calculate the next digit (10th or 13th); 
     */
    public static void main(String[] args)
    {
	boolean Enter = true;
	Scanner scanner = new Scanner(System.in);
	System.out.print("Please enter a 9-digit or a 12-digit ISBN: ");
	long isbn = scanner.nextLong(); 
	String StringIsbn = Long.toString(isbn);//to use string.length() method
	while(Enter)
	    {
		if (StringIsbn.length()==9)
		    {int isbn9 = (int)isbn;
			isbn10(isbn9);
			Enter = false;}
		else if (StringIsbn.length()==12) 
		    {isbn13(isbn);Enter = false;}
		else
		    {System.out.print("Invalid ISBN. Try again (y/n)?: " );
			String again = scanner.next() ;
			if (again.equals("n"))
			    { Enter = false;}
			else
			    {	System.out.print("Please enter a 9-digit or a 12-digit ISBN: ");
			        isbn = scanner.nextLong(); 
			        StringIsbn = Long.toString(isbn);}
		    }
	    }	
    }

    /**  
     * Simple function to calculate the 10th digit of a 9-digit isbn
     *  
     * @param isbn9 int, the given 9-digit isbn to calculate its 10th digit  
     *  
     */ 
    public static void isbn10(int isbn9)
    {
	int digit = 0;
	int sum = 0;//calculate the sum part in the function first for easier calculation later 
	for(int i = 1; i<=9; i++)
	    {
		if (i>=2)
		    { int a =  isbn9 % (int) Math.pow(10,i);
			double b = a / Math.pow(10,i-1);
			digit = (int) b;}
		else
		    {digit = isbn9 % 10;}
		sum += i*digit;
		//("checkpoint") System.out.println("digit: "+ Integer.toString(digit)+ "sum: "+ Integer.toString(sum));
	    }
	int tenth = sum % 11;//given formula 
	if(tenth==10)
	    {System.out.println("The 10th digit is X");}//deal with the exception case when the result is 10
	else
	    {System.out.println("The 10th digit is "+Integer.toString(tenth));}
    }


    /**  
     * Simple function to calculate the 13th digit of a 12-digit isbn
     *  
     * @param isbn12 long, the given 12-digit isbn to calculate its 13th digit  
     *  
     */ 
    private static void isbn13(long isbn12)
    {   
	int sum = 0; //calculate the sum part in the function first for easier calculation later 
	for(int i = 1; i<=12; i++)
	    {
		int digit = 0;
		if (i>=2)
		    { long a =  isbn12 % (long) Math.pow(10,i);
			double b = a / Math.pow(10,i-1);
			digit = (int) b;}
		else
		    {digit = (int) (isbn12 % 10);}
		if(i%2 == 0)
		    {sum+= 3* digit;}
		else
		    {sum+=digit;}
		//(check)System.out.println("digit: "+ Integer.toString(digit)+ " sum: "+ Integer.toString(sum));
	    }
	int D13th = 10 -(sum%10);//given formula 
	if (D13th ==10)
	    {System.out.println("The 13th digit is 0");}//deal with the exception case when the result is 10
	else
	    {System.out.println("The 13th digit is "+ Integer.toString(D13th));}
    }
}

