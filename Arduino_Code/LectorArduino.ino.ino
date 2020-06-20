//pins
const int Rbutton=5;
const int Lbutton=6;
const int Startbutton=7;
const int SW_pin = 4;

//pins analogicos 
const int X_pin = 1;
const int Y_pin = 2; 

void setup() {
  pinMode(SW_pin, INPUT);
  pinMode(Rbutton,INPUT);
  pinMode(Lbutton,INPUT);
  pinMode(Startbutton,INPUT);
  digitalWrite(SW_pin, HIGH);
  
  Serial.begin(9600);
}

void loop() {
  /*int readX=analogRead(X_pin);
  int readRB=digitalRead(Rbutton)+"";
  int readLB=digitalRead(Lbutton)+"";
  Serial.println(readX+readRB+ readLB);*/
  
  Serial.print(analogRead(Y_pin));
  Serial.print("-");
  Serial.print(analogRead(X_pin));
  Serial.print("-");
  Serial.print(digitalRead(Rbutton));
  Serial.print("-");
  Serial.print(digitalRead(Lbutton));
  Serial.print("-");
  Serial.print(digitalRead(Startbutton));
  Serial.println("-");
  delay(100);
}
