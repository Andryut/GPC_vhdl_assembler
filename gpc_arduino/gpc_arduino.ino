//bit masks
short instructionMask = 0xF00;
short operandMask = B111111;

//General configuration
byte N = 4;
byte inputsNumber = 2;
byte outputsNumber = 2;
byte romTam = 64;
byte ramTam = 64;

//Pins configuration
byte Din[4] = {3, 2, 16, 17};
byte Dout[4] = {7, 6, 5, 4};
byte inFlags[2] = {9, 8};
byte auxInFlags;
byte outFlags[2] = {11, 10};
byte auxOutFlags;
byte done = 12;
byte clock = 13;
byte enter = 14;
byte reset = 15;

//Internal configuration
enum state{
  loadA = 0,
  storeA = 1,
  addA = 2,
  subA = 3,
  inA = 4,
  outA = 5,
  jpos = 6,
  jneg = 7,
  jz = 8,
  jnz = 9,
  jmp = 10,
  halt = 11,
  fetch = 12
};
state actualState;
byte programCounter;
short instructionRegister;
short actualInstruction;
short actualOperand;
short A;
long clockTime;
int clockState;
int ntr;
int rst;
long debounceDelay;
long lastDebounceEnter;
long lastDebounceReset;


//Program info
short rom[64] = {
0x400,
0x100,
0x400,
0x101,
0x000,
0x301,
0x810,
0x70C,
0x000,
0x301,
0x100,
0xA04,
0x001,
0x300,
0x101,
0xA04,
0x000,
0x500,
0xB00
};
short ram[64] = {
};
byte instructions = 19;
byte variables = 0;
//Program info

void readEnter(){
  if((millis() - lastDebounceEnter) > debounceDelay && digitalRead(enter) == HIGH){
    ntr = HIGH;
  }
}

void readReset(){
  if((millis() - lastDebounceReset) > debounceDelay && digitalRead(reset) == HIGH){
    rst = HIGH;
  }
}

void writeVector(short val, byte* vector, byte n){
  byte bitMask = 1;
  for(int i = 0; i < n; i++) {
    digitalWrite(*(vector + i), (((val & bitMask) != 0) ? HIGH : LOW));
    bitMask = bitMask << 1;
  }
}

void readVector(short* val, byte* vector, byte n){
  byte actualBit;
  (*val) = 0;
  for(int i = 0; i < n; i++) {
    actualBit = digitalRead(*(vector + i));
    actualBit = actualBit << i;
    (*val) += actualBit;
  }
}

void resetInput(bool init) {
  for(int i = 0; i < inputsNumber; i++){
    digitalWrite(inFlags[i], LOW);
  }
  if(!init) auxInFlags = auxInFlags << 1;
  else auxInFlags = 1;
}

void resetOutput(bool init) {
  for(int i = 0; i < N; i++){
    digitalWrite(Dout[i], LOW);
  }
  for(int i = 0; i < outputsNumber; i++){
    digitalWrite(outFlags[i], LOW);
  }
  if(!init) auxOutFlags = auxOutFlags << 1;
  else auxOutFlags = 1;
}

void writeA(){
  writeVector(auxOutFlags, outFlags, outputsNumber);
  writeVector(A, Dout, N);
  readEnter();
  if(ntr == HIGH) {
    resetOutput(false);
    actualState = fetch;
    ntr = LOW;
  }
}

void readA(){
  writeVector(auxInFlags, inFlags, inputsNumber);
  readEnter();
  if(ntr == HIGH) {
    readVector(&A, Din, N);
    resetInput(false);
    actualState = fetch;
    ntr = LOW;
  }
}

void decodeInstruction() {
  actualInstruction = instructionRegister & instructionMask;
  actualOperand = instructionRegister & operandMask;
  actualInstruction = actualInstruction >> 8;
}

void execute() {
  switch(actualState){
    case fetch:
      instructionRegister = rom[programCounter];
      decodeInstruction();
      programCounter++;
      actualState = actualInstruction;
      break;
    case loadA:
      A = ram[actualOperand];
      actualState = fetch;
      break;
    case storeA:
      ram[actualOperand] = A;
      actualState = fetch;
      break;
    case addA:
      A += ram[actualOperand];
      actualState = fetch;
      break;
    case subA:
      A -= ram[actualOperand];
      actualState = fetch;
      break;
    case inA:
      readA();
      break;
    case outA:
      writeA();
      break;
    case jpos:
      if(A>0){
        programCounter = actualOperand;
      }
      actualState = fetch;
      break;
    case jneg:
      if(A<0){
        programCounter = actualOperand;
      }
      actualState = fetch;
      break;
    case jz:
      if(A==0){
        programCounter = actualOperand;
      }
      actualState = fetch;
      break;
    case jnz:
      if(A!=0){
        programCounter = actualOperand;
      }
      actualState = fetch;
      break;
    case jmp:
    programCounter = actualOperand;
      actualState = fetch;
      break;
    case halt:
      digitalWrite(done, HIGH);
      delay(100);
      break;
  }
}

void initialize() {
  programCounter = 0;
  A = 0;
  actualState = fetch;
  resetOutput(true);
  resetInput(true);
  digitalWrite(done, LOW);
}

void setup() {
  //Serial.begin(9600);
  for(int i = 0; i < romTam; i++){
    rom[i] = i < instructions ? rom[i] : 0; 
  }
  for(int i = 0; i < ramTam; i++){
    ram[i] = i < variables ? ram[i] : 0;
  }
  for(int i = 0; i < N; i++){
    pinMode(Din[i], INPUT);
    pinMode(Dout[i], OUTPUT);
  }
  for(int i = 0; i < inputsNumber; i++){
    pinMode(inFlags[i], OUTPUT);
  }
  for(int i = 0; i < outputsNumber; i++){
    pinMode(outFlags[i], OUTPUT);
  }
  pinMode(clock, OUTPUT);
  pinMode(done, OUTPUT);
  pinMode(enter, INPUT);
  pinMode(reset, INPUT);
  initialize();
  clockTime = 0;
  debounceDelay = 200;
  lastDebounceEnter = 0;
  lastDebounceReset = 0;
  clockState = HIGH;
}

void loop() {
  readReset();
  if(rst == HIGH){
    initialize();
    rst = LOW;
  } else {
    execute();
  }
  if(clockTime % 5000 == 0){
    clockState = (clockState == LOW) ? HIGH : LOW;
    digitalWrite(clock, clockState);
  }
  clockTime++;
}
