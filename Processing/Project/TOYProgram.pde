//Tag ID Values
// 17 MOV
// 18 PRINT
// 19 LABEL
// 20 JNZ
// 21 ADD
// 22 SUB

// 23 RUN
// 24 BINARY
// 25 ASSEMBLY

// 26 0
// 27 1
// 28 2
// 29 3
// 30 4
// 31 5
// 32 6
// 33 7
// 34 8
// 35 9

import java.util.List;
import java.util.ArrayList;
import java.util.Hashtable;
import java.io.*;

public class TOYProgram implements Application {
    private int[] registers;
    private List<TagRow> commands;
    private Hashtable<String, Integer> jumps;
    private boolean isRunning;
    private int eip;
    private float last_time;
    private Assembly assembly;
    private PGraphics pgraph;

    private String MapId(int id) {
       if (id == 17)
         return "MOV";
       else if (id == 18)
         return "PRINT";
       else if (id == 19)
         return "LABEL";
       else if (id == 20)
         return "JNZ";
       else if (id == 21)
         return "ADD";
       else if (id == 22)
         return "SUB";
       else if (id == 23)
         return "RUN";
       else if (id == 24)
         return "BINARY";
       else if (id == 25)
         return "ASSEMBLY";
       else {
         Integer ret = id - 26;
         return ret.toString();
       }  
    }
    
    public TOYProgram() {
      this.registers = new int[4];
    }
    
    public void init(int im_width, int im_height) {
      this.registers = new int[4];
      for (int i = 0; i < registers.length; i++) {
        registers[i] = 0;
      }
      this.isRunning = false;
      this.last_time = System.currentTimeMillis();
      this.eip = 0;
      this.assembly = new Assembly(im_width, im_height);
    }
    
    // called every time in the draw loop
    public void update(TagLibrary newCommands, PGraphics pg) {
        this.pgraph = pg;
        if (System.currentTimeMillis() - last_time > 1000) {
            System.out.println(newCommands.getTagRows());
        }
        if (!isRunning) {
           commands = newCommands.getTagRows();
           eip = 0;
           // see if run tag
           List<Tag> run = newCommands.getTags(23);
           
           if (run != null) {
              isRunning = true;
              last_time = System.currentTimeMillis();
              Step();
           }
           assembly.update(pg, registers); 
        }
        else {
           // see if execute another step
           if (last_time - System.currentTimeMillis() > 1000.0) {
              last_time = System.currentTimeMillis();
              Step();
              println("Executed one step");
                           
              // update Assembly
              assembly.update(pg, registers);
           } 
           return;
        }
    }
    
    private boolean isInteger(String arg) {
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
        assembly.add_output(Integer.parseInt(arg1));        
      }
      // } else {
      //   System.err.println("Error with second tag on line: " + eip);
      // }
      println("Reached printCommand");
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
      println("In Step function");
      TagRow line = commands.get(eip);
      String command = MapId(line.get(0).id);
      if (command.equals("MOV")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          movCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("PRINT")) {
        if (line.size() != 2) {
          System.err.println("Error with number of arguments on line: " + eip);
          println("Error with number of arguments for print");
        }else
          printCommand(MapId(line.get(1).id));
        println("Read print command");
      }
      else if (command.equals("ADD")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          addCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("SUB")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          subCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("JNZ")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          jnzCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("LABEL")) {
        if (line.size() != 2)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          labelCommand(MapId(line.get(1).id));
      }
      else if (command.equals("RUN") || command.equals("ASSEMBLY")) {
         // ignore these tagRows 
      }
      else {
        System.err.println("Command not found: " + command);
      }
    }
}
