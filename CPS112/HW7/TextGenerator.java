import java.util.Random;
import java.util.ArrayList;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

class TextGenerator
{
    protected ChainingHashMap countTable;
    protected ChainingHashMap totalTable;
    protected int totalWords;

    public TextGenerator()
    {
	countTable = new ChainingHashMap(1000);
	totalTable = new ChainingHashMap(1000);
	totalWords = 0;
    }

    public void train(String text)
    {
	// Splits text based on whitespace
	String [] words = text.split("\\s+");

	// FILL IN THE REST
	for(int i =0; i<words.length;i++)
	    {
		String word = words[i];
		//System.out.println(word);
		++ totalWords;
		if(totalTable.containsKey(word))
		    totalTable.put(word,(int)totalTable.get(word) +1);
		else
			totalTable.put(word,1);

		if( i!=words.length-1)
		    {
			if(countTable.containsKey(word))
			    {
				ChainingHashMap value = (ChainingHashMap)countTable.get(word);
				//System.out.println("check"+ value.getKeyValues());
				if(value.containsKey(words[i+1]))
				    { 
					//System.out.println("adding!");
					int old = (int)value.get(words[i+1]);
					value.put(words[i+1],old+ 1 );
				    }
				else
				    value.put(words[i+1],1);
			    }
			else
			    {
				ChainingHashMap value = new ChainingHashMap(1000);
				value.put(words[i+1],1);
				countTable.put(word,value);
			    }}
		//System.out.println(totalWords);
	    }
	//System.out.println(totalTable.getKeyValues());
	//System.out.println(countTable.getKeyValues());
    }

    /**
     * Generates a random number between 0.0 and 1.0
     * Then finds a random word in countList based on cumulative
     * probability
     */
    public String sampleWord(ArrayList<Pair<Object, Object>> countList, int totalCount)
    {
	Random rand = new Random();
	double randNum = rand.nextDouble();
	
	double probSum = 0.0;
	for (Pair p : countList)
	{
	    Integer num = (Integer) p.y;
	    probSum += (num.doubleValue() / (double)totalCount);
	    if (randNum < probSum)
		return (String) p.x;
	}

	return null;
    }

    public String generateText(int numWords)
    {
	String text = "";
	String word = sampleWord(totalTable.getKeyValues(), totalWords);
	text = text + word + " ";

	// FILL IN THE REST
	for (int i = 1; i<numWords; i++)
	   {
	       HashMap C = (HashMap)countTable.get(word);
	       //System.out.println(word);
	       int num = (int)totalTable.get(word);
	       String next = null;
	       while (next ==null)
		   {   next = sampleWord(C.getKeyValues(), num);}
	       text += next + " ";
	       word = next;
	       //System.out.println(word);
	   }
	return "..."+text+"...";
    }

    public static void main(String [] args)
    {
	File file = new File(args[0]);

	Scanner scan = null;
	try
        {
	    scan = new Scanner(file);
	}
	catch (FileNotFoundException fnf)
	{
	    System.err.println("Input file not found");
	    System.exit(1);
	}

	scan.useDelimiter("\\Z");
	String text = scan.next();

	TextGenerator t = new TextGenerator();
	t.train(text);
	System.out.println(t.generateText(100));
    }
}
