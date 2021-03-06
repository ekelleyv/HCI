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
    private List<TagRow> commandsForAssembly;
    private Hashtable<String, Integer> jumps;
    private boolean isRunning = false;
    private boolean compiled = false;
    private int eip;
    private long last_time;
    private Assembly assembly;
    private int total_length;
    private boolean error_glob = false;

    private String MapId(int id) {
       if (id < 6) 
         return "0";
       else if (id < 12)
         return "1";
       else if (id < 18)
         return "2";
       else if (id < 24)
         return "3";
       else if (id < 30)
         return "4";
       else if (id < 36)
         return "5";
       else if (id < 42)
         return "6";
       else if (id < 48)
         return "7";
       else if (id < 54)
         return "8";
       else if (id < 60)
         return "9";
       else if (id < 66)
         return "A";
       else if (id < 72)
         return "B";
       else if (id < 78)
         return "C";
       else if (id < 84)
         return "D";
       else if (id < 90)
         return "E";
       else if (id < 96)
         return "F";
       else if (id < 102)
         return "MOV";
       else if (id < 108)
         return "PRINT";
       else if (id < 114)
         return "LABEL";
       else if (id < 120)
         return "JNZ";
       else if (id < 126)
         return "ADD";
       else if (id < 132)
         return "SUB";
       else if (id < 133)
         return "RUN";
       else if (id < 134)
         return "ASSEMBLY";
       else if (id < 135)
         return "BINARY";
       else if (id < 136)
         return "OCTAL";
       else if (id < 137)
         return "HEX";
       else
         return "DECIMAL";
    }
    
    public TOYProgram() {
      this.registers = new int[4];
      this.isRunning = false;
      this.compiled = false;
    }
    
    public void init(int im_width, int im_height) {
      this.registers = new int[4];
      for (int i = 0; i < registers.length; i++) {
        registers[i] = 0;
      }
      this.isRunning = false;
      this.compiled = false;
      this.last_time = System.currentTimeMillis();
      this.eip = 0;
      this.assembly = new Assembly(im_width, im_height);
      this.total_length = 0;
      this.commandsForAssembly = new ArrayList<TagRow>();
      this.jumps = new Hashtable<String, Integer>();
    }
    
    // called every time in the draw loop
    public void update(TagLibrary newCommands, PGraphics pg) {
        List<Tag> stillRunning = newCommands.getTags(132);
        if (stillRunning == null) {
          compiled = false;
          isRunning = false;
          for (int i = 0; i < registers.length; i++) registers[i] = 0;
          assembly.clear_output();
          if (commands != null)
            commands.clear();
          if (jumps != null)
            jumps.clear();
          if (commandsForAssembly != null)
            commandsForAssembly.clear(); 
        }

        if (!isRunning) {
           commandsForAssembly = new ArrayList<TagRow>();
           commands = newCommands.getTagRows();
           for (TagRow line : commands) {
             if (!(MapId(line.get(0).id).equals("RUN") || MapId(line.get(0).id).equals("ASSEMBLY"))) {
                 commandsForAssembly.add(line);
             }
           }
           this.total_length = commandsForAssembly.size();
           eip = 0;
           // see if run tag
           List<Tag> run = newCommands.getTags(132);
           
           if (run != null) {
              last_time = System.currentTimeMillis();
              Compile();
              compiled = true;
              error_glob = false;
              eip = 0;
              isRunning = true;
           }
        } else if (!error_glob) {
           if (!compiled) {
              Compile();
              compiled = true;
           }
           // see if execute another step
           if (System.currentTimeMillis() - last_time > 1500.0) {
              last_time = System.currentTimeMillis();
              if (eip < this.total_length) step();                       
           } 
        }
        // update Assembly
        assembly.update(pg, registers, commandsForAssembly, eip, isRunning);
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
        String row = Integer.toString(eip);
        String error = row + ": Second tag must be a register";
        assembly.add_output(error);
        error_glob = true;
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
        String row = Integer.toString(eip);
        String error = row + ": Third tag must be a register";
        assembly.add_output(error);
        error_glob = true;
      }
      eip++;
    }
    
    private void printCommand(String arg1) {
      if (arg1.equals("A")) {
        assembly.add_output(Integer.toString(registers[0]));
      } else if (arg1.equals("B")) {
        assembly.add_output(Integer.toString(registers[1]));
      } else if (arg1.equals("C")) {
        assembly.add_output(Integer.toString(registers[2]));
      } else if (arg1.equals("D")) {
        assembly.add_output(Integer.toString(registers[3]));
      } else if (isInteger(arg1)) {
        assembly.add_output(arg1);        
      } else {
        String row = Integer.toString(eip);
        String error = row + ": Second tag must either be a register or an integer literal";
        assembly.add_output(error);
        error_glob = true;
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
        String row = Integer.toString(eip);
        String error = row + ": Second tag must be either a register or an integer literal";
        assembly.add_output(error);
        error_glob = true;
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
        String row = Integer.toString(eip);
        String error = row + ": Third tag must be a register";
        assembly.add_output(error);
        error_glob = true;
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
        String row = Integer.toString(eip);
        String error = row + ": Second tag must be either a register or integer literal";
        assembly.add_output(error);
        error_glob = true;
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
        String row = Integer.toString(eip);
        String error = row + ": Third tag must be a register";
        assembly.add_output(error);
        error_glob = true;
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
      else if (isInteger(arg1))
         registerValue = Integer.parseInt(arg1);
      else {
        String row = Integer.toString(eip);
        String error = row + ": Second tag must be either a register or an integer literal";
        assembly.add_output(error);
        error_glob = true;
      }
      if (registerValue != 0) {
        Integer new_eip = jumps.get(arg2);
        if (new_eip == null) {
          String row = Integer.toString(eip);
          String error = row + ": Label not recognized";
          assembly.add_output(error);
          error_glob = true;
          return;
        }
        eip = new_eip + 1;
      }
      else {
        eip++;
      }
    }
    
    private void labelCommand(String arg1) {
      jumps.put(arg1, eip);
    }
    
    public void Compile() {
      for (TagRow line : commands) {
        String command = MapId(line.get(0).id);
        if (command.equals("MOV")) {
          if (line.size() != 3) {
            String row = Integer.toString(eip);
            String error = row + ": MOV takes 2 arguments";
            assembly.add_output(error);
            error_glob = true;
          }
        }
        else if (command.equals("PRINT")) {
          if (line.size() != 2) {
            String row = Integer.toString(eip);
            String error = row + ": PRINT takes 1 argument";
            assembly.add_output(error);
            error_glob = true;
          }
        }
        else if (command.equals("ADD")) {
          if (line.size() != 3) {
            String row = Integer.toString(eip);
            String error = row + ": ADD takes 2 arguments";
            assembly.add_output(error);
            error_glob = true;
          }
        }
        else if (command.equals("SUB")) {
          if (line.size() != 3) {
            String row = Integer.toString(eip);
            String error = row + ": SUB takes 2 arguments";
            assembly.add_output(error);
            error_glob = true;
          }
        }
        else if (command.equals("JNZ")) {
          if (line.size() != 3) {
            String row = Integer.toString(eip);
            String error = row + ": JNZ takes 2 arguments";
            assembly.add_output(error);
            error_glob = true;
          }
        }  
        else if (command.equals("LABEL")) {
          if (line.size() != 2) {
            String row = Integer.toString(eip);
            String error = row + ": LABEL takes 1 argument";
            assembly.add_output(error);
            error_glob = true;
          }
          labelCommand(MapId(line.get(1).id));
        }
        else if (command.equals("RUN") || command.equals("ASSEMBLY")) {
           // ignore these tagRows 
        }
        else {
          String row = Integer.toString(eip);
          String error = row + ": " + command + " - command not known";
          assembly.add_output(error);
          error_glob = true;
        }
        eip++;
      }
    }
    
    public void step() {
      TagRow line = commands.get(eip);
      String command = MapId(line.get(0).id);
      if (command.equals("MOV")) {
        movCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("PRINT")) {
         printCommand(MapId(line.get(1).id));
      }
      else if (command.equals("ADD")) {
        addCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("SUB")) {
        subCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("JNZ")) {
        jnzCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("LABEL")) {
        // ignore label and increase eip
        eip++;
      }
      else if (command.equals("RUN") || command.equals("ASSEMBLY")) {
         // ignore these tagRows 
      }
    }
}
