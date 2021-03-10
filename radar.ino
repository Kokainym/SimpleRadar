//Подключение библиотек 
#include <NewPing.h>
#include <Servo.h>
// Настройка пинов
#define LED          13     //светодиод
#define TRIGGER_PIN  12     //ультразвуковой датчик
#define ECHO_PIN     11
#define SERV_PIN     9      //сервопривод
#define MAX_DISTANCE 150    //дистанция пинга
Servo srv;                  //создание объект сервопривода
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); //создаем объект УЗ датчик
char com;                   //вспомогательные переменные
int x,x1;
boolean flag1=true;
 
void setup() {              
  Serial.begin(9600);       //настраиваем последовательный порт
  srv.attach(SERV_PIN);     //подключаем сервопривод и устонавливаем его
  srv.write(180);           //в наччальное положение
  x=180;
  pinMode(LED, OUTPUT);     //подключаем светодиод
  pinMode(2, OUTPUT);
  digitalWrite(2,LOW);
}
 
void loop() {
if (Serial.available()) {  //если есть данные счтивыаем их и записываем 
    com = Serial.read();}
  if (com=='1') {           //поступила 1 начинаем работу радара
   while (com=='1') {       //цикл, если не 1 радар остановится
    if(x<=170 && flag1==false) {    //условие для прохода от 0 до 180 градусов
      x=x+10;
      srv.write(x);
      digitalWrite(LED,HIGH);       //мигаем светодиодом
      delay(50);
      digitalWrite(LED,LOW);
      Serial.print(sonar.ping_cm());  //отправляем значения расстояния
      Serial.print(' ');
      Serial.println(180-x);          //и угла поворота сервопривода
      com = Serial.read();
      delay(100);
      if (x==180) {flag1=true;}    //установливаем флаг о прохождении от 0 до 180
    }
    if(x>0 && flag1==true) {      //условие для прохода от 180 до 0 градусов
      x=x-10;                     //логика такая же как и в условии выше
      srv.write(x);
      digitalWrite(LED,HIGH);
      delay(50);
      digitalWrite(LED,LOW);
      Serial.print(sonar.ping_cm());
      Serial.print(' ');
      Serial.println(180-x);    
      com = Serial.read();
      delay(100);
      if (x==0) {flag1=false;}  //установливаем флаг о прохождении от 180 до 0
    }
  }
 }
 if (com=='3') {   //условие для установки сервопривода в начальное положение
  srv.write(180);
  delay (100);
  x=180;
  flag1=true;}
}
