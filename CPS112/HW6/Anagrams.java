import java.util.ArrayList;

class Anagrams
{
    public static int fac(int n)     
    {
    if (n == 1)     
	return 1; 
    else
	return fac(n - 1) * n;
    }


    public static ArrayList generateAnagrams(String s)
    {
	int length = s.length();
        ArrayList anagrams = new ArrayList(fac(length));
	if(length==1)
	    { anagrams.add(s);}
	else
	    {
		for (int i = 0;i<length-1;i++ )
		    {
			String w = s.substring(i,i+1);
			String rest = s.substring(0,i)+s.substring(i+1,length);
			//System.out.println(w);
			//System.out.println(rest);
		        ArrayList temp= generateAnagrams(rest);
		        for (int j=0;j<temp.size();j++)
			    {
				String new1 = w + temp.get(j);
				if (!anagrams.contains(new1))
				    anagrams.add(new1);
				String new2 =temp.get(j)+w;
				if (!anagrams.contains(new2))
				    anagrams.add(new2);
			    }
		    }
	    }
	return anagrams;
    }

    public static void main (String[]args)
    {
	String given = args[0];
        ArrayList result = generateAnagrams(given);
	for(int i =0;i<result.size();i++)
	    System.out.println(result.get(i));
    }

}
