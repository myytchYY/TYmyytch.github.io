import java.awt.Point;
import java.awt.Polygon;
import java.awt.Graphics;
import java.awt.Color;
import javax.swing.*;

public class Sierpinski extends JFrame
{
    protected static Graphics graphics;
    protected static int level;

    protected static final int SIZE = 243;
    
    public Sierpinski(int level)
    {
	super("Sierpinski Carpet");

	this.level = level;

	setSize(SIZE, SIZE + 24);
	setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	setVisible(true);
    }
	
    public static Point[] points(Point p1, Point p2)
    { 	Point[] k = new Point[2];


	k[0]= new Point((p2.x-p1.x)/3+p1.x, (p2.y-p1.y)/3+p1.y); 
	k[1]= new Point((k[0].x+p2.x)/2,(k[0].y+p2.y)/2); 

	return k;}

    public static void drawSquare(Point p1, Point p2, int level, Graphics g)
    {
	// FILL IN HERE 
	if (level == 0) 
	    {   
		Point p3 = new Point(p1.x,p2.y);
		Point p4 = new Point(p2.x,p1.y);
		Polygon p = new Polygon();    
		p.addPoint(p1.x, p1.y);    
		p.addPoint(p3.x, p3.y); 
		p.addPoint(p2.x, p2.y);    
		p.addPoint(p4.x, p4.y);
		graphics.drawPolygon(p); }

	else {     
	    Point[] points = points(p1,p2);
	    Point x1 = new Point(p1.x,points[0].y);
	    Point x2 = new Point(p1.x,points[1].y);
	    Point x3 = new Point(points[0].x,p1.y);
	    Point x4 = new Point(points[0].x,points[1].y);
	    Point x5 = new Point(points[0].x,p2.y);
	    Point x6 = new Point(points[1].x,p1.y);
	    Point x7 = new Point(points[1].x,points[0].y);
	    Point x8 = new Point(points[1].x,p2.y);	    
	    Point x9 = new Point(p2.x,points[0].y);
	    Point x10 = new Point(p2.x,points[1].y);

	    //row0
	    drawSquare(p1, points[0], level - 1, g);
	    drawSquare(x1,x4,level - 1, g);
	    drawSquare(x2,x5,level - 1, g);
	    //row1
	    drawSquare(x3,x7,level - 1, g);
	    drawSquare(x4,x8,level - 1, g);
	    //row2
	    drawSquare(x6,x9,level - 1, g);
	    drawSquare(x7,x10,level - 1, g);
	    drawSquare(points[1],p2,level - 1, g);
	    
}	
    }

    @Override
    public void paint(Graphics g)
    {
	graphics = g;

	Point p1 = new Point(0, 24);
	Point p2 = new Point(SIZE, SIZE + 24);

	drawSquare(p1, p2, level, graphics);
    }
    
    public static void main(String [] args)
    {
	int level = Integer.parseInt(args[0]);
	Sierpinski s = new Sierpinski(level);	

    }
}
