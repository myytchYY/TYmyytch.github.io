class Palindrome{

    public static boolean check(String word)
    {
	String s = word.replaceAll("[^a-zA-Z\\s]","").replace(" ","").toLowerCase();
	//System.out.println(s);
	if (s.length()==1)
	    return true;
	else if (s.charAt(0)==s.charAt(s.length()-1))
		return check(s.substring(1,s.length()-1)) ;
	else
	    return false;
    }

    public static void main(String[]args)
    {System.out.println(check(args[0]));
    }
}
