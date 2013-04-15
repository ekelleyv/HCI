import java.util.List;
import java.util.ArrayList;
import java.util.Hashtable;
import java.io.*;

public class TOYProgram {
    private int[] registers;
    private List<List<Tag>> commands;
    private Hashtable<String, Integer> jumps;
    private boolean isRunning;
    private int eip;
    
    public static class Tag {
      private String label;
      
      public Tag(String label) {
        this.label = label;
      }
      
      public String Label() {
        return this.label;
      }
    }
    
    public TOYProgram(List<List<Tag>> commands, Hashtable<String, Integer> jumps) {
        registers = new int[4];
        for (int i = 0; i < this.registers.length; i++) {
            registers[i] = 0;
        }
        this.commands = commands;
        this.isRunning = false;
        this.eip = 0;
        this.jumps = jumps;
    }
    
    private static boolean isInteger(String arg) {
      try {
        int i = Integer.parseInt(arg);
      }
      catch (NumberFormatException e) {
        return false;
      }
      return true;
    }
    
    private void movCommand(String arg1, String arg2) {
      int movNumber = 0;
      if (isInteger(arg1)) {
        movNumber = Integer.parseInt(arg1);
      } else if (arg1.equals("A")) {
        movNumber = registers[0];
      } else if (arg1.equals("B")) {
        movNumber = registers[1];
      } else if (arg1.equals("C")) {
        movNumber = registers[2];
      } else if (arg1.equals("D")) {
        movNumber = registers[3];
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      if (arg2.equals("A")) {
        registers[0] = movNumber;
      } else if (arg2.equals("B")) {
        registers[1] = movNumber;
      } else if (arg2.equals("C")) {
        registers[2] = movNumber;
      } else if (arg2.equals("D")) {
        registers[3] = movNumber;
      } else {
        System.err.println("Error with third tag on line: " + eip);
      }
      eip++;
    }
    
    private void printCommand(String arg1) {
      if (arg1.equals("A")) {
        System.out.println("A: " + registers[0]);
      } else if (arg1.equals("B")) {
        System.out.println("B: " + registers[1]);
      } else if (arg1.equals("C")) {
        System.out.println("C: " + registers[2]);
      } else if (arg1.equals("D")) {
        System.out.println("D: " + registers[3]);
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      eip++;
    }
    
    private void addCommand(String arg1, String arg2) {
      int addNumber = 0;
      if (isInteger(arg1)) {
        addNumber = Integer.parseInt(arg1);
      } else if (arg1.equals("A")) {
        addNumber = registers[0];
      } else if (arg1.equals("B")) {
        addNumber = registers[1];
      } else if (arg1.equals("C")) {
        addNumber = registers[2];
      } else if (arg1.equals("D")) {
        addNumber = registers[3];
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      if (arg2.equals("A")) {
        registers[0] += addNumber;
      } else if (arg2.equals("B")) {
        registers[1] += addNumber;
      } else if (arg2.equals("C")) {
        registers[2] += addNumber;
      } else if (arg2.equals("D")) {
        registers[3] += addNumber;
      } else {
        System.err.println("Error with third tag on line: " + eip);
      }
      eip++;
    }
    
    private void subCommand(String arg1, String arg2) {
      int subNumber = 0;
      if (isInteger(arg1)) {
        subNumber = Integer.parseInt(arg1);
      } else if (arg1.equals("A")) {
        subNumber = registers[0];
      } else if (arg1.equals("B")) {
        subNumber = registers[1];
      } else if (arg1.equals("C")) {
        subNumber = registers[2];
      } else if (arg1.equals("D")) {
        subNumber = registers[3];
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      if (arg2.equals("A")) {
        registers[0] -= subNumber;
      } else if (arg2.equals("B")) {
        registers[1] -= subNumber;
      } else if (arg2.equals("C")) {
        registers[2] -= subNumber;
      } else if (arg2.equals("D")) {
        registers[3] -= subNumber;
      } else {
        System.err.println("Error with third tag on line: " + eip);
      }
      eip++;
    }
    
    private void jnzCommand(String arg1, String arg2) {
      int registerValue = 0;
      if (arg1.equals("A"))
        registerValue = registers[0];
      else if (arg1.equals("B"))
        registerValue = registers[1];
      else if (arg1.equals("C"))
        registerValue = registers[2];
      else if (arg1.equals("D"))
        registerValue = registers[3];
      else 
        System.err.println("Error with  second tag on line: " + eip);
      if (registerValue != 0) {
        Integer new_eip = jumps.get(arg2);
        if (new_eip == null) {
          System.err.println("Label not recognized");
        }
        eip = new_eip + 1;
      }
      else {
        eip++;
      }
    }
    
    private void labelCommand(String arg1) {
      jumps.put(arg1, eip);
      eip++;
    }
    
    public void Step() {
      List<Tag> line = commands.get(eip);
      String command = line.get(0).Label();
      if (command.equals("MOV")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          movCommand(line.get(1).Label(), line.get(2).Label());
      }
      else if (command.equals("PRINT")) {
        if (line.size() != 2)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          printCommand(line.get(1).Label());
      }
      else if (command.equals("ADD")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          addCommand(line.get(1).Label(), line.get(2).Label());
      }
      else if (command.equals("SUB")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          subCommand(line.get(1).Label(), line.get(2).Label());
      }
      else if (command.equals("JNZ")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          jnzCommand(line.get(1).Label(), line.get(2).Label());
      }
      else if (command.equals("LABEL")) {
        if (line.size() != 2)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          labelCommand(line.get(1).Label());
      }
      else {
        System.err.println("Command not found: " + command);
      }
    }
    
    private void printRegisters() {
      System.out.println("Register A: " + registers[0]);
      System.out.println("Register B: " + registers[1]);
      System.out.println("Register C: " + registers[2]);
      System.out.println("Register D: " + registers[3]);
      System.out.println(" ");
    }
    
    public void executeCommands() {
      while (eip != commands.size()) {
        Step();
        printRegisters();
      }
    }    
    
    public static void main(String[] args) {
      BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
      String input;
      List<List<Tag>> commands = new ArrayList<List<Tag>>();
      Hashtable<String, Integer> jumps = new Hashtable<String, Integer>();
      try {
        int lineNumber = 0;
        while ((input = in.readLine()) != null && !input.equals("RUN")) {
          if (!input.startsWith("#")) {
            String[] arguments = input.split(" ");
            List<Tag> line = new ArrayList<Tag>();
            for (int i = 0; i < arguments.length; i++) {
              Tag tag = new Tag(arguments[i]);
              line.add(tag);
            }
            
            commands.add(line);
            
            lineNumber++;
          }
        }
      }
      catch (Exception e) {
        System.err.println("Error reading from standard in");
        return;
      }
      
      TOYProgram toy = new TOYProgram(commands, jumps);
      toy.executeCommands();
    }
}
