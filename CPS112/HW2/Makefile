all: Creature.class Square.class World.class 

Square.class: Square.java
	javac Square.java

World.class: World.java Creature.class
	javac World.java

Creature.class: Creature.java
	javac Creature.java

clean:
	rm *.class
