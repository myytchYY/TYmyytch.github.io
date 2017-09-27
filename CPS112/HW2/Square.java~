import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import javax.swing.JPanel;
import javax.swing.border.LineBorder;

class Square extends JPanel
{
    // Size of each square
    private static final int WIDTH = 50;
    private static final int HEIGHT = 50;

    // Color of the square
    protected Color fillColor = Color.WHITE;

    // Is there a frog on the square or not
    protected boolean hasFrog = false;

    // Specific Frog instance or null if no Frog
    protected Frog frog = null;

    // Is the fly on the square or not
    protected boolean hasFly = false;

    // Specific Fly instance or null if no frog
    protected Fly fly = null;

    // Is the fly protected from being eaten or not
    protected boolean flySafe = false;

    // Is the fly home or not
    protected boolean flyHome = false;

    public Square()
    {
	// All squares have a black border
	setBorder(new LineBorder(Color.BLACK));

	// Default fill color is WHITE
	// Set background color
	setBackground(fillColor);
    }

    public void addFly(Fly f)
    {
	// FILL IN HERE
	hasFly = true;
	fly = f;
	repaint();
    }
    
    public void removeFly()
    {
	// FILL IN HERE
	hasFly = false;
	repaint();
    }
    
    public boolean addFrog(Frog f)
    {
	// FILL IN HERE
	if (hasFrog == false)
	    {hasFrog = true;
		frog = f;
		repaint();
		return true;}
	else
	    {
		repaint();
		return false;
	    }

    }

    public void removeFrog()
    {
	// FILL IN HERE
	hasFrog = false;
	repaint();
    }

    public boolean flyIsHome()
    {
	// A regular square is not a home square so always return false
	return false;
    }
    
    @Override
    protected void paintComponent(Graphics g)
    {
	super.paintComponent(g);

	if (hasFrog)
	    g.drawImage(frog.getImage(), 0, 0, null);
	    
	else if (hasFly)
	    g.drawImage(fly.getImage(), 0, 0, null);
    }
    
    @Override
    public Dimension getPreferredSize()
    {
	return new Dimension(WIDTH, HEIGHT);
    }
}

class HomeSquare extends Square
{
    protected Color fillColorH = Color.RED;
        protected boolean flyHome = true;
    
    public HomeSquare()
    {
	setBorder(new LineBorder(Color.BLACK));

	// Set background color
	setBackground(fillColorH);
    }

    @Override
    public boolean flyIsHome()
    {
        return true;        
    }
}


    
