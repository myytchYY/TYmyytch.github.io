all: Pair.class HashMap.class TextGenerator.class

Pair.class: Pair.java
	javac Pair.java

HashMap.class:HashMap.java Pair.class
	javac HashMap.java

TextGenerator.class:TextGenerator.java
	javac TextGenerator.java

clean:
	rm *.class
