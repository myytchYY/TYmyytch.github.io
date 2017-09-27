/**
 * GuessingGame.java
 *
 * Part of homework 1, question 1
 */

import java.util.Random;// to generate random number
import java.util.Scanner;// to read the input

public class GuessingGame
{
    public static void main(String[] args)// main function to run the game.
    {
	Random randNum = new Random();
	int numb = randNum.nextInt(100) + 1;//generate a random number to guess
	boolean keepEnter = true;
	Scanner scanner = new Scanner(System.in);
	int guesses = 0;//counting the number of guesses
	while (keepEnter)
	    {
	        guesses ++;
		System.out.print("Please enter a number between 1-100 (or q to stop): ");
		String input = scanner.nextLine();
		if (input.equals("q"))//allow the player to stop the game
		    { keepEnter = false;
			System.out.println("Thank you for playing. The correct answer is "+Integer.toString(numb));}
		else
		    {
			int guessNum = Integer.parseInt(input) ;
			if(guessNum > numb)
			    {System.out.println("Incorrect, too high");}
			else if (guessNum < numb)
			    {System.out.println("Incorrect, too low");}
			else
			    {System.out.println("That's correct. It took you "+Integer.toString(guesses)+ " guesses");
				System.out.print("Would you like to play again (y/n)? ");//asking if the player wants a new game
				String again = scanner.nextLine();//reset the game
				if (again.equals("y"))
				    {numb = randNum.nextInt(100) + 1;
					guesses = 0;}
				else
				    {keepEnter = false;}
			    }
		    }	    
	    }
    }
}
