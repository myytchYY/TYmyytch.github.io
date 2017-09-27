class Fibonaccik
{

    public static int helper(int level, int n)
    {
	int[] storeVals = new int[n+3];

	for (int i = 0; i<n+1;i++)
	    storeVals[i]=-1;

	storeVals[0] = 0;
	storeVals[1] = 1;

	return fib(level,n,storeVals);
    }
    
    public static int fib(int level,int n, int[] vals)
    {
	if(vals[n]>=0)
	    return vals[n];
	else
	    {
		vals[n]=0;
		for (int i = 1;i<=level;i++)
		    if(n-i>=0)
			vals[n] += helper(level,n-i);

		return vals[n];
	    }
    }

    public static void main(String[]args)
    {
	String s = "";
	for (int i = 0;i<20;i++)
	    s+= helper(Integer.parseInt(args[0]),i) + " ";
	System.out.println(s);
	
    }
}
