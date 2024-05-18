#include <iostream>
#include <string>
#include <bitset>
#include <fstream>
#include <algorithm>

using namespace std;

// Function declarations
void processInstruction(string Rdest, string Rsrc1, string Rsrc2, string& instcode, ofstream& fileout, int& firstOperandFlag, int& secondOperandFlag, int& thirdOperandFlag, int& counter, string& counterstring);
void getImmediatevalue(int& counter, string& immediatevaluebin, ofstream& fileout, string& counterstring);
void ReadFile(string fileinName);
string decimalToBinary(char num);
string getopCode(string instruction);
string hextobinary(string hex);

int main()
{
    string filename;
    cout << "Please enter assembly code filename: ";
    cin >> filename;
    ReadFile(filename);
}

// Function to process instructions with no operands
void processInstruction(string Rdest, string Rsrc1, string Rsrc2, string& instcode, ofstream& fileout, int& firstOperandFlag, int& secondOperandFlag, int& thirdOperandFlag, int& counter, string& counterstring)
{
    instcode.append(Rdest);
    instcode.append(Rsrc1);
    instcode.append(Rsrc2);
    instcode.append("0"); // unused bit
    firstOperandFlag = 0;
    secondOperandFlag = 0;
    thirdOperandFlag = 0;
    fileout << counterstring << ": ";
    fileout << instcode << endl;
    counter++; // prepares for the next instruction
}

// Function to process instructions with immediate values
void getImmediatevalue(int& counter, string& immediatevaluebin, ofstream& fileout, string& counterstring)
{
    if (counter / 10 == 0)
    {
        counterstring = "  " + to_string(counter);
    }
    else if (counter / 100 == 0)
    {
        counterstring = " " + to_string(counter);
    }
    else
    {
        counterstring = to_string(counter);
    }
    fileout << counterstring << ": ";
    fileout << immediatevaluebin << endl; // prints immediate value on a new line
    counter++;                            // prepares for the next instruction
}

// Function to convert decimal digits to binary string
string decimalToBinary(char num)
{
    if (num == '0')
    {
        return "000";
    }
    else if (num == '1')
    {
        return "001";
    }
    else if (num == '2')
    {
        return "010";
    }
    else if (num == '3')
    {
        return "011";
    }
    else if (num == '4')
    {
        return "100";
    }
    else if (num == '5')
    {
        return "101";
    }
    else if (num == '6')
    {
        return "110";
    }
    else if (num == '7')
    {
        return "111";
    }
    else
    {
        return "XXX"; // Error condition
    }
}

// Function to get the opcode for an instruction
string getopCode(string instruction)
{
    if (instruction == "NOP")
    {
        return "000000";
    }
    else if (instruction == "NOT")
    {
        return "000001";
    }
    else if (instruction == "NEG")
    {
        return "000010";
    }
    else if (instruction == "INC")
    {
        return "000011";
    }
    else if (instruction == "DEC")
    {
        return "000100";
    }
    else if (instruction == "ADD")
    {
        return "000101";
    }
    else if (instruction == "SUB")
    {
        return "000110";
    }
    else if (instruction == "CMP")
    {
        return "000111";
    }
    else if (instruction == "OR")
    {
        return "001000";
    }
    else if (instruction == "XOR")
    {
        return "001001";
    }
    else if (instruction == "AND")
    {
        return "001010";
    }
    else if (instruction == "PUSH")
    {
        return "001011";
    }
    else if (instruction == "POP")
    {
        return "001100";
    }
    else if (instruction == "LDM")
    {
        return "010010";
    }
    else if (instruction == "LDD")
    {
        return "010011";
    }
    else if (instruction == "STD")
    {
        return "010100";
    }
    else if (instruction == "ADDI")
    {
        return "010101";
    }
    else if (instruction == "SUBI")
    {
        return "010110";
    }
    else if (instruction == "JZ")
    {
        return "100000";
    }
    else if (instruction == "JMP")
    {
        return "100001";
    }
    else if (instruction == "CALL")
    {
        return "100010";
    }
    else if (instruction == "RET")
    {
        return "100011";
    }
    else if (instruction == "RTI")
    {
        return "100100";
    }
    else if (instruction == "OUT")
    {
        return "110000";
    }
    else if (instruction == "IN")
    {
        return "110001";
    }
    else if (instruction == "MOV")
    {
        return "110010";
    }
    else if (instruction == "SWAP")
    {
        return "110011";
    }
    else if (instruction == "PROTECT")
    {
        return "110100";
    }
    else if (instruction == "FREE")
    {
        return "110101";
    }
}

// Function to convert hexadecimal string to binary string
string hextobinary(string hex)
{
    int num = stoi(hex, nullptr, 16);
    bitset<16> binary(num);
    return binary.to_string();
}

