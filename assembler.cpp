#include <bits/stdc++.h>

using namespace std;

map<string,string> binaryRamInstructions{
  //{"instruction_name", bitset<4>(string("0000"))},
  {"loadA", "0"},
  {"storeA", "1"},
  {"addA", "2"},
  {"subA", "3"},
  {"inA", "4"},
  {"outA", "5"}
};

map<string,string> binaryRomInstructions{
  {"jpos", "6"},
  {"jneg", "7"},
  {"jz", "8"},
  {"jnz", "9"},
  {"jmp", "A"},
  {"halt", "B"}
};

int variables_number = 0;

vector<string> tokenize(string line) {
    vector<string> tokens;
    string aux;
    stringstream stream(line);
    while(getline(stream, aux, ' '))
        tokens.push_back(aux);
    return tokens;
}

void configureData(map<string, pair<bitset<6>,int>> *variables, vector<string> tokens) {
    int int_value = 0;
    if(tokens.size() == 2)
        int_value = atoi((tokens[1]).c_str());
    bitset<6> direction(variables_number);
    pair<bitset<6>,int> value;
    value.first = direction;
    value.second = int_value;
    (*variables)[tokens[0]] = value;
    variables_number += 1;
}

void configureProgram(vector<pair<string,string>> *instructions, vector<string> tokens) {
    pair<string, string> instruction;
    instruction.first = tokens[0];
    if(tokens.size() == 2) instruction.second = tokens[1];
    (*instructions).push_back(instruction);
}

void configureProgramReferences(map<string, bitset<6>> *references, vector<string> tokens) {
    (*references)[tokens[0]] = bitset<6>(atoi(tokens[1].c_str()));
}

void writeRam(ofstream *file, map<string,pair<bitset<6>,int>> *variables){
    map<string,pair<bitset<6>,int>>::iterator it = (*variables).begin();
    stringstream init_value;
    (*file) << "(\n";
    for(int i = 0; i < variables_number; i++){
    	if((it->second).second != 0) {
    		init_value.str("");
    		init_value << hex << uppercase << bitset<4>((it->second).second).to_ulong();
        	(*file) << i << " => X\"" << init_value.str() << "\",\n";
        }
		it++;
    }
    (*file) << "others => X\"0\"";
    (*file) << "\n)\n";
}

void writeRom(ofstream *file, map<string,pair<bitset<6>,int>> *variables, map<string, bitset<6>> *references, vector<pair<string,string>> *instructions){
    string binary_option;
    bitset<8> operand;
    stringstream operand_stream;
    (*file) << "(\n";
    for(int i = 0; i < (*instructions).size(); i++){
    	operand_stream.str("");
        if((*instructions)[i].first[0] == 'j' || (*instructions)[i].first[0] == 'h'){
            binary_option = binaryRomInstructions[(*instructions)[i].first];
            operand = (*instructions)[i].second != "" ? bitset<8>((*references)[(*instructions)[i].second].to_ulong()) : bitset<8>();
        }else{
            binary_option = binaryRamInstructions[(*instructions)[i].first];
            operand = (*instructions)[i].second != "" ? bitset<8>((*variables)[(*instructions)[i].second].first.to_ulong()): bitset<8>();
        }
        operand_stream << hex << uppercase << operand.to_ulong();
        (*file) << i << " => X\"" << binary_option << ((operand.to_ulong() < 16) ? "0" : "") << operand_stream.str() << "\",\n";
    }
    (*file) << "others => X\"000\"";
    (*file) << "\n)\n";
}

void writeProgram(string fileName, map<string,pair<bitset<6>,int>> *variables, map<string, bitset<6>> *references, vector<pair<string,string>> *instructions) {
    ofstream file;
    stringstream sstream(fileName);
    string aux;
    getline(sstream, aux, '.');
    file.open(aux + ".as");
    file << ".data\n";
    writeRam(&file, variables);
    file << "\n.code\n";
    writeRom(&file, variables, references, instructions);
    file.close();
}

int main(int argc, char** argv) {
    map<string,pair<bitset<6>,int>> variables;
    map<string,bitset<6>> references;
    vector<pair<string,string>> instructions;
    vector<string> tokens;
    string line;
    string fileName(argv[1]);
    cout << "file name is : " + fileName + "\n";
    ifstream programFile;
    programFile.open(fileName);
    if(programFile.good()){
        getline(programFile, line);
        if(line == ".data"){
            cout << "parsing data\n";
            while(line != ""){
                getline(programFile, line);
                if(line != "")
                    configureData(&variables, tokenize(line));
            }
            cout << "data parsed\n";
            while (line == "")
                getline(programFile, line);
            if(line == ".references"){
                cout << "parsing references\n";
                while(line != ""){
                    getline(programFile, line);
                    if(line != "")
                        configureProgramReferences(&references, tokenize(line));
                }
                cout << "references parsed\n";
                while (line == "")
                    getline(programFile, line);
            }else{
                cout << "there is no .references section\n";
            }
            if(line == ".code") {
                cout << "parsing code\n";
                while(line != ""){
                    getline(programFile, line);
                    if(line != "")
                        configureProgram(&instructions, tokenize(line));
                }
                cout << "code parsed\n";
            }else{
                cout << "there is no .code section\n";
            }
            writeProgram(fileName, &variables, &references, &instructions);
            cout << "done\n";
        }else{
            cout << "there is no .data section\n";
        }
        programFile.close();
    }else{
        cout << "cannot read the file\n";
    }
}
