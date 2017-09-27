import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import javax.swing.JPanel;
import javax.swing.border.LineBorder;

class Square extends JPanel
{
    protected int height;
    protected int width;
    
    public Square(int w, int h)
    {
	height = h;
	width = w;
	
	// All squares have a black border
	setBorder(new LineBorder(Color.BLACK));

	// Set default background color
	setBackground(Color.WHITE);
    }

    public void setColor(Color color)
    {
	setBackground(color);
	repaint();
    }
        
    @Override
    protected void paintComponent(Graphics g)
    {
	super.paintComponent(g);

    }
    
    @Override
    public Dimension getPreferredSize()
    {
	return new Dimension(this.width, this.height);
    }

    @Override
    public Dimension getMinimumSize()
    {
	return new Dimension(this.width, this.height);
    }
    
    @Override
    public Dimension getMaximumSize()
    {
	return new Dimension(this.width, this.height);
    }

    
}


    