// Function to read assembly code from a file and process it
void ReadFile(string fileinName)
{
    string instruction;
    ifstream filein;
    ofstream fileout;
    filein.open(fileinName);
    fileout.open("testingout.mem");
    fileout << "// memory data file (do not edit the following line - required for mem load use)" << endl;
    fileout << "// instance=/processor/f1/m1/ram" << endl;
    fileout << "// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1" << endl;
    string instcode;
    string Rdest;
    string Rsrc1;
    string Rsrc2;
    string firstOperand;
    string secondOperand;
    string thirdOperand;
    int firstOperandFlag = 0;
    int secondOperandFlag = 0;
    int thirdOperandFlag = 0;
    string temp;
    string trash;
    int counter = 0;
    string counterstring;
    string orgcount;
    string immediatevaluehex;
    string immediatevaluebin;

    while (1) // Keeps reading until end of file
    {
        if (counter / 10 == 0)
        {
            counterstring = "  " + to_string(counter);
        }
        else if (counter / 100 == 0)
        {
            counterstring = " " + to_string(counter);
        }
        else
        {
            counterstring = to_string(counter);
        }
        filein >> instruction;
        if (instruction[0] == '#') // Check if it is a commented line
        {
            getline(filein, trash); // Skip the rest of the line
        }
        std::transform(instruction.begin(), instruction.end(), instruction.begin(), ::toupper); // Convert to uppercase
        if (instruction == ".ORG")
        {
            filein >> orgcount;
            counter = stoi(orgcount, nullptr, 16); // Change counter value
        }

        // Process instructions with no operands
        if (instruction == "NOP" || instruction == "RET" || instruction == "RTI")
        {
            instcode = getopCode(instruction);
            processInstruction("000", "000", "000", instcode, fileout, firstOperandFlag, secondOperandFlag, thirdOperandFlag, counter, counterstring);
        }
        // Process instructions with one operand
        else if (instruction == "INC" || instruction == "NOT" || instruction == "DEC" || instruction == "NEG" || instruction == "POP" || instruction == "IN" || instruction == "PUSH" || instruction == "OUT" || instruction == "JZ" || instruction == "JMP" || instruction == "CALL" || instruction == "LDM" || instruction == "PROTECT" || instruction == "FREE")
        {
            instcode = getopCode(instruction);
            char readchar;
            while (1)
            {
                readchar = filein.get(); // Read character by character
                if (readchar == ' ' || readchar == ',')
                {
                    continue;
                }
                else if (readchar == 'R')
                {
                    readchar = filein.get();
                    temp = decimalToBinary(readchar);
                    if (firstOperandFlag == 0)
                    {
                        if (temp != "XXX")
                        {
                            firstOperand = temp;
                            firstOperandFlag = 1;
                            if (instruction != "LDM")
                            {
                                break;
                            }
                        }
                        else
                        {
                            firstOperand = temp;
                            // Print an error message for invalid operands
                        }
                    }
                }
                else // Read immediate value
                {
                    if (instruction == "LDM")
                    {
                        filein.unget();              // Go back one step
                        filein >> immediatevaluehex; // Receive immediate value
                        immediatevaluebin = hextobinary(immediatevaluehex);
                        break;
                    }
                }
            }
            if (instruction == "INC" || instruction == "NOT" || instruction == "DEC" || instruction == "NEG" || instruction == "POP" || instruction == "IN")
            {
                Rdest = firstOperand;
                Rsrc1 = firstOperand;
                Rsrc2 = "000";
            }
            else if (instruction == "PUSH" || instruction == "OUT" || instruction == "JZ" || instruction == "JMP" || instruction == "CALL" || instruction == "PROTECT" || instruction == "FREE")
            {
                Rdest = "000";
                Rsrc1 = firstOperand;
                Rsrc2 = "000";
            }
            else if (instruction == "LDM")
            {
                Rdest = firstOperand;
                Rsrc1 = "000";
                Rsrc2 = "000";
            }
            processInstruction(Rdest, Rsrc1, Rsrc2, instcode, fileout, firstOperandFlag, secondOperandFlag, thirdOperandFlag, counter, counterstring);
            if (instruction == "LDM")
            {
                getImmediatevalue(counter, immediatevaluebin, fileout, counterstring);
            }
        }
        // Process instructions with two operands
        else if (instruction == "STD" || instruction == "LDD" || instruction == "MOV" || instruction == "SWAP" || instruction == "CMP" || instruction == "ADDI" || instruction == "SUBI")
        {
            instcode = getopCode(instruction);
            char readchar;
            while (1)
            {
                readchar = filein.get(); // Read character by character
                if (readchar == ' ' || readchar == ',')
                {
                    continue;
                }
                else if (readchar == 'R')
                {
                    readchar = filein.get();
                    temp = decimalToBinary(readchar);
                    if (firstOperandFlag == 0)
                    {
                        if (temp != "XXX")
                        {
                            firstOperand = temp;
                            firstOperandFlag = 1;
                        }
                        else
                        {
                            firstOperand = temp;
                            // Print an error message for invalid operands
                        }
                    }
                    else if (secondOperandFlag == 0)
                    {
                        if (temp != "XXX")
                        {
                            secondOperand = temp;
                            secondOperandFlag = 1;
                            if (instruction == "MOV" || instruction == "SWAP" || instruction == "CMP")
                            {
                                break; // Finished decoding the instruction
                            }
                        }
                        else
                        {
                            secondOperand = temp;
                            // Print an error message for invalid operands
                        }
                    }
                }
                else // Read immediate value
                {
                    if (instruction == "STD" || instruction == "LDD" || instruction == "ADDI" || instruction == "SUBI")
                    {
                        filein.unget();              // Go back one step
                        filein >> immediatevaluehex; // Receive immediate value
                        immediatevaluebin = hextobinary(immediatevaluehex);
                        if (instruction == "STD" || instruction == "LDD")
                        {
                            std::size_t pos = immediatevaluehex.find('('); // Find the position of the first '('

                            if (pos != std::string::npos) { // Check if '(' is found
                                std::string firstPart = immediatevaluehex.substr(0, pos); // Extract substring up to '('
                                std::size_t endPos = immediatevaluehex.find(')'); // Find the position of the first ')'

                                if (endPos != std::string::npos) { // Check if ')' is found
                                    std::string secondPart = immediatevaluehex.substr(pos + 2, endPos - pos - 2); // Extract substring between '(' and ')'
                                    secondOperand = decimalToBinary(secondPart[0]);
                                    immediatevaluebin = hextobinary(firstPart);

                                    // Extract the numeric part from secondPart (which is "R5")
                                }
                            }
                            
                        }
                        break;
                    }
                }
            }
            if (instruction == "LDD")
            {
                Rdest = firstOperand;
                Rsrc1 = secondOperand;
                Rsrc2 = "000";
            }
            else if ( instruction == "CMP")
            {
                Rdest = "000";
                Rsrc1 = firstOperand;
                Rsrc2 = secondOperand;
            }
            else if (instruction == "STD")
            {
                Rdest = "000";
                Rsrc1 = secondOperand;
                Rsrc2 = firstOperand;
            }
            else if (instruction == "MOV" || instruction == "ADDI" || instruction == "SUBI")
            {
                Rdest = firstOperand;
                Rsrc1 = secondOperand;
                Rsrc2 = "000";
            }
            else if (instruction == "SWAP")
            {
                Rdest = firstOperand;
                Rsrc1 = secondOperand;
                Rsrc2 = firstOperand;
            }
            processInstruction(Rdest, Rsrc1, Rsrc2, instcode, fileout, firstOperandFlag, secondOperandFlag, thirdOperandFlag, counter, counterstring);
            if (instruction == "LDD" || instruction == "STD" || instruction == "ADDI" || instruction == "SUBI")
            {
                getImmediatevalue(counter, immediatevaluebin, fileout, counterstring);
            }
        }
        // Process instructions with three operands
        else if (instruction == "ADD" || instruction == "AND" || instruction == "OR" || instruction == "SUB" || instruction == "XOR")
        {
            instcode = getopCode(instruction);
            char readchar;
            while (1)
            {
                readchar = filein.get(); // Read character by character
                if (readchar == ' ' || readchar == ',')
                {
                    continue;
                }
                else if (readchar == 'R')
                {
                    readchar = filein.get();
                    temp = decimalToBinary(readchar);
                    if (firstOperandFlag == 0)
                    {
                        if (temp != "XXX")
                        {
                            firstOperand = temp;
                            firstOperandFlag = 1;
                        }
                        else
                        {
                            firstOperand = temp;
                            // Print an error message for invalid operands
                        }
                    }
                    else if (secondOperandFlag == 0)
                    {
                        if (temp != "XXX")
                        {
                            secondOperand = temp;
                            secondOperandFlag = 1;
                        }
                        else
                        {
                            secondOperand = temp;
                            // Print an error message for invalid operands
                        }
                    }
                    else if (thirdOperandFlag == 0)
                    {
                        if (temp != "XXX")
                        {
                            thirdOperand = temp;
                            thirdOperandFlag = 1;
                            break; // Finished decoding the instruction
                        }
                        else
                        {
                            thirdOperand = temp;
                            // Print an error message for invalid operands
                        }
                    }
                }
            }
            processInstruction(firstOperand, secondOperand, thirdOperand, instcode, fileout, firstOperandFlag, secondOperandFlag, thirdOperandFlag, counter, counterstring);
        }
        else if (instruction[0] != '#' && instruction != ".ORG")
        {
            immediatevaluebin = hextobinary(instruction);
            fileout << counterstring << ": ";
            fileout << immediatevaluebin << endl; // Print immediate value on a new line
            counter++;                            // Prepare for the next instruction
        }

        if (filein.peek() == EOF)
        {
            break;
        }
    } // End of while loop
    filein.close();
    fileout.close();
}