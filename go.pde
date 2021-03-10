import processing.serial.*;

Serial port;              //последовательный порт
String received;          //строка для получаемых данных
int x,dist,rd;            //положение сервопривода, расстояние
float xx,yy;              
boolean power=false;      //состояние радара
int w = 300;              //расстояние датчика (150*2)
int radius = 400;         //центр окружностей, для построения радара
int[] cords = new int[20];//массив для расстояний
PFont myFont;             //стиль текста

void setup()
{
  background(1);        //создание окна
  size(800, 450);
  myFont = createFont("verdana", 12);  //создание стиля для текста
  textFont(myFont);
  String port1 = port.list()[0];       //настраиваем последовательный порт
  port = new Serial(this,port1, 9600); //для связи с устройством
  port.bufferUntil('\n');              //вместо port1 можно вписать необходимый
}

//процедура обработки нажатия клавиш
void keyPressed()
{
    if (key == 'f') { //запуск радара
    power=true;
    port.write('1');
    println("start");    
    } 
    if (key == 'g') {  //остановка радара
    power=false;
    port.write('2');
    println("stop");
    }
    if (key == 'h') { //начальное положение
    power=false;
    port.write('3');
    clear();          //отчистка экрана
    x=0; dist=0;      //отчистка данных
    for (int i=0; i<18; i++) {
      cords[i]=0;}
    println("S_position");
    }
}

//процедура вызываемая, как бесконечный цикл
void draw()
{
  osnova();    //отрисовываем основные элементы (радар,тексты)
  poisk();     //отрисовка стрелки радара и припятствий

  if ( port.available() > 0) { // если есть данные,
    // считываем их и записываем в переменную received
    received = port.readStringUntil('\n');
    received = trim(received);       
  if (received != null) {               //если что-то считалось
    int[] values = int(split(received, ' ')); //разбиваем строку
    dist = values[0];               //записываем в соответствующие переменные
    x = values[1];
    cords[x/10] = dist;
  }
  //обратная связь
  //отсылаем 1, когда закончили отрисовку и считывание
  //и при условии работы устройства
  if (power==true) {port.write('1');} 
  if (power==false) {port.write('2');}
  }
} 

//процедура отрисовки стрелки радара и припятствий
void poisk() {
//стрелка
    strokeWeight(1);
    stroke(0, 180, 0); 
    line(radius, radius, radius + cos(radians(x+(180.5)))*w, radius + sin(radians(x+(180.5)))*w);
    strokeWeight(2);
    stroke(0, 200, 0); 
    line(radius, radius, radius + cos(radians(x+(180)))*w, radius + sin(radians(x+(180)))*w);
    strokeWeight(1);
    stroke(0, 180, 0); 
    line(radius, radius, radius + cos(radians(x+(179.5)))*w, radius + sin(radians(x+(179.5)))*w);
//припятствия
  for (int i=0; i<18; i++) {
    if (cords[i]>0) {
      xx=radius + (cos(radians(i*10+(180)))*(cords[i]*2));
      yy=radius + (sin(radians(i*10+(180)))*(cords[i]*2));
      strokeWeight(8);
      stroke(200, 0, 0);
      line(xx,yy,xx,yy);
  }
}
}

//процедура отрисовки радара и текстов
void osnova() {
  ellipse(350, 420, 1400, 1400); //область для заданного стиля
  rectMode(CENTER);
//полуокружности
  for (int i = 0; i <=6; i++){
    noFill();
    strokeWeight(1);
    stroke(0, 150, 0);
    ellipse(400, 400, (100*i), (100*i));
    //подписи расстояния
    fill(0, 100, 0);
    noStroke();
    text(Integer.toString(rd), 430, (405-rd*2), 50, 50);
    rd+=25;
    }
  rd = 0;
//угол поворота
  for (int i = 0; i <= 6; i++) {
    strokeWeight(1);
    stroke(0, 90, 0);
    line(400, 400, radius + cos(radians(180+(30*i)))*w, radius + sin(radians(180+(30*i)))*w);
    fill(0, 100, 0);
    noStroke();
//подписи углов
  if (0+(30*i) >= 120) {
    text(Integer.toString(0+(30*i)), (radius+10) + cos(radians(180+(30*i)))*(w+10), (radius+10) + sin(radians(180+(30*i)))*(w+10), 25,50);
  } 
  else {
    text(Integer.toString(0+(30*i)), radius + cos(radians(180+(30*i)))*w, radius + sin(radians(180+(30*i)))*w, 60,40);
}}
//Тексты
  fill(0);
  rect(350,440,800,78);//необходим для закраски лишних элементов
  fill(0, 60, 0);
  text("designed by 521725 group P&D", 10,20); 
  fill(0, 100, 0);
  text("Угол/Градус: "+Integer.toString(x), 220,35);        
  text("Дистанция: "+Integer.toString(dist), 220,55);         
  text("RADAR", 380, 20);
  text("Нажмите на клавитуре:", 600, 20);
  text("f (а) - запуск", 600, 40);
  text("g (п) - остановка", 600, 60);
  text("h (р) - начальная позиция", 600, 80);
  fill(0, 100, 0);
  rect(400,40,100,30,10);
  fill(0);
  if (power==false) {text("OFF", 388, 45);}
  else {text("ON", 388, 45);}
}
